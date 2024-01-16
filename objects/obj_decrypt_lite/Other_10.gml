/*
TODO:

Discover/verify the purpose of LTXY and LTCC:
- suspect X/Y == movement animation and CC = color data
- Key number: 26. Notes total in SimTunes, quite likely the full note table

- LTXY varies, it shows up only once per whole file in BLUE00 but 26 times in GREEN04, 
suspect some kind of relative x/y positioning. 

- LTCC varies, it shows up 26 times in BLUE00 and GREEN04 both

BLUE00:
BE size value of 100, followed by magic number 16, followed by LTCC data. 

GREEN04:
BE size value of 10, unclear what follows afterwards
two-value pairs

Based on reading of array data and the way the anim images (except the speech guys) are divided into
quarter, I believe the LTXY data is actually scaling and rotation data. The commands aren't clear
but the arrays after the first LTXY entry (when the file has them, like GREEN04) begin with:

a be16 note number (0-25), the rest are le8s
a small or medium number (2,3,63,44,64 or 25), 
a low number (1-16, not necessarily in any order), 
an initial set of four large numbers nearing 255, 

Then it repeats with a process as follows:
0, 
(1-16),
four large numbers nearing 255, 
...

ie
0,4,255,223,255,251,
0,5,255,222,255,248,
0,6,255,220,255,247,
0,7,255,219,255,244,
0,7,255,217,255,244,
0,8,255,217,255,241,
0,8,255,216,255,239

Seeing how GREEN04's note hit animation's quadrants rotate around the bug
and scale (but do not change angle), redesigning of how the draw routines are needed.
*/

// Get file
var f = get_open_filename(".BUG","");
if f == ""
	{
	instance_destroy();
	return 0;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    instance_destroy();
    }
    
var offset = 0;
var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// "STYL", appears to be a RIFF container for note hit sprites and information
if buffer_word(bu,offset) != "STYL"
then do offset += 1 until buffer_word(bu,offset) == "STYL" || offset >= s2;
buffer_seek(bu,buffer_seek_start,offset);
buffer_read(bu,buffer_u32); // skip first 4 bytes

var size,eof;
size = buffer_read_be32(bu);// 4 bytes after header for filesize
eof = buffer_tell(bu) + size;
trace("STYL found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));

// First is always 1, skip
var styl = [];
array_push(styl,buffer_read_be16(bu));

// Here we obtain draw mode
// 1: speech bubble, 4: keyframe draw with mirrored x/ys, 5: 4 but with rotated x/ys instead of mirrored
var styl_mode = buffer_read_be16(bu);
array_push(styl,styl_mode);
while buffer_tell(bu) < eof array_push(styl,buffer_read_be16(bu));
trace("STYL Draw Mode: "+string(styl_mode)+", chunk values: "+string(styl));

// "LITE" (animation on note hit sprite)
do offset += 1 until buffer_word(bu,offset) == "LITE" || offset >= s2;
offset += 4;
buffer_seek(bu,buffer_seek_start,offset);  
 
// Establish size of file
size = buffer_read_be32(bu); // 4 bytes after RIFF for filesize
/*if size % 2 != 0 then repeat (size % 2) 
	{
	trace("uneven size found, trimming");
	buffer_read(bu,buffer_u8);
	offset = buffer_tell(bu);
	}*/
eof = offset + size;
trace("LITE found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));

// subimage size in BE16
var width = buffer_read_be16(bu);
var height = buffer_read_be16(bu);
trace("sprite dimensions (subimage): "+string(width)+"x"+string(height));

// unknown value, assumed end of be16 reads
var unk1 = buffer_read_be16(bu);
trace("Unknown value #1: "+string(unk1));

// According to lucasvb, the LITE differences end here and the rest should be the same as SHOW

// Magic bullshit number #40
var unk2 = buffer_read(bu,buffer_u32);
trace("Unknown value #2: "+string(unk2));

/*var unka = [];
repeat 3 array_push(unka,buffer_read(bu,buffer_u32));
trace(string(unka));*/

// Establish size of entire sprite frame
var ww = buffer_read(bu,buffer_u32);
var hh = buffer_read(bu,buffer_u32);
if ww == 0 or hh == 0
    {
    show_message("Error reading file (STYL LITE sprite values returned 0)");
    buffer_delete(bu);
    instance_destroy();
    }
else trace("sprite dimensions (full): "+string(ww)+"x"+string(hh));

// Unknown values (BMP header leftover? usually 1,0,8,0)
var unka = [];
repeat 4 array_push(unka,buffer_read(bu,buffer_u8));
trace("unk. array #1: "+string(unka));

// 0
buffer_read(bu,buffer_u32);

// Size of palette table+pixel buffer - headers
var palpixsize = buffer_read(bu,buffer_u32);
trace("pallete/pixel buffer size - headers: "+string(palpixsize));

// Unknown values (usually 0,0,256,256, palette table dimensions?)
var unkb = [];
repeat 4 array_push(unkb,buffer_read(bu,buffer_u32));
trace("unk. array #2: "+string(unkb));

// Load palette table (BGR, with a single bit for padding set to 00)
var r,g,b,pallete;
for (var i = 0; i < 256; i++)
    {
	b[i] = buffer_read(bu,buffer_u8);
	g[i] = buffer_read(bu,buffer_u8);
	r[i] = buffer_read(bu,buffer_u8);
	pallete[i] = make_color_rgb(r[i],g[i],b[i]);
	buffer_read(bu,buffer_u8); // padding/unused alpha channel
    }
	
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
surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,1);
draw_set_alpha(1);
for (var yy = hh-1; yy >= 0; yy--) 
    {
    for (var xx = 0; xx < ww; xx++) 
        {
		var c = buffer_read(bu,buffer_u8);
		//if buffer_tell(bu) < eof then c = buffer_read(bu,buffer_u8);
		draw_point_color(xx,yy,pallete[c]);
        }
    }
surface_reset_target();

var surf2;
for (var i=0;i<4;i++) surf2[i] = surface_create(width,height);

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
	if xx == 0 && yy == 0
		{
		spr_notehit_tl = sprite_create_from_surface(surf2[0],0,0,width,height,false,false,width,height);
		spr_notehit_tr = sprite_create_from_surface(surf2[1],0,0,width,height,false,false,0,height);
		spr_notehit_br = sprite_create_from_surface(surf2[2],0,0,width,height,false,false,0,0);
		spr_notehit_bl = sprite_create_from_surface(surf2[3],0,0,width,height,false,false,width,0);
		}
	else 
		{
		sprite_add_from_surface(spr_notehit_tl,surf2[0],0,0,width,height,false,false);
		sprite_add_from_surface(spr_notehit_tr,surf2[1],0,0,width,height,false,false);
		sprite_add_from_surface(spr_notehit_br,surf2[2],0,0,width,height,false,false);
		sprite_add_from_surface(spr_notehit_bl,surf2[3],0,0,width,height,false,false);
		}
	}


// Prepare window
sw = surface_get_width(surf)/2;
sh = surface_get_height(surf)/2;
image_xscale = sw;
image_yscale = sh;

// LTXY data
/*
spr2 = [];
var bb = buffer_tell(bu);
do
	{
	buffer_read(bu,buffer_u32);
	var ltxy_size = buffer_read_be32(bu);
	eof = buffer_tell(bu)+(ltxy_size);
	var ltxy_data = [];
	var count = 0;
	while buffer_tell(bu) < eof
		{
		//array_push(ltxy_data,buffer_read_be32(bu));
		//array_push(ltxy_data,buffer_read_be16(bu));
		//if count < 3
		//	{
		//	array_push(ltxy_data,buffer_read_be16(bu));
		//	count += 1;
		//	}
		//else
		array_push(ltxy_data,buffer_read(bu,buffer_u8));
		}
	trace("LTXY data @ "+string(bb)+": "+string(ltxy_data));
	bb = buffer_tell(bu);
	//trace("buffer set to position "+string(bb));
	array_push(spr2,surface_create(array_length(ltxy_data),256));
	surface_set_target(array_last(spr2));
	draw_clear_alpha(c_black,1);
	for (var xx=0;xx<array_length(ltxy_data);xx++)
		{
		if xx == 0 
		then draw_point_color(xx,ltxy_data[xx],c_white)
		else draw_line_color(xx,ltxy_data[xx],xx-1,ltxy_data[xx-1],c_white,c_white);
		}
	surface_reset_target();
	
	}
until buffer_word(bu,bb) != "LTXY";
//trace("out of the LTXY loop");
	
// LTCC data
bb = buffer_tell(bu);
do
	{
	buffer_read(bu,buffer_u32);
	var ltcc_size = buffer_read_be32(bu);
	eof = buffer_tell(bu)+(ltcc_size);
	var ltcc_data = [];
	while buffer_tell(bu) < eof
		{
		array_push(ltcc_data,buffer_read_be16(bu));
		}
	trace("LTCC data @ "+string(bb)+": "+string(ltcc_data));
	bb = buffer_tell(bu);
	}
until buffer_word(bu,bb) != "LTCC";	
//trace("out of the LTCC loop");*/
	
buffer_delete(bu);