var spr = mystruct.back;
if sprite_exists(spr) 
    {
    var ww = (sprite_get_width(spr)/2) * surf_scale;
    var hh = (sprite_get_height(spr)/2) * surf_scale;
    image_xscale = ww;
    image_yscale = hh;
    image_angle = direction;
    var xx = x + lengthdir_x(ww,direction+180) + lengthdir_x(hh,direction+90);
    var yy = y + lengthdir_y(ww,direction+180) + lengthdir_y(hh,direction+90);
    draw_sprite_ext(spr,0,xx,yy,surf_scale,surf_scale,direction,c_white,1);
	
	scr_draw_vars(global.fnt_default,fa_left,c_white);
	draw_text(xx,yy,mystruct.name+"\n"+mystruct.desc);
    }
event_inherited();