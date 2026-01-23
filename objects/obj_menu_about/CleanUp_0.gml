if global.use_external_assets
	{
	if audio_exists(mysnd) audio_free_buffer_sound(mysnd);
	if sprite_exists(myspr) sprite_delete(myspr);
	}
if room == rm_debug_tools instance_activate_all();