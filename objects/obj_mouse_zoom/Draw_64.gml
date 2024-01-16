// Inherit the parent event
event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
draw_text(mx,my,"Z: "+string(global.zoom));