// Inherit the parent event
event_inherited();
surf = -1;

note = 1;
note_prev = note;

mbr = mouse_check_button(mb_right);
mbr_prev = mbr;

if global.use_external_assets 
	{
	cursor_sprite = -1;//global.spr_ui.tone;
	update_surf();
	}