// Inherit the parent event
event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var spr = global.use_int_spr ? spr_flag : global.spr_flag2[flag_id];
draw_sprite_ext(spr,flag_id,mx,my,1,1,direction,c_white,1);