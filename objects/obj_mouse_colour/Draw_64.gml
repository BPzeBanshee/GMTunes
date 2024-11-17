// Feather disable GM1041
if global.use_external_assets
	{
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	draw_set_alpha(1);
	gpu_set_tex_filter(false);
	if note != note_prev or mbr != mbr_prev update_surf();
	pal_swap_set(surf,1,true);
	draw_sprite(global.spr_ui.tone,0,mx,my);
	pal_swap_reset();
	gpu_set_tex_filter(global.use_texfilter);
	}