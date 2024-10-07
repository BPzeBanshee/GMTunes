// Feather disable GM2016
if mouse_check_button_pressed(mb_left) && !done
	{
	var mx = mouse_x;
	var my = mouse_y;
	
	var confirm_x = 226;
	var cancel_x = 344;
	var reset_x = 461;
	var button_y = 449; // all the buttons are on same y axis
	
	// confirm button
	if point_in_rectangle(mx,my,confirm_x,button_y,confirm_x+110,button_y+32)
		{
		alarm[0] = 2;
		loading_prompt = true;
		done = true;
		}
		
	// cancel button
	if point_in_rectangle(mx,my,cancel_x,button_y,cancel_x+110,button_y+32)
		{
		instance_destroy();
		}
		
	// reset bugz
	if point_in_rectangle(mx,my,reset_x,button_y,reset_x+110,button_y+32)
		{
		for (var i=0;i<4;i++)
			{
			bug_index[i] = 0;
			}
		}
	}