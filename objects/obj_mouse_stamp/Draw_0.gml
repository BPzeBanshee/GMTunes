// TODO: draw surface of stamp here
if surface_exists(surf) 
    {
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	//draw_set_valign(fa_middle);
	
    var ww = (surface_get_width(surf)/2) * scale;
    var hh = (surface_get_height(surf)/2) * scale;
    image_xscale = ww;
    image_yscale = hh;
    image_angle = direction;
    var xx = x + lengthdir_x(ww,direction+180) + lengthdir_x(hh,direction+90);
    var yy = y + lengthdir_y(ww,direction+180) + lengthdir_y(hh,direction+90);
    draw_surface_ext(surf,xx,yy,scale,scale,direction,c_white,1);
	
	/*var sh = string_height(desc);
	draw_text(x,round(bbox_top-sh-30),name);
	draw_text(x,round(bbox_top-sh-15),author);
	draw_text(x,round(bbox_top-sh),desc);*/
    }