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
	
// scale figure
var rs = 16;
if global.zoom == 1 rs = 8;
if global.zoom == 0 rs = 4;
		
if copy_x > -1 && copy_y > -1 && !loaded
	{
	var rx = rs * floor(xx/rs);
	var ry = rs * floor(yy/rs);
	var w = copy_w * rs;
	var h = copy_h * rs;
	var sx = rx - floor(max(copy_w,0)*rs);
	var sy = ry - floor(max(copy_h,0)*rs);
	draw_rectangle(sx,sy,sx+abs(w),sy+abs(h),true);
	/*var x1 = rs * copy_x;
	var y1 = rs * copy_y;
	var x2 = rs * floor(xx/rs);
	var y2 = rs * floor(yy/rs);
	draw_rectangle(x1,y1,x2,y2,true);*/
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
	
	var rx,ry;
	if device_mouse_y_to_gui(0) > 416
		{
		rx = window_get_width()/2+ww;
		ry = window_get_height()/2+hh;
		}
	else
		{
		rx = rs * floor(xx/rs);
		ry = rs * floor(yy/rs);
		}
			
	var w = copy_w * rs;
	var h = copy_h * rs;
	var sx = rx - (max(copy_w,0)*rs);
	var sy = ry - (max(copy_h,0)*rs);
	draw_rectangle(sx,sy,sx+abs(w),sy+abs(h),true);
    draw_surface_ext(surf,sx,sy,scale,scale,direction,c_white,1);
	
	/*var sh = string_height(desc);
	draw_text(x,round(bbox_top-sh-30),name);
	draw_text(x,round(bbox_top-sh-15),author);
	draw_text(x,round(bbox_top-sh),desc);*/
    }