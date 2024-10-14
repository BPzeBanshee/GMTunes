// Inherit the parent event
event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var spr = global.use_external_assets ? global.spr_flag2[flag_id] : spr_flag;
draw_sprite_ext(spr,flag_id,mx,my,1,1,direction,c_white,1);