if global.zoom == 2
	{
	var xx,yy;
	if !paused
		{
		var dx,dy;
		if warp
			{
			dx = ctrl_x+8;
			dy = ctrl_y+8;
			}
		else
			{
			dx = x+8+lengthdir_x(16,direction);
			dy = y+8+lengthdir_y(16,direction);
			}
		xx = lerp(x+8,dx,1-(timer/timer_max));
		yy = lerp(y+8,dy,1-(timer/timer_max));
		}
	else
		{
		xx = x+8;                                                                                                                                                                                                                      
		yy = y+8;                                     
		}
	
	draw_anim(xx,yy);
	draw_bug(xx,yy);
	
	//var g = xy_to_gui(xx,yy);
	//draw_line_color(x,y,(x-244),(y-50),c_white,c_white);
	/*
	var xx = x+8 + lengthdir_x(8,direction+180);
	var yy = y+8 + lengthdir_y(8,direction+180);
	draw_point_color(xx,yy,c_white);
	draw_set_alpha(0.5);
	draw_set_color(c_red);
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,false);
	*/
	}