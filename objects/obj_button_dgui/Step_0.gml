if !enabled exit;
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
if point_in_rectangle(mx,my,bbox_left,bbox_top,bbox_right,bbox_bottom)
	{
	if !entered
		{
		image_index = 1 + mouse_check_button(mb_left);
		entered = true;
		}
	if mouse_check_button_pressed(mb_left) then image_index = 2;
	if mouse_check_button_released(mb_left)
		{
		pressed = true;
		alarm[0] = 1;
		}
	}
else
	{
	image_index = 0;
	entered = false;
	}