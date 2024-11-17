if (y >= room_height or device_mouse_y_to_gui(0) > 416) then exit;
if mouse_check_button_pressed(mb_left)
	{
	if zooming_in
		{
		zoom_in();
		if global.zoom == 2 then zooming_in = false;
		}
	else
		{
		zoom_out();
		if global.zoom == 0 then zooming_in = true;
		}
	}
if mouse_check_button_pressed(mb_right)
	{
	zoom_out();
	if global.zoom == 0 then zooming_in = true;
	}