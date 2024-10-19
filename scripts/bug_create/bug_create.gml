/*
TODO:
export bug info in it's entirety to easily-GM-loadable files?
*/

function form_skip(buffer){
//trace("Skip form: {0}",buffer_word(buffer,buffer_tell(buffer)));
buffer_read(buffer,buffer_u32);
var skip = buffer_read_be32(buffer);
//trace("Skip value: {0}",skip);
buffer_seek(buffer,buffer_seek_relative,skip);
if frac(buffer_tell(buffer)/2) != 0 then buffer_read(buffer,buffer_u8);
}

function bug_create(xx,yy,filehandle){
if !file_exists(filehandle) then return -1;
// Name for debug/metadata purposes
var name = filename_name(filehandle);

// Load into buffer
var bu = buffer_create(1024,buffer_grow,1);
buffer_load_ext(bu,filehandle,0);

// FORM
var test = "";
repeat 4 test += chr(buffer_read(bu,buffer_u8));
if test != "FORM"
	{
	msg("File doesn't match SimTunes BUGZ format.");
    return -2;
	}
buffer_read(bu,buffer_u32);
	
// "BUGZTYPE___x"
buffer_read(bu,buffer_u64);
buffer_read(bu,buffer_u32);
var bugztype = buffer_read_be16(bu); // Get bugz type (0: yellow, 1: green, 2: blue, 3: red)
//trace("BUGZTYPE: {0}",bugztype);

// TEXT
// var name = bug_load_text(bu);
form_skip(bu);

// INFO
// var info = bug_load_info(bu);
form_skip(bu);

// SHOW
// var show = bug_load_show(bu);
form_skip(bu);

// DRUM
form_skip(bu);

// CODE
form_skip(bu);

// ANIM (bug sprite)
trace("bug_create({0}): loading ANIM...",name);
var anim = bug_load_anim(bu);

// STYL + LITE (note hit sprite)
trace("bug_create({0}): loading STYL...",name);
var styl = bug_load_styl(bu);
//trace("STYL: {0}",styl);

trace("bug_create({0}): loading LITE...",name);
var lite = bug_load_lite(bu);

// LTXY (x/y animation data for note hit)
trace("bug_create({0}): loading LTXY...",name);
var ltxy = bug_load_ltxy(bu);

// LTCC (blend anim data for note hit)
trace("bug_create({0}): loading LTCC...",name);
var ltcc = bug_load_ltcc(bu);

// MIDI Data (we have no means for using this)
trace("bug_create({0}): loading MIDI...",name);
var midi = bug_load_midi(bu);
//trace("MIDI: {0}",midi);

// WAVE (form container for RIFF WAVE sounds)
trace("bug_create({0}): loading WAVE...",name);
var snd_struct = bug_load_wave(bu); 
buffer_delete(bu);

var bug = instance_create_depth(xx,yy,0,obj_bug);
bug.bugzname = name;
bug.bugztype = bugztype;
bug.bugzid = real(string_digits(name)); //instance_number(obj_bug);
bug.spr_up = anim;
//bug.spr_down = anim.spr_down;
//bug.spr_left = anim.spr_left;
//bug.spr_right = anim.spr_right;
bug.ltxy_mode = styl[1];
bug.ltxy_data = ltxy;
bug.ltcc_data = ltcc;
bug.spr_notehit_tl = lite.spr_notehit_tl;
bug.spr_notehit_tr = lite.spr_notehit_tr;
bug.spr_notehit_bl = lite.spr_notehit_bl;
bug.spr_notehit_br = lite.spr_notehit_br;
bug.snd_struct = snd_struct;

var gx = floor(640 * (xx/room_width));
var gy = floor(416 * (yy/room_height));
trace("bug_create({0}): Bug successfully created at {1},{2} (GUI: {3},{4})",name,xx,yy,gx,gy);
return bug;
}

function bug_load_text(bu){
// "TEXT", container for name
if buffer_word(bu,buffer_tell(bu)) != "TEXT"
	{
	msg("TEXT Problem in bug_load_text()!");
	return 1;
	}
buffer_read(bu,buffer_u32);

var size = buffer_read_be32(bu);// 4 bytes after RIFF for filesize

// Get name
var name = "";
for (var i=0;i<size;i++) name += chr(buffer_read(bu,buffer_u8));
if frac(buffer_tell(bu)/2) > 0 buffer_read(bu,buffer_u8);
return name;
//trace(name);
}

function bug_load_desc(bu){
// "INFO" description text (functionally same as bug_load_text)
if buffer_word(bu,buffer_tell(bu)) != "INFO"
	{
	msg("INFO Problem in bug_load_desc()!");
	return 1;
	}
buffer_read(bu,buffer_u32);

// Establish size of file
var size = buffer_read_be32(bu); // 4 bytes after RIFF for filesize

// Get description
var desc = "";
for (var i=0;i<size;i++) desc += chr(buffer_read(bu,buffer_u8));
if frac(buffer_tell(bu)/2) > 0 buffer_read(bu,buffer_u8);
return desc;
//trace(desc);
}

function bug_load_show(bu){
// SHOW
if buffer_word(bu,buffer_tell(bu)) != "SHOW"
	{
	msg("SHOW Problem in bug_load_show()!");
	return 1;
	}
//buffer_read(bu,buffer_u32);
var spr = bitmap_load_from_buffer(bu);
if sprite_exists(spr) return spr;
return 2;
}

function bug_load_anim(bu){
if buffer_word(bu,buffer_tell(bu)) != "ANIM"
	{
	msg("Problem in bug_load_anim()!");
	return 1;
	}
var offset = 0;
var name = 0;
//var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

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
    surface_reset_target();
	//trace("Bitmap rendered, time taken: {0} ms",get_timer() - t);
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

function bug_load_styl(bu){
var pos = buffer_tell(bu);
if buffer_word(bu,buffer_tell(bu)) != "STYL"
	{
	msg("Problem in bug_load_styl()!");
	return 1;
	}
buffer_read(bu,buffer_u32); // skip fourcc
var size = buffer_read_be32(bu); // get form size

var styl = [];
repeat 5 array_push(styl,buffer_read_be16(bu));
return styl;
}

function bug_load_lite(bu){

var buffer_size = buffer_get_size(bu);
buffer_read(bu,buffer_u32); // skip first 4 bytes

// Establish size of file
var size = buffer_read_be32(bu); // 4 bytes after RIFF for filesize
var offset = buffer_tell(bu);
var eof = offset + size;
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
    msg("bug_load_styl(): Error reading file (STYL LITE sprite w/h values returned 0)");
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
//return surf;

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
	}
	
// Free surfaces
surface_free(surf);
for (var i=0;i<4;i++) surface_free(surf2[i]);
	
return {spr_notehit_tl,spr_notehit_tr,spr_notehit_bl,spr_notehit_br};
}

function bug_load_ltxy(bu){
var offset = buffer_tell(bu);
if buffer_word(bu,buffer_tell(bu)) != "LTXY"
	{
	msg("Problem in bug_load_ltxy()!");
	return 1;
	}
var ltxy_data = [];
 
// Establish size of file
var count = 0;
while buffer_word(bu,offset) == "LTXY"
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
return ltxy_data;
}

function bug_load_ltcc(bu){
// "LTCC" (animation on note hit sprite)

var offset = buffer_tell(bu);
if buffer_word(bu,offset) != "LTCC"
	{
	msg("Problem in bug_load_ltcc()!");
	return 1;
	}
var ltcc_data = [];
 
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

function bug_load_midi(bu){
var offset = buffer_tell(bu);
if buffer_word(bu,offset) != "MIDI"
	{
	msg("Problem in bug_load_midi()!");
	return 1;
	}
	
var count = 0;
var midi_data = [[]];
while (buffer_word(bu,offset) == "MIDI")
	{
	buffer_read(bu,buffer_u32); // skip form header
	var size = buffer_read_be32(bu);
	for (var i=0;i<size;i+=2)
		{
		array_push(midi_data[count],buffer_read_be16(bu));
		}
	offset = buffer_tell(bu);
	}
	
return midi_data;
}

function bug_load_wave(bu,num_sounds=25){
var offset = buffer_tell(bu);
var filesize = buffer_get_size(bu);
if buffer_word(bu,offset) != "WAVE"
	{
	msg("Problem in bug_load_wave()!");
	return 1;
	}
var count = 0;
var buf,snd;

for (var i=0;i<26;i++)
	{
	// Skip 'WAVE/TWAV' fourcc
	//trace("FORM {0}: {1}",i,buffer_word(bu,buffer_tell(bu)));
	buffer_read(bu,buffer_u32);

	// Establish size of WAV file
	var size = buffer_read_be32(bu);

	/*if i >= num_sounds
		{
		buffer_seek(bu,buffer_seek_relative,size);
		exit;
		}*/
	
	// Pre-header data
	var header_size = 10; //WAVE
	if i == 25 header_size = 2; //TWAV
	var wave_data = [];
	for (var a=0; a<header_size; a+=2)
		{
		array_push(wave_data,buffer_read_be16(bu));
		}
	//trace("WAVE {0} preheader: {1}",i,wave_data);
	size -= header_size;
	
	// Prep audio buffer
	buf[i] = buffer_create(size,buffer_fixed,1);
	buffer_copy(bu,buffer_tell(bu),size,buf[i],0);
	buffer_seek(bu,buffer_seek_relative,size);
    
	// Create buffer sounds from given buffer
	snd[i] = wav_load_from_buffer(buf[i]);
	}
	
return {buf,snd};
}