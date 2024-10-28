if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(x/16);
var yy = floor(y/16);

// Apply Stamp
if mouse_check_button(mb_left)
	{
	if loaded
		{
		if point_in_rectangle(xx,yy,0,0,160,104) && (xx != px || yy != py)
			{
			paste(xx,yy);
			px = xx;
			py = yy;
			}
		}
	else
		{
		if copy_x == -1 || copy_y == -1
			{
			copy_x = xx;
			copy_y = yy;
			}
		else
			{
			copy_w = xx - copy_x;
			copy_h = yy - copy_y;
			}
		}
	}
	
if mouse_check_button_released(mb_left)
	{
	if copy_x > -1 && copy_y > -1
		{
		trace("copy x/y: {0},{1} copy_w/h: {2},{3}",copy_x,copy_y,copy_w,copy_h);
		if copy_w != 0 && copy_h != 0 && !loaded
			{
			if copy_mode copy(copy_x,copy_y,copy_w,copy_h);
			if move_mode cut(copy_x,copy_y,copy_w,copy_h);
			}
		else
			{
			copy_x = -1;
			copy_y = -1;
			}
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

	// Scale stamp
	switch global.zoom
		{
		case 0: scale = 4; break;
		case 1: scale = 8; break;
		case 2: scale = 16; break;
		}
	/*if mouse_wheel_up() scale_up();
	if mouse_wheel_down() scale_down();*/
	}