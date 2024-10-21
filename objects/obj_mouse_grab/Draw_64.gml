// Inherit the parent event
event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
if global.use_external_assets
	{
	var spr = pressed ? global.spr_ui.tweezer2 : global.spr_ui.tweezer;
	draw_sprite_ext(spr,0,mx,my,1,1,0,image_blend,1);
	}
else draw_circle_color(mx,my,8,image_blend,image_blend,true);

if grabbed_bug != noone then draw_text(mx,my-8,"GEAR: "+string(grabbed_bug.gear));