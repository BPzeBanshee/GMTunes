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

if buffer_read_word(bu) != "STP2"
    {
    msg("File doesn't match SimTunes STP2 format.");
    buffer_delete(bu);
    alarm[0] = 1; // kludge to avoid crash from obj_ctrl_playfield var management
	return -2;
    }
var size = buffer_get_size(bu); // actual size of file loaded into buffer
//buffer_seek(bu,buffer_seek_start,4);

// .STP "STP2"
// reset surface/ds_maps if present
unload_stamp();
scale = 4;
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
grid_note = ds_grid_create(width,height);
grid_ctrl = ds_grid_create(width,height);

// Load pixel data
for (var yy = 0; yy < height; yy++)
    {
    for (var xx = 0; xx < width; xx++)
        {
		var data = buffer_read(bu,buffer_u8);
		if data > 0 ds_grid_add(grid_note,xx,yy,data);
        }
    }
	
// Load control data
for (var yy = 0; yy < height; yy++)
    {
    for (var xx = 0; xx < width; xx++)
        {
		var data = buffer_read(bu,buffer_u8);
		if data > 0 ds_grid_add(grid_ctrl,xx,yy,data);
        }
    }
//trace(string("time: {0}",get_timer() - t));

// For reasons currently unclear, the stamp always take half of the remaining space after the string data
// the other half is always empty and is exactly half - the form identifier bits (so -4).
var blankspace = buffer_tell(bu);
trace("Buffer position: {0}, Size: {1}",blankspace,size);
	
// Now that we're done, free buffer
buffer_delete(bu);

copy_mode = true;
update_surf(width,height);
}

unload_stamp = function(){
if ds_exists(grid_note,ds_type_grid) then ds_grid_destroy(grid_note);
if ds_exists(grid_ctrl,ds_type_grid) then ds_grid_destroy(grid_ctrl);
if surface_exists(surf) then surface_free(surf);
move_mode = false;
copy_mode = false;
width = -1;
height = -1;
}

update_surf = function(ww=width,hh=height){
// update surface
if !surface_exists(surf) surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,clear_back ? 0 : 1);

// Draw 'stamp'
//var t = get_timer();
for (var yy = 0; yy < hh; yy++)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		var data = ds_grid_get(grid_note,xx,yy);
		if data > 0 draw_sprite_part(spr_note,data-1,0,0,1,1,xx,yy);
		var data2 = ds_grid_get(grid_ctrl,xx,yy);
		if data2 > 0 draw_rectangle_color(xx,yy,xx+1,yy+1,c_grey,c_grey,c_grey,c_grey,false);// draw_sprite(spr_note_ctrl,data2-1,xx,yy);
        }
    }
surface_reset_target();
}

rotate_left = function(){
var ww = width;
var hh = height;
var grid2 = ds_grid_create(hh,ww);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx,yy);
		if data > 0 ds_grid_set(grid2,yy,width-xx,data);
		}
	}
	
ds_grid_copy(grid_note,grid2);
width = ds_grid_width(grid_note);
height = ds_grid_height(grid_note);
ds_grid_destroy(grid2);

// update surface
surface_resize(surf,hh,ww);
update_surf(hh,ww);
}

rotate_right = function(){
var ww = width;
var hh = height;
var grid2 = ds_grid_create(hh,ww);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx,yy);
		if data > 0 ds_grid_set(grid2,height-yy,xx,data);
		}
	}

ds_grid_copy(grid_note,grid2);
width = ds_grid_width(grid_note);
height = ds_grid_height(grid_note);
ds_grid_destroy(grid2);

// update surface
surface_resize(surf,hh,ww);
update_surf(hh,ww);
}

flip_vertical = function(){
var ww = width;
var hh = height;
var grid2 = ds_grid_create(ww,hh);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx,yy);
		if data > 0 ds_grid_set(grid2,xx,height-yy,data);
		}
	}

ds_grid_copy(grid_note,grid2);
ds_grid_destroy(grid2);

// update surface
update_surf(ww,hh);
}

flip_horizontal = function(){
var ww = width;
var hh = height;
var grid2 = ds_grid_create(ww,hh);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx,yy);
		if data > 0 ds_grid_set(grid2,width-xx,yy,data);
		}
	}

ds_grid_copy(grid_note,grid2);
ds_grid_destroy(grid2);

// update surface
update_surf(ww,hh);
}

scale_up = function(){
if scale < 32 
	{
	scale *= 2;

	var ww = width*2;
	var hh = height*2;
	var grid2 = ds_grid_create(ww,hh);

	for (var xx=0; xx<ww; xx++)
		{
		for (var yy=0; yy<hh; yy++)
			{
			var data = ds_grid_get(grid_note,xx/2,yy/2);
			if data > 0 ds_grid_set(grid2,xx,yy,data);
			}
		}
	
	ds_grid_resize(grid_note,width,height);
	ds_grid_copy(grid_note,grid2);
	width = ds_grid_width(grid_note);
	height = ds_grid_height(grid_note);
	ds_grid_destroy(grid2);
	}
}

scale_down = function(){
if scale > 1 
	{
	scale /= 2;

	var ww = width/2;
	var hh = height/2;
	var grid2 = ds_grid_create(ww,hh);

	for (var xx=0; xx<ww; xx++)
		{
		for (var yy=0; yy<hh; yy++)
			{
			var data = ds_grid_get(grid_note,xx*2,yy*2);
			if data > 0 ds_grid_set(grid2,xx,yy,data);
			}
		}
	
	ds_grid_resize(grid_note,width,height);
	ds_grid_copy(grid_note,grid2);
	width = ds_grid_width(grid_note);
	height = ds_grid_height(grid_note);
	ds_grid_destroy(grid2);
	}
}

toggle_clear = function(){
clear_back = !clear_back;
update_surf();
}