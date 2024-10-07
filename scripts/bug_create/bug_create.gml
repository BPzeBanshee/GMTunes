function bug_create_from_buffer(xx,yy,name,bu){
if !buffer_exists(bu) return -1;

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    return -2;
    }

// Get bugz type from file (0: yellow, 1: green, 2: blue, 3: red)
var bugztype = buffer_peek(bu,20,buffer_u16);

// TODO: load info
// tbh we could probably skip this for the proto

// load bug and anim sprites
trace("bug_create({0}): loading ANIM...",name);
var anim = bug_load_anim(bu); with obj_trans tasks++;
trace("bug_create({0}): loading LITE...",name);
var lite = bug_load_lite(bu); with obj_trans tasks++;

// x/y/blend animation data for note hit
trace("bug_create({0}): loading LTXY...",name);
var ltxy = bug_load_ltxy(bu); with obj_trans tasks++;
trace("bug_create({0}): loading LTCC...",name);
var ltcc = bug_load_ltcc(bu); with obj_trans tasks++;

// load sounds
trace("bug_create({0}): loading RIFF...",name);
var snd_struct = bug_load_riff(bu); with obj_trans tasks++;
buffer_delete(bu);

var bug = instance_create_depth(xx,yy,0,obj_bug);
bug.bugzname = name;
bug.bugztype = bugztype;
bug.bugzid = real(string_digits(name)); //instance_number(obj_bug);
bug.spr_up = anim;
//bug.spr_down = anim.spr_down;
//bug.spr_left = anim.spr_left;
//bug.spr_right = anim.spr_right;
bug.ltxy_mode = lite.styl_mode;
bug.ltxy_data = ltxy;
bug.ltcc_data = ltcc;
bug.spr_notehit_tl = lite.spr_notehit_tl;
bug.spr_notehit_tr = lite.spr_notehit_tr;
bug.spr_notehit_bl = lite.spr_notehit_bl;
bug.spr_notehit_br = lite.spr_notehit_br;
bug.snd_struct = snd_struct;
return bug;
}

function bug_create(xx,yy,filehandle){
if !file_exists(filehandle) then return -1;
// Name for debug/metadata purposes
var name = filename_name(filehandle);

// Load file into buffer, do some error checking
var bu = buffer_create(1024,buffer_grow,1);
buffer_load_ext(bu,filehandle,0);
if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    return -2;
    }

var bug = bug_create_from_buffer(xx,yy,name,bu);
return bug;
}

function bug_load_riff_files(dir){
var riff_dir = filename_dir(dir);
var snd = [];
for (var i=0;i<25;i++)
	{
	snd[i] = wav_load(riff_dir+"/"+string(i)+".wav",true);
	}
return snd;
}

function bug_load_anim_files(dir){

var sw = 256 / 8;
var sh = 128 / 4;
var smooth = false;
var removeback = true;
var xo = 16;//sw / 4;
var yo = 16;//sh / 4;
var spr_up;//,spr_down,spr_left,spr_right;
var surf = [];
for (var z = 0; z < 3; z++)
    {
	var buf = sprite_add(dir+"/anim"+string(z)+".png",0,false,false,0,0);
	surf[z] = surface_create(256,128);
	surface_set_target(surf[z]);
	draw_sprite(buf,0,0,0);
	surface_reset_target();
	sprite_delete(buf);
	
	// per issue https://github.com/YoYoGames/GameMaker-Bugs/issues/6165,
	// save subimages as full sprites separately for now.
	// additionally optimise by just using the "up" sprites for now.
	for (var i=0;i<8;i++)
		{
	    spr_up[z][i] = sprite_create_from_surface(surf[z],sw*i,sh,sw,sh,removeback,smooth,xo,yo);
	    //spr_down[z][i] = sprite_create_from_surface(surf[z],sw*i,sh*2,sw,sh,removeback,smooth,xo,yo);
	    //spr_left[z][i] = sprite_create_from_surface(surf[z],sw*i,sh*3,sw,sh,removeback,smooth,xo,yo);
		}
		
	surface_free(surf[z]);
    }

return spr_up;
}

function bug_load_lite_files(dir){
// TODO: extract styl_lite mode info first!
var styl_mode,spr_notehit_tl,spr_notehit_tr,spr_notehit_bl,spr_notehit_br;
return {styl_mode,spr_notehit_tl,spr_notehit_tr,spr_notehit_bl,spr_notehit_br};
}

function bug_load_riff(bu){
var offset = 0;
var name = 0;
//var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// Search until "RIFF" is found
if buffer_word(bu,buffer_tell(bu)) != "RIFF"
then do offset += 1 until buffer_word(bu,offset) == "RIFF" || offset >= s2;
offset += 4;
var size,eof,buf,snd;
do
    {
	buffer_seek(bu,buffer_seek_start,offset);
	
    // Establish size of file
	size = buffer_read(bu,buffer_u32);
	//size = buffer_peek(bu,offset+4,buffer_u32); // 4 bytes after RIFF for filesize
    eof = offset + size;
    //trace("RIFF found, offset: "+string(buffer_tell(bu))+", size: "+string(size)+", eof: "+string(eof));
    
    // Copy binary data to buffer until filesize is reached
	buffer_seek(bu,buffer_seek_relative,44);
	size -= 44;
	// TODO: since we're not saving to file here, do we need to keep the metadata?
    buf[name] = buffer_create(size,buffer_fast,1);
    for (var i = 0; i < size;i++) 
		{
		buffer_write(buf[name],buffer_u8,buffer_read(bu,buffer_u8));//buffer_peek(bu,offset+i,buffer_u8));
		}
    
    // Create buffer sounds from given buffer
    snd[name] = audio_create_buffer_sound(buf[name],buffer_u8,11025,0,size,audio_mono);//-44
    name += 1;
    
    // Increment to the next file!
    offset = eof;
    do offset += 1 until buffer_word(bu,offset) == "RIFF" || offset >= s2;
	offset += 4;
    }
until offset >= s2;
return {buf,snd};
}

function bug_load_anim(bu){
var offset = 0;
var name = 0;
//var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// Search until "DRUM" is found
//do offset += 1 until buffer_word(bu,offset) == "DRUM" || offset >= s2;

// "CODE" in YELLOW00.BUG yields same as DRUM value (2), skip to first ANIM
do offset += 1 until buffer_word(bu,offset) == "ANIM" || offset >= s2;
buffer_seek(bu,buffer_seek_start,offset);

var ww = 256;
var hh = 128;
var frames = 2;
var r,g,b,pal,surf;
for (var ff=0; ff<=frames; ff++)
    {
    //var size = buffer_read_be32(bu);
	//var size = buffer_peek_be32(bu,offset+4); // ANIM follows u32
    //var eof = offset + size + 8;
    //trace("ANIM found at "+string(offset)+", possible size: "+string(eof - offset));
	buffer_seek(bu,buffer_seek_relative,52);
	
    // Load palette table (BGR, with a single bit for padding set to 00)
    for (var i = 0; i < 256; i++)
        {
		b[i] = buffer_read(bu,buffer_u8);
		g[i] = buffer_read(bu,buffer_u8);
		r[i] = buffer_read(bu,buffer_u8);
		buffer_read(bu,buffer_u8);
		pal[i] = make_color_rgb(r[i],g[i],b[i]);
        }
        
    // Draw sprite using palette
    surf[ff] = surface_create(ww,hh);
    surface_set_target(surf[ff]);
    draw_clear_alpha(c_black,1);
	draw_set_alpha(1);
	for (var yy = hh-1; yy >= 0; yy--) 
	    {
	    for (var xx = 0; xx < ww; xx++) 
	        {
			draw_point_color(xx,yy,pal[buffer_read(bu,buffer_u8)]);
            }
        }
    //trace("Done rendering bug portrait. Offset end: "+string(offset)+", EOF: "+string(eof));
    surface_reset_target();
    }

// Generate sprites for bug
var sw = ww / 8;
var sh = hh / 4;
var smooth = false;
var removeback = true;
var xo = 16;//sw / 4;
var yo = 16;//sh / 4;
var spr_up;//,spr_down,spr_left,spr_right;
for (var z = 0; z < 3; z++)
    {
	// per issue https://github.com/YoYoGames/GameMaker-Bugs/issues/6165,
	// save subimages as full sprites separately for now.
	// additionally optimise by just using the "up" sprites for now.
	for (var i=0;i<8;i++)
		{
	    spr_up[z][i] = sprite_create_from_surface(surf[z],sw*i,0,sw,sh,removeback,smooth,xo,yo);
	    //spr_right[z][i] = sprite_create_from_surface(surf[z],sw*i,sh,sw,sh,removeback,smooth,xo,yo);
	    //spr_down[z][i] = sprite_create_from_surface(surf[z],sw*i,sh*2,sw,sh,removeback,smooth,xo,yo);
	    //spr_left[z][i] = sprite_create_from_surface(surf[z],sw*i,sh*3,sw,sh,removeback,smooth,xo,yo);
		}
    }
for (var i=0;i<array_length(surf);i++) surface_free(surf[i]);
return spr_up;//{spr_up,spr_down,spr_left,spr_right};
}

function bug_load_lite(bu){
var offset = 0;
var buffer_size = buffer_get_size(bu);

// "STYL", appears to be a RIFF container for note hit sprites and information
//if buffer_word(bu,offset) != "STYL" then 
do offset += 1 until buffer_word(bu,offset) == "STYL" || offset >= buffer_size;
buffer_seek(bu,buffer_seek_start,offset);
buffer_read(bu,buffer_u32); // skip first 4 bytes

var size = buffer_read_be32(bu);// 4 bytes after RIFF for filesize
var eof = buffer_tell(bu) + size;
//trace("STYL found, offset: "+string(offset+8)+", size: "+string(size)+", eof:"+string(eof));
var styl = [];

// First is always 1, skip
array_push(styl,buffer_read_be16(bu));

// Here we obtain draw mode
// 1: speech bubble, 4: keyframe draw with mirrored x/ys, 5: 4 but with rotated x/ys instead of mirrored
var styl_mode = buffer_read_be16(bu);
array_push(styl,styl_mode);
while buffer_tell(bu) < eof array_push(styl,buffer_read_be16(bu));
//trace("STYL Draw Mode: "+string(styl_mode)+", chunk values: "+string(styl));

// "LITE" (animation on note hit sprite)
do offset += 1 until buffer_word(bu,offset) == "LITE" || offset >= buffer_size;

// skip first 4 bytes
offset += 4;
buffer_seek(bu,buffer_seek_start,offset);
 
// Establish size of file
size = buffer_read_be32(bu); // 4 bytes after RIFF for filesize
/*if size % 2 != 0 then repeat (size % 2) 
	{
	//trace("uneven size found, trimming");
	buffer_read(bu,buffer_u8);
	offset = buffer_tell(bu);
	}*/
eof = offset + size;
//trace("LITE found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));

// subimage size in BE16
var width = buffer_read_be16(bu);
var height = buffer_read_be16(bu);
buffer_seek(bu,buffer_seek_relative,6);
//trace("sprite dimensions (subimage): "+string(width)+"x"+string(height));

// unknown value, assumed end of be16 reads
//var unk1 = buffer_read_be16(bu);
//trace("Unknown value #1: "+string(unk1));

// According to lucasvb, the LITE differences end here and the rest should be the same as SHOW

// Magic bullshit number #40
//var unk2 = buffer_read(bu,buffer_u32);
//trace("Unknown value #2: "+string(unk2));

// Establish size of entire sprite frame
var ww = buffer_read(bu,buffer_u32);
var hh = buffer_read(bu,buffer_u32);
if ww == 0 or hh == 0
    {
    show_message("Error reading file (STYL LITE sprite values returned 0)");
    buffer_delete(bu);
    return -1;//instance_destroy();
    }
//else trace("sprite dimensions (full): "+string(ww)+"x"+string(hh));

// Unknown values (BMP header leftover? usually 1,0,8,0)
buffer_seek(bu,buffer_seek_relative,8);
//var unka = [];
//repeat 4 array_push(unka,buffer_read(bu,buffer_u8));
//trace("unk. array #1: "+string(unka));

// 0
//buffer_read(bu,buffer_u32);

// Size of palette table+pixel buffer - headers
var palpixsize = buffer_read(bu,buffer_u32);
//trace("pallete/pixel buffer size - headers: "+string(palpixsize));

// Unknown values (usually 0,0,256,256, palette table dimensions?)
buffer_seek(bu,buffer_seek_relative,16);
//var unkb = [];
//repeat 4 array_push(unkb,buffer_read(bu,buffer_u32));
//trace("unk. array #2: "+string(unkb));

// Load palette table (BGR, with a single bit for padding set to 00)
var r,g,b,pal;
for (var i = 0; i < 256; i++)
    {
	b[i] = buffer_read(bu,buffer_u8);
	g[i] = buffer_read(bu,buffer_u8);
	r[i] = buffer_read(bu,buffer_u8);
	pal[i] = make_color_rgb(r[i],g[i],b[i]);
	buffer_read(bu,buffer_u8); // padding/unused alpha channel
    }
	
//trace(string("remaining byte space according to metadata: {0}",palpixsize));
//trace(string("remaining byte space according to eof: {0}",eof - buffer_tell(bu)));
	
/*spr2 = surface_create(16,16);
surface_set_target(spr2);
draw_clear_alpha(c_black,1);
for (var yy=0;yy<16;yy++)
	{
	for (var xx=0;xx<16;xx++)
		{
		draw_point_color(xx,yy,pallete[xx+(16*yy)]);
		}
	}
surface_reset_target();*/

// These sprites are colour-blended to the color of the playing note (ie. yellow block)
var surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,0);
draw_set_alpha(1);
for (var yy = hh-1; yy >= 0; yy--) 
    {
    for (var xx = 0; xx < ww; xx++) 
        {
		var c = pal[buffer_read(bu,buffer_u8)];
		if c != c_black then draw_point_color(xx,yy,c);
        }
    }
surface_reset_target();

var surf2;
for (var i=0;i<4;i++) surf2[i] = surface_create(width,height);

var spr_notehit_tl,spr_notehit_tr,spr_notehit_bl,spr_notehit_br,a;
a = 0;
for (var yy=0; yy<=height; yy+=height)
for (var xx=0; xx<ww; xx+=width)
	{
	for (var i=0;i<4;i++)
		{
		surface_set_target(surf2[i]);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
		surface_copy_part(surf2[i],0,0,surf,xx,yy+(height*(2*i)),width,height);
		}
	
	// now the frame's assembled, add to sprite
	var removeback = false;
	spr_notehit_tl[a] = sprite_create_from_surface(surf2[0],0,0,width,height,removeback,false,width,height);
	spr_notehit_tr[a] = sprite_create_from_surface(surf2[1],0,0,width,height,removeback,false,0,height);
	spr_notehit_br[a] = sprite_create_from_surface(surf2[2],0,0,width,height,removeback,false,0,0);
	spr_notehit_bl[a] = sprite_create_from_surface(surf2[3],0,0,width,height,removeback,false,width,0);
	a++;
	/*if xx == 0 && yy == 0
		{
		spr_notehit_tl = sprite_create_from_surface(surf2[0],0,0,width,height,removeback,false,width,height);
		spr_notehit_tr = sprite_create_from_surface(surf2[1],0,0,width,height,removeback,false,0,height);
		spr_notehit_br = sprite_create_from_surface(surf2[2],0,0,width,height,removeback,false,0,0);
		spr_notehit_bl = sprite_create_from_surface(surf2[3],0,0,width,height,removeback,false,width,0);
		}
	else 
		{
		sprite_add_from_surface(spr_notehit_tl,surf2[0],0,0,width,height,removeback,false);
		sprite_add_from_surface(spr_notehit_tr,surf2[1],0,0,width,height,removeback,false);
		sprite_add_from_surface(spr_notehit_br,surf2[2],0,0,width,height,removeback,false);
		sprite_add_from_surface(spr_notehit_bl,surf2[3],0,0,width,height,removeback,false);
		}*/
	}
	
// Free surfaces
surface_free(surf);
for (var i=0;i<4;i++) surface_free(surf2[i]);
	
return {styl_mode,spr_notehit_tl,spr_notehit_tr,spr_notehit_bl,spr_notehit_br};
}

function bug_load_ltxy(bu){
var ltxy_data = [];

var offset = 0;
// "LTXY" (animation on note hit sprite)
do offset += 1 until buffer_word(bu,offset) == "LTXY" || offset >= buffer_get_size(bu);
buffer_seek(bu,buffer_seek_start,offset);  
 
// Establish size of file
var count = 0;
while buffer_word(bu,offset)=="LTXY"
	{
	buffer_read(bu,buffer_u32); // skip form
	var size = buffer_read_be32(bu); // 4 bytes after RIFF for filesize
	offset = buffer_tell(bu);
	var eof = offset + size;
	//trace("LTXY found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));
	
	// first commands
	buffer_read_be16(bu); // note number (or 00 on first LTXY, but we keep count of this anyway)
	var command_count = buffer_read_be16(bu); // number of command chunks
	for (var i=0; i<command_count;i++)
		{
		// Key Frame
		ltxy_data[count][i][0] = buffer_read_be16(bu);
		
		// Data fix is needed as some commands on some bugs are actually broken/not masked properly
		// first LTXY is never masked but bugz with only one LTXY are usually speech mode or plain anyway
		// X
		var datafix = 255 - buffer_read(bu,buffer_u8) > 0 ? true : false;
		if datafix
			{
			buffer_read(bu,buffer_u8);
			ltxy_data[count][i][1] = 0;
			}
		else ltxy_data[count][i][1] = 255 - buffer_read(bu,buffer_u8);
			
		// Y
		datafix = 255 - buffer_read(bu,buffer_u8) > 0 ? true : false;
		if datafix
			{
			buffer_read(bu,buffer_u8);
			ltxy_data[count][i][2] = 0;
			}
		else ltxy_data[count][i][2] = 255 - buffer_read(bu,buffer_u8);
		}

	//trace("LTXY #"+string(count)+": "+string(ltxy_data[count]));
	offset = buffer_tell(bu);
	count++;
	}
	
/*var zero_count = 0;
for (var i=0;i<array_length(ltxy_data[1]);i++)
	{
	if ltxy_data[1][i] == 0 then zero_count++;
	}
//trace("ltxy_data[1] returned a zero count of "+string(zero_count));*/
	
return ltxy_data;
}

function bug_load_ltcc(bu){
var ltcc_data = [];
var offset = 0;
// "LTCC" (animation on note hit sprite)
do offset += 1 until buffer_word(bu,offset) == "LTCC" || offset >= buffer_get_size(bu);
buffer_seek(bu,buffer_seek_start,offset);  
 
// Establish size of file
var count = 0;
while buffer_word(bu,offset)=="LTCC"
	{
	buffer_read(bu,buffer_u32); // skip form
	var size = buffer_read_be32(bu); // 4 bytes after RIFF for filesize
	offset = buffer_tell(bu);
	var eof = offset + size;
	//trace("LTCC found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));
	
	// first commands
	buffer_read_be16(bu); // note number (or 00 on first LTXY, but we keep count of this anyway)
	var command_count = buffer_read_be16(bu); // number of command chunks
	for (var i=0; i<command_count;i++)
		{
		// It's just RGB, bro
		ltcc_data[count][i][0] = buffer_read_be16(bu);
		ltcc_data[count][i][1] = buffer_read_be16(bu);
		ltcc_data[count][i][2] = buffer_read_be16(bu);
		}

	//trace("LTCC #"+string(count)+": "+string(ltcc_data[count]));
	offset = buffer_tell(bu);
	count++;
	}
return ltcc_data;
}