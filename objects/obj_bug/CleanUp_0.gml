// sounds
for (var i=0;i<array_length(snd_struct.buf);i++)
	{
	audio_free_buffer_sound(snd_struct.snd[i]);
	buffer_delete(snd_struct.buf[i]);
	}
	
// bug sprites
for (var i=0;i<3;i++)
	{
	for (var ii=0;ii<8;ii++) sprite_delete(spr_up[i][ii]);
	//sprite_delete(spr_down[i]);
	//sprite_delete(spr_left[i]);
	//sprite_delete(spr_right[i]);
	}

// bug hit anims
sprite_delete(spr_notehit_tl);
sprite_delete(spr_notehit_tr);
sprite_delete(spr_notehit_bl);
sprite_delete(spr_notehit_br);