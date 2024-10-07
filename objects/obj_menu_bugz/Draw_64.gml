if loading_prompt
	{
	draw_set_alpha(1);
	scr_draw_vars(global.fnt_bold,fa_center,c_white);
	draw_rectangle_color(0,0,640,480,0,0,0,0,false);
	draw_text(320,240,"NOW LOADING (MAY LAG A BIT)");
	return;
	}