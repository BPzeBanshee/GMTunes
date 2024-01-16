// Inherit the parent event
event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

draw_circle_color(mx,my,8,image_blend,image_blend,true);
if grabbed_bug != noone then draw_text(mx,my,"GEAR: "+string(grabbed_bug.gear));