if global.use_external_assets
	{
	if sprite_exists(spr) sprite_delete(spr);
	var sounds = [b,snd_play,snd_gal,snd_tut,snd_quit];
	for (var i=0;i<array_length(sounds);i++)
		{
		if audio_exists(sounds[i]) audio_free_buffer_sound(sounds[i]);
		}
	}