///@desc Add/override note
if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(mouse_x/16);
var yy = floor(mouse_y/16);
if xx >= 0 && xx <= 160 && yy >= 0 && yy <= 104
	{
	// mouse press check
	if (note == 8 or note == 9) && !mouse_check_button_pressed(mb_left) then exit;
	
	// existing control note check
	var c = ds_grid_get(global.ctrl_grid,xx,yy);
	if c > 0
		{
		// wipe grid position
		ds_grid_set(global.ctrl_grid,xx,yy,0);
		
		// teleport block handling
		if c == 8 or c == 9
			{
			delete_teleporter_block(xx,yy,c);
			}
		}
		
	// Set note
	ds_grid_set(global.ctrl_grid,xx,yy,note);
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