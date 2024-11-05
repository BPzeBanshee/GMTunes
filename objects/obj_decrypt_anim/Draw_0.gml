if is_array(spr)
	{
	var s = spr[zoom][floor(index)];
	var ww = (sprite_get_width(s) / 2);
    var hh = (sprite_get_height(s) / 2);
	image_xscale = ww;
    image_yscale = hh;
	draw_sprite_ext(s,0,x,y,1,1,direction,c_white,1);
	}
event_inherited();