// Inherit the parent event
// Feather disable GM2016
event_inherited();

load_stamp = function(file){
///@desc .STP "STP2" Format

if file == "" or !file_exists(file)
	{
	alarm[0] = 1; // kludge to avoid crash from obj_ctrl_playfield var management
	return -1;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(256,buffer_grow,1);
buffer_load_ext(bu,file,0);

if buffer_word(bu,0) != "STP2"
    {
    msg("File doesn't match SimTunes STP2 format.");
    buffer_delete(bu);
    alarm[0] = 1; // kludge to avoid crash from obj_ctrl_playfield var management
	return -2;
    }
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually
buffer_seek(bu,buffer_seek_start,4);

// .STP "STP2"
// reset surface if present
if surface_exists(surf) then surface_free(surf);
if ds_exists(grid,ds_type_grid) then ds_grid_destroy(grid);

// reset strings if reloading
//name = "";
//author = "";
//desc = "";

// Height first, Width second
height = buffer_read(bu,buffer_u32);
width = buffer_read(bu,buffer_u32);
trace("Stamp dimensions: "+string(width)+" x "+string(height));

// String data
// 'STAMPS' folder contains name, author and description
// 'PSTAMPS' folder are the 'presets' and simply have preset names "Stp1", etc
// Sidenote: buffer_text reads were tried but aren't stringent enough here, go byte-at-a-time

// Name
var name_size = buffer_read(bu,buffer_u8);
//trace("name_size: "+string(name_size));
if name_size > 0
	{
	buffer_seek(bu,buffer_seek_relative,name_size);
	//repeat name_size name += chr(buffer_read(bu,buffer_u8));
	//trace("Stamp Name: "+string(name));
	}

var author_size = buffer_read(bu,buffer_u8);
if author_size > 0
	{
	buffer_seek(bu,buffer_seek_relative,author_size);
	//repeat author_size author += chr(buffer_read(bu,buffer_u8));
	//trace("Author: "+string(author));
	}

var desc_size = buffer_read(bu,buffer_u8);
if desc_size > 0
	{
	buffer_seek(bu,buffer_seek_relative,desc_size);
	//repeat desc_size desc += chr(buffer_read(bu,buffer_u8));
	//trace("Description: "+string(desc));
	}

// Stamp data
/*
x/y reads left to right, top to bottom
25 'colors', 00 is blank
*/
grid = ds_grid_create(width,height);
surf = surface_create(width,height);
surface_set_target(surf);
draw_clear_alpha(c_black,0);

// Draw 'stamp'
//var t = get_timer();
for (var yy = 0; yy < height; yy++)
    {
    for (var xx = 0; xx < width; xx++)
        {
		var data = buffer_read(bu,buffer_u8);
		if data > 0
			{
			draw_sprite_part(spr_note,data-1,0,0,1,1,xx,yy);
			ds_grid_add(grid,xx,yy,data);
			}
        }
    }
surface_reset_target();
//trace(string("time: {0}",get_timer() - t));

// For reasons currently unclear, the stamp always take half of the remaining space after the string data
// the other half is always empty and is exactly half - the form identifier bits (so -4).
var blankspace = buffer_tell(bu)+(width*height)+4;
if blankspace != s2
then trace("WARNING: end of buffer not matching expected size!\nExpected: "+string(blankspace)+" bytes, Actual: "+string(s2));
	
// Now that we're done, free buffer
buffer_delete(bu);
}

update_surf = function(ww,hh){
// update surface
if surface_exists(surf) surface_free(surf);
surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,0);

// Draw 'stamp'
//var t = get_timer();
for (var yy = 0; yy < hh; yy++)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		var data = ds_grid_get(grid,xx,yy);
		if data > 0
			{
			draw_sprite_part(spr_note,data-1,0,0,1,1,xx,yy);
			}
        }
    }
surface_reset_target();
}