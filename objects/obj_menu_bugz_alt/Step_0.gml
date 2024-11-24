var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if mouse_check_button_pressed(mb_left)
	{
	if point_in_rectangle(mx,my,x,y,x+width,y+height)
		{
		if point_in_rectangle(mx,my,x,y,x+(width/2),y+(height/2))
			{
			(parent).load_yellow();
			}
		if point_in_rectangle(mx,my,x+(width/2),y,x+width,y+(height/2))
			{
			(parent).load_green();
			}
		if point_in_rectangle(mx,my,x,y+(height/2),x+(width/2),y+height)
			{
			(parent).load_blue();
			}
		if point_in_rectangle(mx,my,x+(width/2),y+(height/2),x+width,y+height)
			{
			(parent).load_red();
			}
		}
	else instance_destroy();
	}