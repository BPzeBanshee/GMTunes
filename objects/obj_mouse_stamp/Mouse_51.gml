///@desc Delete note
if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(mouse_x/16);
var yy = floor(mouse_y/16);
if xx >= 0 && xx <= 160 && yy >= 0 && yy <= 104
	{
	var dx = xx-floor(width/2);
	var dy = yy-floor(height/2);
	ds_grid_set_region(global.pixel_grid,dx,dy,xx+floor(width/2),yy+floor(height/2),0);
	(parent.field).update_surf();
	}