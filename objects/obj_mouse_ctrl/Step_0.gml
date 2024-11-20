if global.use_external_assets sprite_index = global.spr_ui.ctrl[note];

if !place_teleporter
	{
	if mouse_wheel_up()
		{
		if note < 14 then note += 1;
		if note == 9 then note = 10;
		}
	if mouse_wheel_down()
		{
		if note > 1 then note -= 1;
		if note == 9 then note = 8;
		}
	}

if y >= room_height or device_mouse_y_to_gui(0) > 416 exit;
var xx = floor(mouse_x/16);
var yy = floor(mouse_y/16);

if keyboard_check(vk_shift)
	{
	if held_x == -1 
	&& held_y == -1
		{
		held_x = xx;
		held_y = yy;
		}
	else 
		{
		if xx != held_x && !hold_x hold_y = true;
		if yy != held_y && !hold_y hold_x = true;
		if hold_y yy = held_y;
		if hold_x xx = held_x;
		}
	}
else
	{
	held_x = -1; hold_x = false;
	held_y = -1; hold_y = false;	
	}
	
if point_in_rectangle(xx,yy,0,0,160,104)
	{
	if mouse_check_button_pressed(mb_left)
	or mouse_check_button_pressed(mb_right)
		{
		parent.record();
		}
		
	//Add/override note
	if mouse_check_button(mb_left)
		{
		// mouse press check
		if (note == 8 or note == 9) && !mouse_check_button_pressed(mb_left) then exit;
	
		// existing control note check
		var c = global.ctrl_grid[xx][yy];
		if c > 0
			{
			// wipe grid position
			global.ctrl_grid[xx][yy] = 0;
		
			// teleport block handling
			if c == 8 or c == 9
				{
				delete_teleporter_block(xx,yy,c);
				}
			}
		
		// existing flag check
		delete_flag(xx,yy);
		
		// Set note
		global.ctrl_grid[xx][yy] = note;
		(parent.field).update_surf_partial(xx,yy);//ctrl
	
		// Teleporter block handling
		if note == 8
			{
			tele_obj = [xx,yy,-1,-1];
			place_teleporter = true;
			note = 9;
			}
		else if note == 9
			{
			tele_obj[2] = xx;
			tele_obj[3] = yy;
			array_push(global.warp_list,tele_obj);
			trace(string(tele_obj)+" added to global.warp_list\nUpdated warp list: "+string(global.warp_list));
			place_teleporter = false;
			note = 8;
			}
		}
	
	// Delete note
	if mouse_check_button(mb_right)
		{
		if global.use_external_assets sprite_index = global.spr_ui.tone;
		
		var data = global.ctrl_grid[xx][yy];
		if data > 0 global.ctrl_grid[xx][yy] = 0;
		(parent.field).update_surf_partial(xx,yy);//ctrl
	
		if data == 8 or data == 9
			{
			delete_teleporter_block(xx,yy,data);
			}
			
		if place_teleporter
			{
			place_teleporter = false;
			global.ctrl_grid[tele_obj[0]][tele_obj[1]]  = 0;
			(parent.field).update_surf_partial(tele_obj[0],tele_obj[1]);
			tele_obj = [];
			note = 8;
			}
	
		// existing flag check
		delete_flag(xx,yy);
		}
	}