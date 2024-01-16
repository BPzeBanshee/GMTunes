function bitmap_load_from_buffer(buffer){
if !buffer_exists(buffer) then return -1;
var start = buffer_tell(buffer);
var size = buffer_get_size(buffer);

// First 8 bytes of SimTunes forms are the forn name and chunk size in big-endian
buffer_seek(buffer,buffer_seek_relative,4);
var eof = buffer_read_be32(buffer);
//trace("EOF according to form: "+string(eof)+", -8: "+string(eof-8));

// Magic bullshit number, always seems to be 40 in these
//trace("Magic Bullshit Number #1: "+string(buffer_read(buffer,buffer_u32)));
buffer_seek(buffer,buffer_seek_relative,4);

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
var r,g,b;//,pal;
for (var i = 0; i < 256; i++)
    {
	b[i] = buffer_read(buffer,buffer_u8);
	g[i] = buffer_read(buffer,buffer_u8);
	r[i] = buffer_read(buffer,buffer_u8);
	//pal[i] = make_color_rgb(r[i],g[i],b[i]);
	buffer_read(buffer,buffer_u8); // padding/unused alpha channel
    }
	
var sb = buffer_create(ww*hh*4,buffer_fixed,1);
for (var yy = hh-1; yy >= 0; yy--)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		var pixeldata = buffer_read(buffer,buffer_u8);
		buffer_write(sb,buffer_u8,r[pixeldata]);
		buffer_write(sb,buffer_u8,g[pixeldata]);
		buffer_write(sb,buffer_u8,b[pixeldata]);
		buffer_write(sb,buffer_u8,0xFF);
		//var c = pal[buffer_read(buffer,buffer_u8)];
		}
	}
var surf = surface_create(ww,hh);
var flip = surface_create(ww,hh);
buffer_set_surface(sb,flip,0);
surface_set_target(surf);
draw_surface_ext(flip,0,hh,1,-1,0,c_white,1);
surface_reset_target();
surface_free(flip);
buffer_delete(sb);

/*
// show palette table
spr2 = surface_create(16,16);
surface_set_target(spr2);
draw_clear_alpha(c_black,1);
for (var yy=0;yy<16;yy++)
	{
	for (var xx=0;xx<16;xx++)
		{
		draw_point_color(xx,yy,pallete[xx+(16*yy)]);
		}
	}
surface_reset_target();
*/


/*
// manually put pixel data to surface
var surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,1);
for (var yy = hh-1; yy >= 0; yy--)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		var c = pallete[buffer_read(buffer,buffer_u8)];
        draw_point_color(xx,yy,c);
        }
    }
surface_reset_target();
*/
//trace(string("time taken to draw sprite to surface: {0}",get_timer()-t));

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