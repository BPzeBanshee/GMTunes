if global.zoom == 2
	{
	var xx = x+8;
	var yy = y+8;
	if !paused
		{
		var dx = x+8+lengthdir_x(16,direction);
		var dy = y+8+lengthdir_y(16,direction);
		if warp
			{
			dx = ctrl_x+8;
			dy = ctrl_y+8;
			}
		var t = max(0,timer/timer_max);
		xx = lerp(x+8,dx,1-t);
		yy = lerp(y+8,dy,1-t);
		}
	
	draw_anim(xx,yy);
	draw_bug(xx,yy);
	}