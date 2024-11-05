// Draw surface of stamp here
event_inherited();
var xx = device_mouse_x_to_gui(0);
var yy = device_mouse_y_to_gui(0);
	
// scale figure
var rs = 16;
if global.zoom == 1 rs = 8;
if global.zoom == 0 rs = 4;
		
if copy_x > -1 && copy_y > -1 && !loaded
	{
	var r = xy_to_gui(copy_x*16,copy_y*16);
	var r2 = xy_to_gui(floor(x/16)*16,floor(y/16)*16);
	draw_rectangle(r.gx,r.gy,r2.gx,r2.gy,true);
	}
	
if global.use_external_assets
draw_sprite(move_mode ? global.spr_ui.move : global.spr_ui.copy,0,xx,yy)
else 
	{
	draw_set_color(move_mode ? c_aqua : c_orange);
	draw_set_alpha(1);
	draw_line(x-4,y,x+4,y);
	draw_line(x,y-4,x,y+4);
	}
	
/*draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var sh = string_height(desc);
	draw_text(x,round(bbox_top-sh-30),name);
	draw_text(x,round(bbox_top-sh-15),author);
	draw_text(x,round(bbox_top-sh),desc);*/