// Inherit the parent event
event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
draw_sprite_ext(spr_note,note,mx-8,my-8,1,1,0,c_white,0.5);
