// Draw surface of stamp here
event_inherited();
var xx = device_mouse_x_to_gui(0);
var yy = device_mouse_y_to_gui(0);
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
	
	if device_mouse_y_to_gui(0) > 416
		{
		xx = room_width/2;
		yy = room_height/2;
		}
		
    var sx = xx + lengthdir_x(ww,direction+180) + lengthdir_x(hh,direction+90);
    var sy = yy + lengthdir_y(ww,direction+180) + lengthdir_y(hh,direction+90);
    draw_surface_ext(surf,sx,sy,scale,scale,direction,c_white,1);
	
	/*var sh = string_height(desc);
	draw_text(x,round(bbox_top-sh-30),name);
	draw_text(x,round(bbox_top-sh-15),author);
	draw_text(x,round(bbox_top-sh),desc);*/
    }
else
	{
	if global.use_external_assets
	draw_sprite(move_mode ? global.spr_ui.move : global.spr_ui.copy,0,xx,yy)
	else 
		{
		draw_set_color(move_mode ? c_aqua : c_orange);
		draw_set_alpha(1);
		draw_line(x-4,y,x+4,y);
		draw_line(x,y-4,x,y+4);
		}
	}