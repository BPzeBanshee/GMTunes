///@desc Draw cursor
if sprite_exists(sprite_index) 
	{
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	draw_sprite_ext(sprite_index,image_index,mx,my,image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	}