///@desc Add/override note
if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(x/16);
var yy = floor(y/16);
if xx >= 0 && xx <= 160 && yy >= 0 && yy <= 104
	{
	var sx = xx - floor(width / 2);
	var sy = yy - floor(height / 2);
	for (var dx = 0; dx < width; dx++)
		{
		for (var dy = 0; dy < height; dy++)
			{
			var data = ds_grid_get(grid,dx,dy);
			if data > 0 then ds_grid_set(global.pixel_grid,sx+dx,sy+dy,data);
			}
		}
	//ds_grid_set_grid_region(global.pixel_grid,grid,0,0,width,height,sx,sy);
	(parent.field).update_surf();
	}