// Inherit the parent event
// Feather disable GM2016
event_inherited();

copy = function(cx,cy,w,h){
// convert to abs
if w < 0 {cx += w; w = abs(w);}
if h < 0 {cy += h; h = abs(h);}
trace("copy(): cx:{0}, cy:{1}, w:{2}, h:{3}",cx,cy,w,h);
ds_grid_resize(grid_note,w,h);
ds_grid_resize(grid_ctrl,w,h);
ds_grid_clear(grid_note,0);
ds_grid_clear(grid_ctrl,0);

ds_grid_set_grid_region(grid_note,global.pixel_grid,cx,cy,cx+w,cy+h,0,0);

for (var yy = 0; yy < h; yy++)
    {
    for (var xx = 0; xx < w; xx++)
		{
		//var play_note = ds_grid_get(global.pixel_grid,cx+xx,cy+yy);
		//if play_note > 0 ds_grid_set(grid_note,xx,yy,play_note);
		
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
update_surf(width,height);
}

cut = function(cx,cy,w,h){
// convert to abs
if w < 0 {w = abs(w); cx -= w;}
if h < 0 {h = abs(h); cy -= h;}
trace("cut(): cx:{0}, cy:{1}, w:{2}, h:{3}",cx,cy,w,h);
ds_grid_resize(grid_note,w,h);
ds_grid_resize(grid_ctrl,w,h);
ds_grid_clear(grid_note,0);
ds_grid_clear(grid_ctrl,0);
ds_grid_set_grid_region(grid_note,global.pixel_grid,cx,cy,cx+w,cy+h,0,0);
for (var yy = 0; yy < h; yy++)
    {
    for (var xx = 0; xx < w; xx++)
		{
		//var data_note = ds_grid_get(global.pixel_grid,cx+xx,cy+yy);
		//if data_note > 0 ds_grid_set(grid_note,xx,yy,data_note);
		
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
ds_grid_set_region(global.ctrl_grid,cx,cy,(cx+w)-1,(cy+h)-1,0);
ds_grid_set_region(global.pixel_grid,cx,cy,(cx+w)-1,(cy+h)-1,0);
width = w;
height = h;
loaded = true;
// Scale stamp
switch global.zoom
	{
	case 0: scale = 4; break;
	case 1: scale = 8; break;
	case 2: scale = 16; break;
	}
update_surf(width,height);
(parent.field).update_surf_zone(cx,cy,w,h);
}

paste = function(xx,yy){
var sx = xx - max(copy_w,0);
var sy = yy - max(copy_h,0);

//ds_grid_set_grid_region(global.pixel_grid,grid_note,0,0,width,height,sx,sy);
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
				
			// likely unfinished feature of SimTunes stamp file:
			// YGRB flags saved as 252/253/254/255 (-4,-3,-2,-1) but NO direction data
			// and while SimTunes shows control note in preview, does not paste any data
			if data2 > 251 data2 = 0;
							
			// finally, add to grid
			ds_grid_set(global.ctrl_grid,sx+dx,sy+dy,data2);
			}
		//(parent.field).update_surf_partial(sx+dx,sy+dy);
		}
	}
(parent.field).update_surf_zone(sx,sy,dx,dy);
			
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
			
if move_mode unload_stamp();
}

load_stamp_from_file = function(file){
// .STP "STP2" Format
// File check
if file == "" or !file_exists(file) return -1;

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
// (Flags in Stamps not supported by SimTunes)
for (var yy = 0; yy < height; yy++)
    {
    for (var xx = 0; xx < width; xx++)
        {
		var data = buffer_read(bu,buffer_u8);
		if data > 0 
			{
			if data == 8 array_push(warp_starts,[true,xx,yy]);
			if data == 9 array_push(warp_ends,[true,xx,yy]);
			ds_grid_add(grid_ctrl,xx,yy,data);
			}
        }
    }

// bonus 4 bytes of nothing at the end
//var blankspace = buffer_tell(bu);
//trace("Buffer position: {0}, Size: {1}",blankspace,size);
	
// Now that we're done, free buffer
buffer_delete(bu);

move_mode = false;
loaded = true;
copy_x = floor(x/16);
copy_y = floor(y/16);
copy_w = width;
copy_h = height;
update_surf(width,height);
}

save_stamp_to_file = function(file){
// Feather disable GM1017
if string_length(file)==0 return -1;
var name = get_string("Stamp name: ","");
var auth = get_string("Author name: ","");
var desc = get_string("Description: ","");
var w = width;
var h = height;

var buf_data = buffer_create(64,buffer_grow,1);

// write fourcc
buffer_write(buf_data,buffer_text,"STP2");

// write height, then width
buffer_write(buf_data,buffer_u32,h);
buffer_write(buf_data,buffer_u32,w);

// metadata
buffer_write(buf_data,buffer_u8,string_byte_length(name));
buffer_write(buf_data,buffer_text,name);
buffer_write(buf_data,buffer_u8,string_byte_length(auth));
buffer_write(buf_data,buffer_text,auth);
buffer_write(buf_data,buffer_u8,string_byte_length(desc));
buffer_write(buf_data,buffer_text,desc);

// Save pixel data
for (var yy = 0; yy < h; yy++)
    {
    for (var xx = 0; xx < w; xx++)
        {
		var data = ds_grid_get(grid_note,xx,yy);
		buffer_write(buf_data,buffer_u8,data);
        }
    }
	
// Save control data
for (var yy = 0; yy < h; yy++)
    {
    for (var xx = 0; xx < w; xx++)
        {
		var data = ds_grid_get(grid_ctrl,xx,yy);
		
		// (Flags in Stamps not supported by SimTunes, 
		// but we're gonna match behaviour anyway)
		if data == 34
			{
			for (var i=0;i<4;i++)
				{
				if copy_flags[i][0] == xx
				&& copy_flags[i][1] == yy
				data = 252+i;
				}
			}
			
		buffer_write(buf_data,buffer_u8,data);
        }
    }
	
// bonus 4 bytes of nothing at the end
buffer_write(buf_data,buffer_u32,0);

// finally, save to file, then cleanup
buffer_save(buf_data,file);
buffer_delete(buf_data);
return 0;
}

unload_stamp = function(){
ds_grid_resize(grid_note,0,0);
ds_grid_resize(grid_ctrl,0,0);
ds_grid_clear(grid_note,0);
ds_grid_clear(grid_ctrl,0);
if surface_exists(surf) then surface_free(surf);
loaded = false;
width = -1;
height = -1;
copy_x = -1;
copy_y = -1;
px = -1;
py = -1;
copy_w = 0;
copy_h = 0;
warp_starts = [];
warp_ends = [];
copy_flags = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]];
}

update_surf = function(ww=width,hh=height){
if (ww == 0 or hh == 0) return 0;
// update surface
if !surface_exists(surf) surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,clear_back ? 0 : 1);

// Draw 'stamp'
for (var yy = 0; yy < hh; yy++)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		// draw ctrl note grey first, but override with colors if present
		var data2 = ds_grid_get(grid_ctrl,xx,yy);
		if data2 > 0 draw_point_color(xx,yy,c_grey);// draw_sprite(spr_note_ctrl,data2-1,xx,yy);
		var data = ds_grid_get(grid_note,xx,yy);
		if data > 0 draw_sprite_part(spr_note,data-1,0,0,1,1,xx,yy);
        }
    }
surface_reset_target();
}

rotate_left = function(){
var ww = width;
var hh = height;
var grid_note_new = ds_grid_create(hh,ww);
var grid_ctrl_new = ds_grid_create(hh,ww);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx,yy);
		ds_grid_set(grid_note_new,yy,(width-1)-xx,data);
		
		var data2 = ds_grid_get(grid_ctrl,xx,yy);
		ds_grid_set(grid_ctrl_new,yy,(width-1)-xx,data2);
		}
	}
	
ds_grid_copy(grid_note,grid_note_new);
ds_grid_copy(grid_ctrl,grid_ctrl_new);
width = ds_grid_width(grid_note);
height = ds_grid_height(grid_note);
copy_w = width;
copy_h = height;
ds_grid_destroy(grid_note_new);
ds_grid_destroy(grid_ctrl_new);

// update surface
surface_resize(surf,hh,ww);
update_surf(hh,ww);
}

rotate_right = function(){
var ww = width;
var hh = height;
var grid_note_new = ds_grid_create(hh,ww);
var grid_ctrl_new = ds_grid_create(hh,ww);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx,yy);
		ds_grid_set(grid_note_new,(height-1)-yy,xx,data);
		
		var data2 = ds_grid_get(grid_ctrl,xx,yy);
		ds_grid_set(grid_ctrl_new,(height-1)-yy,xx,data2);
		}
	}

ds_grid_copy(grid_note,grid_note_new);
ds_grid_copy(grid_ctrl,grid_ctrl_new);
width = ds_grid_width(grid_note);
height = ds_grid_height(grid_note);
copy_w = width;
copy_h = height;
ds_grid_destroy(grid_note_new);
ds_grid_destroy(grid_ctrl_new);

// update surface
surface_resize(surf,hh,ww);
update_surf(hh,ww);
}

flip_vertical = function(){
var ww = width;
var hh = height;
var grid_note_new = ds_grid_create(ww,hh);
var grid_ctrl_new = ds_grid_create(ww,hh);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx,yy);
		ds_grid_set(grid_note_new,xx,height-yy,data);
		
		var data2 = ds_grid_get(grid_ctrl,xx,yy);
		ds_grid_set(grid_ctrl_new,xx,height-yy,data);
		}
	}

ds_grid_copy(grid_note,grid_note_new);
ds_grid_copy(grid_ctrl,grid_ctrl_new);
ds_grid_destroy(grid_note_new);
ds_grid_destroy(grid_ctrl_new);

// update surface
update_surf(ww,hh);
}

flip_horizontal = function(){
var ww = width;
var hh = height;
var grid_note_new = ds_grid_create(ww,hh);
var grid_ctrl_new = ds_grid_create(ww,hh);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx,yy);
		ds_grid_set(grid_note_new,width-xx,yy,data);
		
		var data2 = ds_grid_get(grid_ctrl,xx,yy);
		ds_grid_set(grid_ctrl_new,width-xx,yy,data);
		}
	}

ds_grid_copy(grid_note,grid_note_new);
ds_grid_copy(grid_ctrl,grid_ctrl_new);
ds_grid_destroy(grid_note_new);
ds_grid_destroy(grid_ctrl_new);

// update surface
update_surf(ww,hh);
}

scale_up = function(){
if size < 5
	{
	size++;
	scale *= 2;
	var ww = width*2;
	var hh = height*2;
	var grid_note_new = ds_grid_create(ww,hh);
	var grid_ctrl_new = ds_grid_create(ww,hh);

	for (var xx=0; xx<width; xx++)
		{
		for (var yy=0; yy<height; yy++)
			{
			var sx = xx*2;
			var sy = yy*2;
			
			var data = ds_grid_get(grid_note,xx,yy);
			ds_grid_set_region(grid_note_new,sx,sy,sx+1,sy+1,data);
			
			var data2 = ds_grid_get(grid_ctrl,xx,yy);
			if data2 == 8 or data2 == 9
				{
				ds_grid_set_region(grid_ctrl_new,sx,sy,sx+1,sy+1,0);
				ds_grid_set(grid_ctrl_new,sx+1,sy+1,data2);
				}
			else ds_grid_set_region(grid_ctrl_new,sx,sy,sx+1,sy+1,data2);
			}
		}
	
	ds_grid_resize(grid_note,ww,hh);
	ds_grid_resize(grid_ctrl,ww,hh);
	ds_grid_copy(grid_note,grid_note_new);
	ds_grid_copy(grid_ctrl,grid_ctrl_new);
	width = ds_grid_width(grid_note);
	height = ds_grid_height(grid_note);
	copy_w = width;
	copy_h = height;
	ds_grid_destroy(grid_note_new);
	ds_grid_destroy(grid_ctrl_new);
	}
}

scale_down = function(){
if width/2 < 2 or height/2 < 2 return 0;
if size > 1 size--;
scale /= 2;

var ww = width/2;
var hh = height/2;
var grid_note_new = ds_grid_create(ww,hh);
var grid_ctrl_new = ds_grid_create(ww,hh);

// TODO: probably not accurate formula given how
// it operates with teleporter positions
for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid_note,xx*2,yy*2);
		ds_grid_set(grid_note_new,xx,yy,data);
			
		var data2 = ds_grid_get(grid_ctrl,xx*2,yy*2);
		ds_grid_set(grid_ctrl_new,xx,yy,data2);
		}
	}
	
ds_grid_resize(grid_note,width,height);
ds_grid_resize(grid_ctrl,width,height);
ds_grid_copy(grid_note,grid_note_new);
ds_grid_copy(grid_ctrl,grid_ctrl_new);
width = ds_grid_width(grid_note);
height = ds_grid_height(grid_note);
copy_w = width;
copy_h = height;
ds_grid_destroy(grid_note_new);
ds_grid_destroy(grid_ctrl_new);
}

toggle_clear = function(){
clear_back = parent.clear_back;
if loaded update_surf();
}