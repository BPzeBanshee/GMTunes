// Inherit the parent event
event_inherited();
image_blend = c_white;
pressed = false;
released = false;
grabbed_bug = noone;
bug_to_grab = noone;
if global.use_external_assets //cursor_sprite = global.spr_ui.tweezer;
	{
	cursor_sprite = -1;
	}