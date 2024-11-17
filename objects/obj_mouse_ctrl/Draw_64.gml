// Inherit the parent event
event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
if !global.use_external_assets
draw_sprite_ext(spr_note_ctrl,note-1,mx-8,my-8,1,1,0,c_white,0.5);
if place_teleporter
	{
	var xy = xy_to_gui((tele_obj[0]*16)+8,(tele_obj[1]*16)+8);
	draw_line(xy.gx,xy.gy,mx,my);
	}