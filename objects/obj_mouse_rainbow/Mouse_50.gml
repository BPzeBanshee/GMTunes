///@desc Add/override note
if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(x/16);
var yy = floor(y/16);
if xx >= 0 && xx <= 160 && yy >= 0 && yy <= 104
	{
	var data = ds_grid_get(global.pixel_grid,xx,yy);
	if data != note
		{
		ds_grid_set(global.pixel_grid,xx,yy,note);
		(parent.field).update_surf_partial(xx,yy);
		}
	if xxlast != xx or yylast != yy
		{
		note += 1;
		if note > 25 then note = 1; 
		xxlast = xx;
		yylast = yy;
		}
	}