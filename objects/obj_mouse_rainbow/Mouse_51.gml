///@desc Delete note
if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(mouse_x/16);
var yy = floor(mouse_y/16);
if xx >= 0 && xx < 160 && yy >= 0 && yy < 104
	{
	var data = global.pixel_grid[xx][yy];
	if data > 0 global.pixel_grid[xx][yy] = 0;
	(parent.field).update_surf_partial(xx,yy);
	}