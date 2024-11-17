if !global.use_external_assets
	{
	draw_set_alpha(1);
	draw_rectangle_color(x-8,y-8,x+8,y+8,c_white,c_white,c_white,c_white,true);
	draw_sprite_ext(spr_note,note-1,x-8,y-8,1,1,0,c_white,0.5);
	}