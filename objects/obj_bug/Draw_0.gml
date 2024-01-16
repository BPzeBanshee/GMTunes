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
	draw_sprite_ext(sprite_index,image_index,xx,yy,image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	/*var xx = x+8 + lengthdir_x(8,direction+180);
	var yy = y+8 + lengthdir_y(8,direction+180);
	draw_point_color(xx,yy,c_white);
	draw_set_alpha(0.5);
	draw_set_color(c_red);
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,false);*/
	}