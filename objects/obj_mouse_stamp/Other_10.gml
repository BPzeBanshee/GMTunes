// Inherit the parent event
// Feather disable GM2016
event_inherited();

copy = function(cx,cy,w,h){
// convert to abs
if w < 0 {cx += w; w = abs(w);}
if h < 0 {cy += h; h = abs(h);}
trace("load_stamp(): cx:{0}, cy:{1}, w:{2}, h:{3}",cx,cy,w,h);
grid_note = ds_grid_create(w,h);
grid_ctrl = ds_grid_create(w,h);
for (var yy = 0; yy < h; yy++)
    {
    for (var xx = 0; xx < w; xx++)
		{
		var play_note = ds_grid_get(global.pixel_grid,cx+xx,cy+yy);
		if play_note > 0 ds_grid_set(grid_note,xx,yy,play_note);
		
		var ctrl_note = ds_grid_get(global.ctrl_grid,cx+xx,cy+yy);
		if ctrl_note > 0 
			{
			// special handling for teleport starts
			if ctrl_note == 8
				{
				var copy_note = false;
				for (var i=0;i<array_length(global.warp_list);i++)
					{
					if cx+xx == global.warp_list[i][0]
					&& cy+yy == global.warp_list[i][1]
						{
						// test if destination x/y will be in copy zone
						var dx = global.warp_list[i][2]-cx;
						var dy = global.warp_list[i][3]-cy;
						if point_in_rectangle(dx,dy,0,0,w-1,h-1)
							{
							// add local x/y coords to warp_starts/ends array
							array_push(warp_starts,[true,xx,yy]);
							array_push(warp_ends,[true,dx,dy]);
							copy_note = true;
							}
						}
					}
				if !copy_note ctrl_note = 0;
				}
				
			// special handling for teleport exits
			if ctrl_note == 9
				{
				var copy_note = false;
				for (var i=0;i<array_length(global.warp_list);i++)
					{
					if cx+xx == global.warp_list[i][2]
					&& cy+yy == global.warp_list[i][3]
						{
						// test if destination x/y will be in copy zone
						var dx = global.warp_list[i][0]-cx;
						var dy = global.warp_list[i][1]-cy;
						if point_in_rectangle(dx,dy,0,0,w-1,h-1)
							{
							// add local x/y coords to warp_starts array
							array_push(warp_starts,[true,dx,dy]);
							array_push(warp_ends,[true,xx,yy]);
							copy_note = true;
							}
						}
					}
				if !copy_note ctrl_note = 0;
				}
			
			// block copying of flags
			if ctrl_note == 34 ctrl_note = 0;
			
			// finally, set note
			ds_grid_set(grid_ctrl,xx,yy,ctrl_note);
			}
		}
	}
	
width = w;
height = h;
loaded = true;
copy_x = -1;
copy_y = -1;
update_surf(width,height);
}

cut = function(cx,cy,w,h){
// convert to abs
if w < 0 {cx += w; w = abs(w);}
if h < 0 {cy += h; h = abs(h);}
trace("load_stamp(): cx:{0}, cy:{1}, w:{2}, h:{3}",cx,cy,w,h);
grid_note = ds_grid_create(w,h);
grid_ctrl = ds_grid_create(w,h);
for (var yy = 0; yy < h; yy++)
    {
    for (var xx = 0; xx < w; xx++)
		{
		var data_note = ds_grid_get(global.pixel_grid,cx+xx,cy+yy);
		if data_note > 0 ds_grid_set(grid_note,xx,yy,data_note);
		
		var ctrl_note = ds_grid_get(global.ctrl_grid,cx+xx,cy+yy);
		if ctrl_note > 0 
			{
			trace("obj_mouse_stamp: ctrl_note {0} copied",ctrl_note);
			if ctrl_note == 8
				{
				for (var i=0;i<array_length(global.warp_list);i++)
					{
					if cx+xx == global.warp_list[i][0]
					&& cy+yy == global.warp_list[i][1]
						{
						// add local x/y coords to warp_starts array
						array_push(warp_starts,[true,xx,yy]);
						
						// test if destination x/y will be in copy zone
						var local = false;
						var dx = global.warp_list[i][2];
						var dy = global.warp_list[i][3];
						if point_in_rectangle(dx-cx,dy-cy,0,0,w-1,h-1)
							{
							dx -= cx;
							dy -= cy;
							local = true;
							}
						array_push(warp_ends,[local,dx,dy]);
						array_delete(global.warp_list,i,1);
						trace("Updated warp list: {0}",global.warp_list);
						}
					}
				}
				
			if ctrl_note == 9
				{
				for (var i=0;i<array_length(global.warp_list);i++)
					{
					if cx+xx == global.warp_list[i][2]
					&& cy+yy == global.warp_list[i][3]
						{
						// add local x/y coords to warp_starts array
						array_push(warp_ends,[true,xx,yy]);
						
						// test if destination x/y will be in copy zone
						var local = false;
						var dx = global.warp_list[i][0];
						var dy = global.warp_list[i][1];
						if point_in_rectangle(dx-cx,dy-cy,0,0,w-1,h-1)
							{
							dx -= cx;
							dy -= cy;
							local = true;
							}
						array_push(warp_starts,[local,dx,dy]);
						array_delete(global.warp_list,i,1);
						trace("Updated warp list: {0}",global.warp_list);
						}
					}
				}
				
			if ctrl_note == 34
				{
				for (var i=0;i<4;i++)
					{
					if cx+xx == global.flag_list[i][0]
					&& cy+yy == global.flag_list[i][1]
						{
						copy_flags[i][0] = xx;
						copy_flags[i][1] = yy;
						copy_flags[i][2] = global.flag_list[i][2];
						trace("copy_flags updated: {0}",copy_flags[i]);
						global.flag_list[i] = [-1,-1,-1];
						}
					}
				}
			ds_grid_set(grid_ctrl,xx,yy,ctrl_note);
			}
		}
	}
ds_grid_set_region(global.ctrl_grid,cx,cy,cx+w,cy+h,0);
ds_grid_set_region(global.pixel_grid,cx,cy,cx+w,cy+h,0);
width = w;
height = h;
loaded = true;
copy_x = -1;
copy_y = -1;
update_surf(width,height);
(parent.field).update_surf_zone(cx,cy,w,h);
}

paste = function(xx,yy){
var sx = xx - max(copy_w,0);// - floor(width / 2);
var sy = yy - max(copy_h,0);// - floor(height / 2);
for (var dx = 0; dx < width; dx++)
	{
	for (var dy = 0; dy < height; dy++)
		{
		// Paint blocks
		var data = ds_grid_get(grid_note,dx,dy);
		if data > 0 || !clear_back ds_grid_set(global.pixel_grid,sx+dx,sy+dy,data);
			
		// Control blocks
		var data2 = ds_grid_get(grid_ctrl,dx,dy);
		if data2 > 0 || !clear_back
			{
			// flags
			if data2 == 34
				{
				var nd = -1;
				for (var i=0;i<4;i++)
					{
					if dx == copy_flags[i][0] 
					&& dy == copy_flags[i][1]
						{
						copy_flags[i][0] = sx+dx;
						copy_flags[i][1] = sy+dy;
						nd = i;
						}
					}
				if nd > -1
					{
					global.flag_list[nd] = copy_flags[nd];
					trace("{0} added to global.flag_list",copy_flags[nd]);
					}
				}
							
			// finally, add to grid
			ds_grid_set(global.ctrl_grid,sx+dx,sy+dy,data2);
			}
		(parent.field).update_surf_partial(sx+dx,sy+dy);
		}
	}
			
// Teleporter blocks
for (var i=0;i<array_length(warp_starts);i++)
	{
	var data3 = [];
	data3[0] = warp_starts[i][1] + (warp_starts[i][0] ? sx : 0);
	data3[1] = warp_starts[i][2] + (warp_starts[i][0] ? sy : 0);
	data3[2] = warp_ends[i][1] + (warp_ends[i][0] ? sx : 0);
	data3[3] = warp_ends[i][2] + (warp_ends[i][0] ? sy : 0);
	//ds_grid_set(global.ctrl_grid,data3[0],data3[1],8);
	//ds_grid_set(global.ctrl_grid,data3[2],data3[3],9);
	array_push(global.warp_list,data3);
	trace("{0} added to global.warp_list",data3);
	trace("Updated warp list: {0}",global.warp_list);
	}
			
if move_mode
	{
	loaded = false;
	unload_stamp();
	}
}

load_stamp_from_file = function(file){
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
move_mode = false;
loaded = true;
copy_x = floor(x/16);
copy_y = floor(y/16);
copy_w = width;
copy_h = height;
update_surf(width,height);
}

unload_stamp = function(){
if ds_exists(grid_note,ds_type_grid) then ds_grid_destroy(grid_note);
if ds_exists(grid_ctrl,ds_type_grid) then ds_grid_destroy(grid_ctrl);
if surface_exists(surf) then surface_free(surf);
loaded = false;
width = -1;
height = -1;
copy_x = -1;
copy_y = -1;
copy_w = 0;
copy_h = 0;
warp_starts = [];
warp_ends = [];
copy_warps = [];
copy_flags = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]];
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
		if data2 > 0 draw_point_color(xx,yy,c_grey);// draw_sprite(spr_note_ctrl,data2-1,xx,yy);
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