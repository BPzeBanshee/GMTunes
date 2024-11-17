// Inherit the parent event
event_inherited();
surf = -1;

note = 1;
note_prev = note;

mbr = mouse_check_button(mb_right);
mbr_prev = mbr;

update_surf = function() {
if !surface_exists(surf) surf = surface_create(2,1);
surface_set_target(surf);
draw_clear_alpha(c_black,1);
if mbr
	{
	gpu_set_blendmode(bm_subtract);
	draw_point_color(1,0,c_black);
	gpu_set_blendmode(bm_normal);
	}
else draw_sprite_part(spr_note,note-1,0,0,1,1,1,0);
surface_reset_target();
note_prev = note;
mbr_prev = mbr;
}
if global.use_external_assets update_surf();