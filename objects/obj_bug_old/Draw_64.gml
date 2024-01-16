if global.zoom < 2
	{
	var xy = xy_to_gui(x+8,y+8);
	draw_anim(xy.gx,xy.gy);
	var sw = sprite_get_width(sprite_index)/4;
	var sh = sprite_get_height(sprite_index)/4;
	draw_sprite(sprite_index,image_index,xy.gx-sw,xy.gy-sh);
	}