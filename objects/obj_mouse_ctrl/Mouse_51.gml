///@desc Delete note
if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(mouse_x/16);
var yy = floor(mouse_y/16);
if xx >= 0 && xx <= 160 && yy >= 0 && yy <= 104
	{
	var data = ds_grid_get(global.ctrl_grid,xx,yy);
	if data > 0 then ds_grid_set(global.ctrl_grid,xx,yy,0);
	(parent.field).update_surf_partial(xx,yy);//ctrl
	
	if data == 8 or data == 9
		{
		delete_teleporter_block(xx,yy,data);
		}
	}
if place_teleporter
	{
	place_teleporter = false;
	note = 8;
	}
	
// existing flag check
for (var i=0;i<4;i++)
	{
	if xx == global.flag_list[i,0] 
	&& yy == global.flag_list[i,1]
	global.flag_list[i,2] = -1;
	}