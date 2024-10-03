///@desc ANIM data decryption
// Get file
var f = get_open_filename(".BUG","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    instance_destroy();
	exit;
    }
    
var offset = 0;
var name = 0;
var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// DRUM and CODE appear to be empty forms listing only their 
// big-endian space minus header (usually 2 bytes)
//do offset += 1 until buffer_word(bu,offset) == "DRUM" || offset >= s2;
//do offset += 1 until buffer_word(bu,offset) == "CODE" || offset >= s2;
//var frames = buffer_peek_be32(bu,offset+4); // +1

// "CODE" in YELLOW00.BUG yields same as DRUM value (2), skip to first ANIM
do offset += 1 until buffer_word(bu,offset) == "ANIM" || offset >= s2;
buffer_seek(bu,buffer_seek_start,offset);

// assumed value based on having seen 
var frames = 2;
var r,g,b,pal;
for (var ff=0; ff<=frames; ff++)
    {
    var size = buffer_peek_be32(bu,offset+4); // ANIM follows u32
    var eof = offset + size + 8;
    trace("ANIM found at "+string(offset)+", possible size: "+string(eof - offset));
    
    var ww = 256;//get_integer("Surface width: ",256);//buffer_peek(bu,offset+12,buffer_u8);
    var hh = 128;//get_integer("Surface height: ",256);//buffer_peek(bu,offset+16,buffer_u8);
	var t = buffer_tell(bu);
	trace(string(buffer_peek(bu,t+4,buffer_u8))+", "+string(buffer_peek(bu,t+8,buffer_u8)));
    trace("ww: "+string(ww)+", hh: "+string(hh));
	buffer_seek(bu,buffer_seek_relative,52);
	
	// Load palette table (BGR, with a single bit for padding set to 00)
    for (var i = 0; i < 256; i++)
        {
        b[i] = buffer_read(bu,buffer_u8);
        g[i] = buffer_read(bu,buffer_u8);
        r[i] = buffer_read(bu,buffer_u8);
		pal[i] = make_color_rgb(r[i],g[i],b[i]);
		buffer_read(bu,buffer_u8); // padding
        }
	
    var surf = surface_create(ww,hh);
    surface_set_target(surf);
    draw_clear_alpha(c_black,1);
        
    // Draw sprite using palette
    for (var yy = hh-1; yy >= 0; yy--)
        {
        for (var xx = 0; xx < ww; xx++)
            {
			var c = pal[buffer_read(bu,buffer_u8)];
            draw_point_color(xx,yy,c);
            }
        }
    trace("Done rendering bug portrait. Offset end: "+string(offset)+", EOF: "+string(eof));
    surface_reset_target();
	
	spr[ff] = sprite_create_from_surface(surf,0,0,ww,hh,true,false,0,0);
	surface_free(surf);
    }
	
// free buffer
buffer_delete(bu);
//event_user(1);