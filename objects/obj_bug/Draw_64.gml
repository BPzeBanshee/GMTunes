if global.zoom < 2
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
	var xy = xy_to_gui(xx,yy);
	draw_anim(xy.gx,xy.gy);
	draw_bug(xy.gx,xy.gy);
	
	//var g = xy_to_gui(xx+500,yy+50);
	//draw_line_color(xy.gx,xy.gy,g.gx,g.gy,c_white,c_white);
	}