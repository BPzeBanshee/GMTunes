// Inherit the parent event
event_inherited();
note = 1;
place_teleporter = false;
tele_obj = [];

if global.use_external_assets
	{
	cursor_sprite = global.spr_ui.ctrl[note];
	}