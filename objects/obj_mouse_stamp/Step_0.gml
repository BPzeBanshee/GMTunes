if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(x/16);
var yy = floor(y/16);

/*
TODO: fucked something up here so it's not copying field data properly in some cases
*/

if mouse_check_button_pressed(mb_left)
	{
	if !loaded
		{
		// set start coord for copy/cut zone
		if copy_x == -1 || copy_y == -1
			{
			copy_x = xx;
			copy_y = yy;
			}
		}
	}

// Apply Stamp
if mouse_check_button(mb_left)
	{
	if loaded
		{
		// paste from copy/cut zone
		if point_in_rectangle(xx,yy,0,0,160,104) 
		&& (xx != px || yy != py)
			{
			paste(xx,yy);
			px = xx;
			py = yy;
			}
		}
	else if (copy_x > -1 && copy_y > -1)
		{
		copy_w = floor(xx - copy_x);
		copy_h = floor(yy - copy_y);
		}
	}
	
if mouse_check_button_released(mb_left)
	{
	if !loaded && copy_x > -1 && copy_y > -1
		{
		if copy_w != 0 && copy_h != 0
			{
			trace("left button release copy x/y: {0},{1} copy_w/h: {2},{3}",copy_x,copy_y,copy_w,copy_h);
			if move_mode 
			cut(copy_x,copy_y,copy_w,copy_h)
			else copy(copy_x,copy_y,copy_w,copy_h);
			}
		copy_x = -1;
		copy_y = -1;
		px = -1;
		py = -1;
		}
	}
	
// Erase stamp
if mouse_check_button(mb_right)
	{
	unload_stamp();
	//unload_stamp() is SimTunes behaviour, but I feel like mass clear is easier
	/*if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
	var xx = floor(mouse_x/16);
	var yy = floor(mouse_y/16);
	if xx >= 0 && xx < 160 && yy >= 0 && yy < 104
		{
		var dx = xx-floor(width/2);
		var dy = yy-floor(height/2);
		ds_grid_set_region(global.pixel_grid,dx,dy,xx+floor(width/2),yy+floor(height/2),0);
		(parent.field).update_surf();
		}*/
	}

// Rotate stamp
if loaded
	{
	if keyboard_check_pressed(ord("Q")) rotate_left();
	if keyboard_check_pressed(ord("E")) rotate_right();
	if mouse_wheel_up() scale_up();
	if mouse_wheel_down() scale_down();
	}