// Inherit the parent event
event_inherited();
update_surf = function() {
if !surface_exists(surf) surf = surface_create(2,1);
surface_set_target(surf);
draw_clear(c_black);
draw_sprite_part(spr_note,note-1,0,0,1,1,1,0);
surface_reset_target();
note_prev = note;
}
note = 1;
note_prev = 1;
surf = -1;

if global.use_external_assets 
	{
	cursor_sprite = -1;//global.spr_ui.tone;
	update_surf();
	}