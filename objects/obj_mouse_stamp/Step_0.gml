// Apply Stamp
if mouse_check_button(mb_left)
	{
	if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
	var xx = floor(x/16);
	var yy = floor(y/16);
	
	if copy_mode
		{
		if xx >= 0 && xx < 160 && yy >= 0 && yy < 104
			{
			var sx = xx - floor(width / 2);
			var sy = yy - floor(height / 2);
			for (var dx = 0; dx < width; dx++)
				{
				for (var dy = 0; dy < height; dy++)
					{
					var data = ds_grid_get(grid_note,dx,dy);
					if data > 0 || !clear_back ds_grid_set(global.pixel_grid,sx+dx,sy+dy,data);
			
					// TODO: this *probably* doesn't account for teleport points
					var data2 = ds_grid_get(grid_ctrl,dx,dy);
					if data2 > 0 || !clear_back ds_grid_set(global.ctrl_grid,sx+dx,sy+dy,data2);
					}
				}
			//ds_grid_set_grid_region(global.pixel_grid,grid,0,0,width,height,sx,sy);
			(parent.field).update_surf();
			}
		}
	else
		{
		// TODO: add drag copy/move function
		/*var sx = xx - floor(width / 2);
		var sy = yy - floor(height / 2);
		for (var dx = 0; dx < width; dx++)
			{
			for (var dy = 0; dy < height; dy++)
				{
				var data = ds_grid_get(global.pixel_grid,dx,dy);
				if data > 0 || !clear_back ds_grid_set(grid_note,sx+dx,sy+dy,data);
			
				// TODO: this *probably* doesn't account for teleport points
				var data2 = ds_grid_get(global.ctrl_grid,dx,dy);
				if data2 > 0 || !clear_back ds_grid_set(grid_ctrl,sx+dx,sy+dy,data2);
				}
			}*/
		}
	}
	
// Erase stamp
if mouse_check_button(mb_right)
	{
	unload_stamp();
	//unload_stamp() is SimTunes behaviour, but I prefer this way
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
if keyboard_check_pressed(ord("Q"))
	{
	rotate_left();
	}
if keyboard_check_pressed(ord("E"))
	{
	rotate_right();
	}

// Scale stamp
if mouse_wheel_up()
	{
	scale_up();
	}
if mouse_wheel_down()
	{
	scale_down();
	}