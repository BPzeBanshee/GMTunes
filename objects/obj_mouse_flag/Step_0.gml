if mouse_y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(x/16);
var yy = floor(y/16);
if mouse_check_button_pressed(mb_left)
	{
	// SimTunes dictates flags cannot share positions with other flags
	for (var i=0;i<4;i++)
		{
		if xx == global.flag_list[i,0] 
		&& yy == global.flag_list[i,1]
		&& i != flag_id
		global.flag_list[i,2] = -1;
		}
		
	// it also dictates flags cannot share positions with control notes,
	// probably because it's considered a special type of control note itself
	if ds_grid_get(global.ctrl_grid,xx,yy) != 34
		{
		ds_grid_set(global.ctrl_grid,xx,yy,34);
		(parent.field).update_surf_partial(xx,yy);
		}
		
	//if xx == global.flag_list[flag_id,0] && yy == global.flag_list[flag_id,1]
	if global.flag_list[flag_id,2] == -1 
	global.flag_list[flag_id,2] = 0
	else
		{
		global.flag_list[flag_id,2] -= 90;
		if global.flag_list[flag_id,2] < 0 global.flag_list[flag_id,2] = 270;
		}
	global.flag_list[flag_id,0] = xx;
	global.flag_list[flag_id,1] = yy;
	}
if mouse_check_button_pressed(mb_right)
	{
	for (var i=0; i<4;i++)
		{
		// could nuke the x/y values but SimTunes actually keeps them (cfr TRAVELIN.GAL)
		if xx == global.flag_list[i,0] 
		&& yy == global.flag_list[i,1]
		global.flag_list[i,2] = -1;
		}
	}