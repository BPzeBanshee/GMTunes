// Inherit the parent event
event_inherited();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if global.use_external_assets
	{
	if note != note_prev update_surf();
	pal_swap_set(surf,1,true);
	draw_sprite(global.spr_ui.tone,0,mx,my);
	pal_swap_reset();
	}
else draw_sprite_ext(spr_note,note-1,mx-8,my-8,1,1,0,c_white,0.5);