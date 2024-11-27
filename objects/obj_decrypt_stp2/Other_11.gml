///@desc .STP "STP2" Format (script)
// Get filename + open approval
var f = get_open_filename("*.STP|SimTunes Stamp file","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}

// reset surface if present
if surface_exists(surf) surface_free(surf);


mystamp = stamp_load(f);
name = mystamp.name;
author = mystamp.author;
desc = mystamp.desc;

// Stamp data
/*
x/y reads left to right, top to bottom
25 'colors', 00 is blank
*/
var ww = mystamp.width;
var hh = mystamp.height;
surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,1);

// Draw 'stamp'
for (var yy = 0; yy < hh; yy++)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		var data = mystamp.note_array[xx][yy];
		if data > 0 draw_sprite_part(spr_note,data-1,0,0,1,1,xx,yy);
        }
    }
surface_reset_target();