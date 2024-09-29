if surface_exists(bmp) then surface_free(bmp);
if sprite_exists(spr) then sprite_delete(spr);

var sounds = [b,snd_play,snd_gal,snd_tut,snd_quit];
for (var i=0;i<array_length(sounds);i++)
	{
	if audio_exists(sounds[i]) audio_free_buffer_sound(sounds[i]);
	}