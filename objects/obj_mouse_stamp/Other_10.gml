// Feather disable GM2016


copy = function(cx,cy,w,h){
// convert to abs
if w < 0 {cx += w; w = abs(w);}
if h < 0 {cy += h; h = abs(h);}
trace("copy(): cx:{0}, cy:{1}, w:{2}, h:{3}",cx,cy,w,h);
var note_array_new = Array2(w,h);
var ctrl_array_new = Array2(w,h);
for (var yy = 0; yy < h; yy++)
    {
    for (var xx = 0; xx < w; xx++)
		{
		var play_note = global.note_grid[cx+xx][cy+yy];
		if play_note > 0 note_array_new[xx][yy] = play_note;
		
		var ctrl_note = global.ctrl_grid[cx+xx][cy+yy];
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
							//array_push(warp_ends,[true,dx,dy]);
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
						// test if start x/y will be in copy zone
						var dx = global.warp_list[i][0]-cx;
						var dy = global.warp_list[i][1]-cy;
						if point_in_rectangle(dx,dy,0,0,w-1,h-1)
							{
							// add local x/y coords to warp_starts array
							//array_push(warp_starts,[true,dx,dy]);
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
			ctrl_array_new[xx][yy] = ctrl_note;
			}
		}
	}
note_array = note_array_new;
ctrl_array = ctrl_array_new;	
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
var note_array_new = Array2(w,h);
var ctrl_array_new = Array2(w,h);
for (var yy = 0; yy < h; yy++)
    {
    for (var xx = 0; xx < w; xx++)
		{
		var data_note = global.note_grid[cx+xx,cy+yy];
		if data_note > 0 note_array_new[xx][yy] = data_note;
		
		var ctrl_note = global.ctrl_grid[cx+xx][cy+yy];
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
						//copy flag info *without* absolute coords
						copy_flags[i][0] = xx;
						copy_flags[i][1] = yy;
						copy_flags[i][2] = global.flag_list[i][2];
						trace("copy_flags updated: {0}",copy_flags[i]);
						global.flag_list[i] = [-1,-1,-1];
						}
					}
				}
			ctrl_array_new[xx][yy] = ctrl_note;
			}
		}
	}
array_clear(global.ctrl_grid,cx,cy,w,h,0);
array_clear(global.note_grid,cx,cy,w,h,0);
note_array = note_array_new;
ctrl_array = ctrl_array_new;
width = w;
height = h;
loaded = true;
update_surf(width,height);
(parent.field).update_surf_zone(cx,cy,w,h);
}

paste = function(xx,yy){
var sx = xx - max(copy_w,0);
var sy = yy - max(copy_h,0);
for (var dx = 0; dx < width; dx++)
	{
	// Sanity check
	var fx = sx+dx;
	if fx < 0 or fx > 159 continue;
	for (var dy = 0; dy < height; dy++)
		{
		// Sanity check
		var fy = sy+dy;
		if fy < 0 or fy > 103 continue;
		
		// Paint blocks
		var data = note_array[dx][dy];
		if data > 0 || !clear_back global.note_grid[fx][fy] = data;
			
		// Control blocks
		var data2 = ctrl_array[dx][dy];
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
						copy_flags[i][0] = fx;
						copy_flags[i][1] = fy;
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
			global.ctrl_grid[fx][fy] = data2;
			}
		}
	}
(parent.field).update_surf_zone(sx,sy,width,height);
			
// Teleporter blocks
for (var i=0;i<array_length(warp_starts);i++)
	{
	var data3 = [];
	data3[0] = warp_starts[i][1] + (warp_starts[i][0] ? sx : 0);
	data3[1] = warp_starts[i][2] + (warp_starts[i][0] ? sy : 0);
	data3[2] = warp_ends[i][1] + (warp_ends[i][0] ? sx : 0);
	data3[3] = warp_ends[i][2] + (warp_ends[i][0] ? sy : 0);
	array_push(global.warp_list,data3);
	trace("{0} added to global.warp_list",data3);
	trace("Updated warp list: {0}",global.warp_list);
	}
			
if move_mode unload_stamp();
}

load_stamp_from_file = function(file){
// .STP "STP2" or .JSTP Format
// File check
if file == "" or !file_exists(file) return -1;

// reset vars if present
unload_stamp();
scale = 4;

// Load file into struct
var mystamp = stamp_load(file);
if !is_struct(mystamp) return -2;
height = mystamp.height;
width = mystamp.width;
note_array = mystamp.note_array;
ctrl_array = mystamp.ctrl_array;

// Handle teleport data
// (Flags in Stamps not supported by SimTunes)
for (var yy = 0; yy < height; yy++)
    {
    for (var xx = 0; xx < width; xx++)
        {
		var data = mystamp.ctrl_array[xx][yy];
		if data > 0 
			{
			if data == 8 array_push(warp_starts,[true,xx,yy]);
			if data == 9 array_push(warp_ends,[true,xx,yy]);
			}
        }
    }


move_mode = false;
loaded = true;
copy_x = floor(x/16);
copy_y = floor(y/16);
copy_w = width;
copy_h = height;
update_surf(width,height);
delete mystamp;
}
save_stamp_to_file = function(file){
// Feather disable GM1017
if string_length(file)==0 return -1;
var name = get_string("Stamp name: ","");
var author = get_string("Author name: ","");
var desc = get_string("Description: ","");
var mystamp = new stamp_struct();
mystamp.name = name;
mystamp.author = author;
mystamp.desc = desc;
mystamp.width = width;
mystamp.height = height;
mystamp.note_array = note_array;
mystamp.ctrl_array = ctrl_array;
stamp_save(mystamp,file);
delete mystamp;
}
unload_stamp = function(){
note_array = [];
ctrl_array = [];
if surface_exists(surf) surface_free(surf);
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
if !surface_exists(surf) surf = surface_create(ww,hh)
else 
	{
	if surface_get_width(surf) != ww
	or surface_get_height(surf) != hh
	surface_resize(surf,ww,hh);
	}
surface_set_target(surf);
draw_clear_alpha(c_black,clear_back ? 0 : 1);

// Draw 'stamp'
for (var yy = 0; yy < hh; yy++)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		// draw ctrl note grey first, but override with colors if present
		var data2 = ctrl_array[xx][yy];
		if data2 > 0 draw_point_color(xx,yy,c_grey);// draw_sprite(spr_note_ctrl,data2-1,xx,yy);
		var data = note_array[xx][yy];
		if data > 0 draw_sprite_part(spr_note,data-1,0,0,1,1,xx,yy);
        }
    }
surface_reset_target();
}
rotate_left = function(){
var ww = width;
var hh = height;
var note_array_new = Array2(hh,ww);
var ctrl_array_new = Array2(hh,ww);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = note_array[xx][yy];
		note_array_new[yy][(width-1)-xx] = data;
		
		var data2 = ctrl_array[xx][yy];
		ctrl_array_new[yy][(width-1)-xx] = data2;
		}
	}
	
note_array = note_array_new;
ctrl_array = ctrl_array_new;
note_array_new = [];
ctrl_array_new = [];
width = array_length(note_array);
height = array_length(note_array[0]);
copy_w = width;
copy_h = height;

// update surface
surface_resize(surf,hh,ww);
update_surf(hh,ww);
}
rotate_right = function(){
var ww = width;
var hh = height;
var note_array_new = Array2(hh,ww);
var ctrl_array_new = Array2(hh,ww);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = note_array[xx][yy];
		note_array_new[(height-1)-yy][xx] = data;
		
		var data2 = ctrl_array[xx][yy];
		ctrl_array_new[(height-1)-yy][xx] = data2;
		}
	}

note_array = note_array_new;
ctrl_array = ctrl_array_new;
note_array_new = [];
ctrl_array_new = [];
width = array_length(note_array);
height = array_length(note_array[0]);
copy_w = width;
copy_h = height;

// update surface
surface_resize(surf,hh,ww);
update_surf(hh,ww);
} 
flip_vertical = function(){
var ww = width;
var hh = height;
var note_array_new = Array2(ww,hh);
var ctrl_array_new = Array2(ww,hh);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = note_array[xx][yy];
		note_array_new[xx][(height-1)-yy] = data;
		
		var data2 = ctrl_array[xx][yy];
		ctrl_array_new[xx][(height-1)-yy] = data2;
		}
	}

note_array = note_array_new;
ctrl_array = ctrl_array_new;

// update surface
update_surf(ww,hh);
}
flip_horizontal = function(){
var ww = width;
var hh = height;
var note_array_new = Array2(ww,hh);
var ctrl_array_new = Array2(ww,hh);
trace("flip_horizontal - ww: {0}, hh: {1}",ww,hh);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = note_array[xx][yy];
		note_array_new[(width-1)-xx][yy] = data;
		
		var data2 = ctrl_array[xx][yy];
		ctrl_array_new[(width-1)-xx][yy] = data2;
		}
	}

note_array = note_array_new;
ctrl_array = ctrl_array_new;

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
	var note_array_new = Array2(ww,hh);
	var ctrl_array_new = Array2(ww,hh);

	for (var xx=0; xx<width; xx++)
		{
		for (var yy=0; yy<height; yy++)
			{
			var sx = xx*2;
			var sy = yy*2;
			
			var data = note_array[xx][yy];
			array_clear(note_array_new,sx,sy,2,2,data);
			
			var data2 = ctrl_array[xx][yy];
			if data2 == 8 or data2 == 9
				{
				array_clear(ctrl_array_new,sx,sy,2,2,0);
				ctrl_array_new[sx+1][sy+1] = data2;
				}
			else array_clear(ctrl_array_new,sx,sy,2,2,data2);
			}
		}
	note_array = note_array_new;
	ctrl_array = ctrl_array_new;
	width = array_length(note_array);
	height = array_length(note_array[0]);
	copy_w = width;
	copy_h = height;
	update_surf();
	}
}
scale_down = function(){
if width/2 < 2 or height/2 < 2 return 0;
if size > 1 size--;
scale /= 2;

var ww = width/2;
var hh = height/2;
var note_array_new = Array2(ww,hh);
var ctrl_array_new = Array2(ww,hh);

// TODO: probably not accurate formula given how
// it operates with teleporter positions
for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = note_array[xx*2][yy*2];
		note_array_new[xx][yy] = data;
			
		var data2 = ctrl_array[xx*2][yy*2];
		ctrl_array_new[xx][yy] = data2;
		}
	}
	
note_array = note_array_new;
ctrl_array = ctrl_array_new;
width = array_length(note_array);
height = array_length(note_array[0]);
copy_w = width;
copy_h = height;
update_surf();
}
toggle_clear = function(){
clear_back = parent.clear_back;
if loaded update_surf();
}