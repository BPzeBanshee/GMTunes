///@desc .STP "STP2" Format
var f = get_open_filename("*.STP","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(256,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_word(bu,0) != "STP2"
    {
    msg("File doesn't match SimTunes STP2 format.");
    buffer_delete(bu);
    instance_destroy();
	exit;
    }
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually
buffer_seek(bu,buffer_seek_start,4);
var offset = 4;

// .STP "STP2"
// reset surface if present
if surface_exists(surf) then surface_free(surf);

// reset strings if reloading
name = "";
author = "";
desc = "";

// Height first, Width second
var hh = buffer_read(bu,buffer_u32);//buffer_peek(bu,offset,buffer_u8);
var ww = buffer_read(bu,buffer_u32);//buffer_peek(bu,offset+4,buffer_u8);
trace("Stamp dimensions: "+string(ww)+" x "+string(hh));
//offset += 8;

// String data
// 'STAMPS' folder contains name, author and description
// 'PSTAMPS' folder are the 'presets' and simply have preset names "Stp1", etc
// Sidenote: buffer_text reads were tried but aren't stringent enough here, go byte-at-a-time

// Name
var name_size = buffer_read(bu,buffer_u8);//buffer_peek(bu,offset,buffer_u8);
//trace("name_size: "+string(name_size));
if name_size > 0
	{
	repeat name_size name += chr(buffer_read(bu,buffer_u8));
	//for (var i=offset+1;i<offset+1+name_size;i++) name += chr(buffer_peek(bu,i,buffer_u8));
	trace("Stamp Name: "+string(name));
	//offset += name_size+1;
	}
else
	{
	trace("WARNING: Something not right! Stamp file missing name!");
	//offset += 1;
	}

var author_size = buffer_read(bu,buffer_u8);
if author_size > 0
	{
	repeat author_size author += chr(buffer_read(bu,buffer_u8));
	//trace("Author: "+string(author));
	}

var desc_size = buffer_read(bu,buffer_u8);
if desc_size > 0
	{
	repeat desc_size desc += chr(buffer_read(bu,buffer_u8));
	//trace("Description: "+string(desc));
	}

// Stamp data
/*
x/y reads left to right, top to bottom
25 'colors', 00 is blank
*/
surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,1);

// Draw 'stamp'
var t = get_timer();
for (var yy = 0; yy < hh; yy++)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		var data = buffer_read(bu,buffer_u8);
		if data > 0 draw_sprite_part(spr_note,data-1,0,0,1,1,xx,yy);
        }
    }
surface_reset_target();
trace(string("time: {0}",get_timer() - t));

// For reasons currently unclear, the stamp always take half of the remaining space after the string data
// the other half is always empty and is exactly half - the form identifier bits (so -4).
var blankspace = buffer_tell(bu)+(ww*hh)+4;
if blankspace != s2
trace("WARNING: end of buffer not matching expected size!\nExpected: "+string(blankspace)+" bytes, Actual: "+string(s2));
	
// Now that we're done, free buffer
buffer_delete(bu);