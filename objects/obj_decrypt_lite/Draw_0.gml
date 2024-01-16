if mode == 0
	{
	if surface_exists(surf) then draw_surface_ext(surf,x-sw,y-sh,1,1,0,c_white,1);
	}
else 
	{
	draw_sprite(spr_notehit_tl,spr_index,x,y);
	draw_sprite(spr_notehit_tr,spr_index,x,y);
	draw_sprite(spr_notehit_bl,spr_index,x,y);
	draw_sprite(spr_notehit_br,spr_index,x,y);
	}

/*if surface_exists(spr2[floor(spr_index)])
	{
	var ww = (surface_get_width(spr2[floor(spr_index)])/2) * surf_scale;
	var hh = (surface_get_height(spr2[floor(spr_index)])/2) * surf_scale;
    image_xscale = ww;
    image_yscale = hh;
    image_angle = direction;
    var xx = x + lengthdir_x(ww,direction+180) + lengthdir_x(hh,direction+90);
    var yy = y + lengthdir_y(ww,direction+180) + lengthdir_y(hh,direction+90);
	draw_surface_ext(spr2[floor(spr_index)],xx,yy,surf_scale,surf_scale,direction,c_white,1);
	}*/
event_inherited();