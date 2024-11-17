event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
draw_set_alpha(1);
scr_draw_vars(global.fnt_default,fa_left,c_white);
draw_text(mx,my-10,"Z: "+string(global.zoom));