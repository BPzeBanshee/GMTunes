function bmp_load(file){
/*
bmp_load(), by BPze
tested with 8-bit and 24-bit bmps
NOT tested with 16 or 32-bit bmps
*/
if !file_exists(file) return -1;
var t = get_timer();
var buffer = buffer_create(8,buffer_grow,1);
buffer_load_ext(buffer,file,0);

// form code
// generally BM, could be BA,CI,CP,IC,PT
var form = chr(buffer_read(buffer,buffer_u8)) + chr(buffer_read(buffer,buffer_u8));
//trace("Form: "+form);
if form != "BM"
	{
	//trace("File "+string(file)+" not valid BMP");
	buffer_delete(buffer);
	return -2;
	}
	
// ============ BITMAP FILE HEADER ==========
	
// size
var size = buffer_read(buffer,buffer_u32); //trace("Size: "+string(size));

// reserved1+reserved2 (2 bytes each), skip
//var res1 = buffer_read(buffer,buffer_u16); trace("reserved1: "+string(res1));
//var res2 = buffer_read(buffer,buffer_u16); trace("reserved2: "+string(res2));
buffer_read(buffer,buffer_u32);

// beginning of pixel array
var pixelarray_start = buffer_read(buffer,buffer_u32); //trace("Pixel array offset: "+string(pixelarray_start));

// ============ END BITMAP FILE HEADER ==========

// ============ DIB HEADER ===========
var dib_header = buffer_read(buffer,buffer_u32);

// work out DIB version based on header size
var str = "";
switch dib_header
	{
	case 12: str = "BITMAPCOREHEADER / OS21XBITMAPHEADER"; break;
	case 16: str = "OS22XBITMAPHEADER / BITMAPINFOHEADER2"; break;
	case 40: str = "BITMAPINFOHEADER"; break;
	case 52: str = "BITMAPV2INFOHEADER"; break;
	case 56: str = "BITMAPV3INFOHEADER"; break;
	case 64: str = "OS22XBITMAPHEADER"; break;
	case 108: str = "BITMAPV4HEADER"; break;
	case 124: str = "BITMAPV5HEADER"; break;
	default: str = "??? ("+string(dib_header)+")"; break;
	}
//trace(str);

// width/height values
var bmp_width,bmp_height;
if dib_header == 12
	{
	bmp_width = buffer_read(buffer,buffer_u16);
	bmp_height = buffer_read(buffer,buffer_u16);
	}
else
	{
	bmp_width = buffer_read(buffer,buffer_u32);
	bmp_height = buffer_read(buffer,buffer_u32);
	}
//trace(string(bmp_width)+"x"+string(bmp_height));

// number of color planes (must be 1)
buffer_read(buffer,buffer_u16);
//trace("Color planes: "+string(buffer_read(buffer,buffer_u16)));

// bits per pixel (1,4,8,16,24,32)
var bpp = buffer_read(buffer,buffer_u16);
var bppc = power(2,bpp);
var use_pal = true;
//trace("BPP: "+string(bpp)+" ("+string(bppc)+" colors)");
if bpp > 8 then use_pal = false;
var palette_size = 0;

if dib_header >= 40
	{
	// compression mode
	var compression = buffer_read(buffer,buffer_u32);
	var comp_str = "";
	switch compression
		{
		case 0: comp_str = "BI_RGB"; break;
		case 1: comp_str = "BI_RLE8"; break;
		case 2: comp_str = "BI_RLE4"; break;
	
		// OS22XBITMAPHEADER: Huffman 1-D
		case 3: comp_str = "BI_BITFIELDS"; break;
	
		case 4: comp_str = "BI_JPEG"; break; // OS22XBITMAPHEADER: RLE-24
		case 5: comp_str = "BI_PNG"; break;
	
		// Windows CE 5.0 + NET4
		case 6: comp_str = "BI_ALPHABITFIELDS"; break;
	
		// Windows Metafile CMYK
		case 11: comp_str = "BI_CMYK"; break;
		case 12: comp_str = "BI_CMYKRLE8"; break;
		case 13: comp_str = "BI_CMYKRLE4"; break;
		}
	//trace(comp_str);

	// Bitmap size (minus header, can be dummied to 0 for BI_RGB)
	var bitmap_size = buffer_read(buffer,buffer_u32);
	//trace("bitmap size: "+string(bitmap_size));

	var ppm_width = buffer_read(buffer,buffer_u32);
	var ppm_height = buffer_read(buffer,buffer_u32);
	//trace("ppm size: "+string(ppm_width)+"x"+string(ppm_height));

	palette_size = buffer_read(buffer,buffer_u32);
	//trace("palette size: "+string(palette_size));

	var important_colors = buffer_read(buffer,buffer_u32);
	//trace("important colors: "+string(important_colors));
	}

// OS22XBITMAPHEADER has 24 additional bytes
if dib_header == 16
	{
	buffer_seek(buffer,buffer_seek_relative,24);
	/*
	// pixels per metre, always 0 
	var pixels_per_metre = buffer_read(buffer,buffer_u16);
	buffer_read(buffer,buffer_u16); // padding
	
	// fill direction (always 0, bottom-left corner, left-right/bottom-top)
	var fill_direction = buffer_read(buffer,buffer_u16);
	
	// half-toning algorithm (0: none, 1: error diffuse, 2: PANDA, 3: super-circle
	var halftone = buffer_read(buffer,buffer_u16);
	var half_val1 = buffer_read(buffer,buffer_u32);
	var half_val2 = buffer_read(buffer,buffer_u32);
	
	// color encoding for color table (always 0: RGB)
	var color_mode = buffer_read(buffer,buffer_u32);
	
	// application defined ident
	var app_indentifier = buffer_read(buffer,buffer_u32);
	*/
	}

// BI_BITFIELDS has 12 bytes for RGB bitmask
/*if compression == 3 || compression == 6
	{
	var bitmask_r = buffer_read(buffer,buffer_u32);
	var bitmask_g = buffer_read(buffer,buffer_u32);
	var bitmask_b = buffer_read(buffer,buffer_u32);
	}
// BI_ALPHABITFIELDS has 16, 12+alpha bitmask
if compression == 6
	{
	var bitmask_a = buffer_read(buffer,buffer_u32);
	}*/
//trace("buffer position: "+string(buffer_tell(buffer)));

	
// Load palette table (BGR, with a single bit for padding set to 00)
//var pal;
var r,g,b;
if use_pal
	{
	if palette_size == 0 then palette_size = power(2,bpp);
	for (var i = 0; i < palette_size; i++)
	    {
		b[i] = buffer_read(buffer,buffer_u8);
		g[i] = buffer_read(buffer,buffer_u8);
		r[i] = buffer_read(buffer,buffer_u8);
		//pal[i] = make_color_rgb(r[i],g[i],b[i]);
		buffer_read(buffer,buffer_u8); // padding/unused alpha channel
	    }
	//trace("buffer position after loading palette table: "+string(buffer_tell(buffer)));
	}
	
var sb = buffer_create(bmp_width * bmp_height * 4,buffer_fast,1);
var padding = (bmp_width mod 4);
var pad = padding > 0 ? 4-padding : 0;
for (var yy = bmp_height-1; yy >= 0; yy--)
    {
	for (var xx = 0; xx < bmp_width+pad; xx++)
        {
		if use_pal
			{
			var pixeldata = buffer_read(buffer,buffer_u8);
			if xx < bmp_width
				{
				buffer_write(sb,buffer_u8,r[pixeldata]);
				buffer_write(sb,buffer_u8,g[pixeldata]);
				buffer_write(sb,buffer_u8,b[pixeldata]);
				buffer_write(sb,buffer_u8,0xFF);
				}
			}
		else
			{
			b = buffer_read(buffer,buffer_u8);
			g = buffer_read(buffer,buffer_u8);
			r = buffer_read(buffer,buffer_u8);
			var a = bpp == 32 ? buffer_read(buffer,buffer_u8) : 0xFF;
			if xx < bmp_width
				{
				buffer_write(sb,buffer_u8,r);
				buffer_write(sb,buffer_u8,g);
				buffer_write(sb,buffer_u8,b);
				buffer_write(sb,buffer_u8,a);
				}
			}
		}
	}

// Pixel data will be flipped, unflip it
var surf = surface_create(bmp_width,bmp_height);
var flip = surface_create(bmp_width,bmp_height);
buffer_set_surface(sb,flip,0);
surface_set_target(surf);
draw_surface_ext(flip,0,bmp_height,1,-1,0,c_white,1);
surface_reset_target();
surface_free(flip);
buffer_delete(sb);
/*
// OLD: manually blend colors and draw to surface per pixel
var surf = surface_create(bmp_width,bmp_height);
surface_set_target(surf);
draw_clear_alpha(c_black,1);
draw_set_alpha(1);
var padding = (bmp_width mod 4);
var pad = padding > 0 ? 4-padding : 0;
var c;
var a = 1;
for (var yy = bmp_height-1; yy >= 0; yy--)
    {
    for (var xx = 0; xx < bmp_width+pad; xx++)
        {
		if use_pal
			{
			c = pal[buffer_read(buffer,buffer_u8)];
			}
		else 
			{
			var b = buffer_read(buffer,buffer_u8);
			var g = buffer_read(buffer,buffer_u8);
			var r = buffer_read(buffer,buffer_u8);
			c = make_color_rgb(r,g,b);
			if bpp == 32
				{
				a = buffer_read(buffer,buffer_u8);
				draw_set_alpha(a);
				}
			}
		if xx < bmp_width then draw_point_color(xx,yy,c);
        }
    }
surface_reset_target();
*/

buffer_delete(buffer);
//trace(string("time taken to load {0}: {1}ms",file,(get_timer()-t)));
return surf;
}