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
		var order;
		if data == 9
		then order = [2,3,0,1]
		else order = [0,1,2,3];
		var ind = 0;
		for (var i=0; i<array_length(global.warp_list); i++)
			{
			if global.warp_list[i][order[0]] == xx
			&& global.warp_list[i][order[1]] == yy
			then ind = i;
			}

		var ox = global.warp_list[ind][order[2]];
		var oy = global.warp_list[ind][order[3]];
		ds_grid_set(global.ctrl_grid,ox,oy,0);
		(parent.field).update_surf_partial(ox,oy);//ctrl
		array_delete(global.warp_list,ind,1);
		
		trace("Warp list: "+string(global.warp_list));
		}
	}
if place_teleporter
	{
	place_teleporter = false;
	note = 8;
	}