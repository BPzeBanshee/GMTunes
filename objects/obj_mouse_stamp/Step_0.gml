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
						// if exit point, don't bother
						if data2 == 9 exit;
						
						// if entrance point, make destination point relative to entrance
						if data2 == 8
							{
							var nx = -1; var ny = -1;
							for (var i=0;i<array_length(copy_warps);i++)
								{
								if dx == copy_warps[i][0] && dy == copy_warps[i][1]
									{
									if copy_mode
										{
										// these got relativised by copy, reabsolutise
										nx = (sx+dx)+copy_warps[i][2];
										ny = (sy+dy)+copy_warps[i][3];
										}
									else
										{
										// these were kept as-is by cut, reinstate
										nx = copy_warps[i][2];
										ny = copy_warps[i][3];
										}
									}
								}
							if nx > -1 && ny > -1
								{
								ds_grid_set(global.ctrl_grid,nx,ny,9);
								array_push(global.warp_list,[sx+dx,sy+dy,nx,ny]);
								trace("{0} added to global.warp_list",[sx+dx,sy+dy,nx,ny]);
								}
							}
							
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
						ds_grid_set(global.ctrl_grid,sx+dx,sy+dy,data2);
						}
					(parent.field).update_surf_partial(sx+dx,sy+dy);
					}
				}
			
			if move_mode
				{
				loaded = false;
				unload_stamp();
				}
				
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
		if copy_w != 0 && copy_h != 0 
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