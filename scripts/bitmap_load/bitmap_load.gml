/*
Parsing of buffers for 'bitmap' images in SimTunes files
using a bmp-like (but not exact) format

TODO: see if parts of bitmap_load could be useful
to reduce duplicated code in bmp_load here.
*/

function bitmap_load_from_buffer(buffer){
if !buffer_exists(buffer) then return -1;

// First 8 bytes of SimTunes forms are the form name and chunk size in big-endian
buffer_seek(buffer,buffer_seek_relative,12);//4
//var eof = buffer_read_be32(buffer);
//trace("EOF according to form: "+string(eof)+", -8: "+string(eof-8));

// Magic bullshit number, always seems to be 40 in these
//trace("Magic Bullshit Number #1: "+string(buffer_read(buffer,buffer_u32)));
//buffer_seek(buffer,buffer_seek_relative,4);

// Get sprite width/height
var ww = buffer_read(buffer,buffer_u32);
var hh = buffer_read(buffer,buffer_u32);
//trace("ww: "+string(ww)+", hh: "+string(hh));

buffer_seek(buffer,buffer_seek_relative,8);
// Magic Bullshit Number #2
//var unk = [];
//repeat 4 array_push(unk,buffer_read(buffer,buffer_u8));
//trace("unk array #1: "+string(unk));

//buffer_read(buffer,buffer_u32); // always 0

// Size of palette table+pixel buffer - headers
var palpixsize = buffer_read(buffer,buffer_u32);
//trace("pallete/pixel buffer size - headers: "+string(palpixsize));

buffer_seek(buffer,buffer_seek_relative,16);
//var unk2 = [];
//repeat 4 array_push(unk2,buffer_read(buffer,buffer_u32));
//trace("unk array #2: "+string(unk2));

// Load palette table (BGR, with a single bit for padding set to 00)
var r,g,b,pal;
for (var i = 0; i < 256; i++)
    {
	b[i] = buffer_read(buffer,buffer_u8);
	g[i] = buffer_read(buffer,buffer_u8);
	r[i] = buffer_read(buffer,buffer_u8);
	pal[i] = make_color_rgb(r[i],g[i],b[i]);
	buffer_read(buffer,buffer_u8); // padding/unused alpha channel
    }

// manually put pixel data to surface
var surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,1);
for (var yy = hh-1; yy >= 0; yy--)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		var c = pal[buffer_read(buffer,buffer_u8)];
        draw_point_color(xx,yy,c);
        }
    }
surface_reset_target();

var spr = sprite_create_from_surface(surf,0,0,ww,hh,false,false,0,0);
surface_free(surf);

if sprite_exists(spr) return spr;
return -2;
}

function bitmap_load_from_file(filename){
if !file_exists(filename) then return -1;

// Load file into buffer, do some error checking
var buffer = buffer_create(1024,buffer_grow,1);
buffer_load_ext(buffer,filename,0);

var result = bitmap_load_from_buffer(buffer);
buffer_delete(buffer);
if sprite_exists(result) then return result;
return -2;
}