scr_draw_vars(fnt_system2,fa_left,c_black);
draw_set_alpha(1);

if !ready exit;

if global.use_external_assets 
	{
	// Draw setup menu base image
	draw_sprite(myback,0,0,0);
	
	// Top-Left Column
	// TODO: Sound Output (WAVE/MIDI)
	// TODO: Program Priority (unsure if outside project scope, TBA)
	
	// Middle Column
	// TODO: Interface sounds
	
	// Function Tile Clicks
	var tileclicks_x = global.function_tile_clicks ? 256 : 332;
	draw_sprite(global.spr_ui.tickbox_setup,0,tileclicks_x,115);
	
	// TODO: Auto-popup menu
	// TODO: Warning boxes
	
	// Right Column (using rectangle glow)
	// TODO: Display on Palette
	// TODO: Display on Tiles
	
	// Bottom row
	// Savegame directory for TUNES and STAMPS
	// TODO: custom directory options
	draw_sprite(global.spr_ui.tickbox_setup,0,22,334);
	
	// OK / CANCEL / RESET
	if draw_flash == 1 draw_sprite(global.spr_ui.onclick_okcancel,0,223,446);
	if draw_flash == 2 draw_sprite(global.spr_ui.onclick_okcancel,0,341,446);
	if draw_flash == 3 draw_sprite(global.spr_ui.onclick_okcancel,0,459,446);
	}
else
	{
	draw_set_color(c_white);
	var tileclicks_x = global.function_tile_clicks ? 256 : 332;
	var tileclicks_str = global.function_tile_clicks ? "ON" : "OFF";
	draw_text(226,146,"FUNCTION TILE CLICKS");
	draw_text(tileclicks_x+26,115,tileclicks_str);
	draw_rectangle(tileclicks_x,115,tileclicks_x+13,115+13,!global.function_tile_clicks);
	}
draw_text(29,362,global.main_dir+"TUNES\\"); // Default Directory
draw_text(44,415,global.main_dir+"TUNES\\"); // Custom Directory