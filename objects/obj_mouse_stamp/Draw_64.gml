// Draw surface of stamp here
event_inherited();
var xx = device_mouse_x_to_gui(0);
var yy = device_mouse_y_to_gui(0);

if global.use_external_assets
draw_sprite(move_mode ? global.spr_ui.move : global.spr_ui.copy,0,xx,yy)
else 
	{
	draw_set_color(move_mode ? c_aqua : c_orange);
	draw_set_alpha(1);
	draw_line(x-4,y,x+4,y);
	draw_line(x,y-4,x,y+4);
	}
		
if copy_x > -1 && copy_y > -1 && !loaded
	{
	var x1 = 16 * copy_x;
	var y1 = 16 * copy_y;
	var x2 = 16 * floor(x/16);
	var y2 = 16 * floor(y/16);
	draw_rectangle(x1,y1,x2,y2,true);
	}
	
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
		xx = window_get_width()/2;
		yy = window_get_height()/2;
		}
	else
		{
		xx = 16 * floor(x/16);
		yy = 16 * floor(y/16);
		}
	
	
			
	var w = copy_w * 16;//surface_get_width(surf) * scale;
	var h = copy_h * 16;//surface_get_height(surf) * scale;
	var sx = xx - (max(copy_w,0)*16);// - floor(width / 2);
	var sy = yy - (max(copy_h,0)*16);// - floor(height / 2);
    draw_surface_ext(surf,sx,sy,scale,scale,direction,c_white,1);
	draw_rectangle(sx,sy,sx+abs(w),sy+abs(h),true);
	/*var sh = string_height(desc);
	draw_text(x,round(bbox_top-sh-30),name);
	draw_text(x,round(bbox_top-sh-15),author);
	draw_text(x,round(bbox_top-sh),desc);*/
    }