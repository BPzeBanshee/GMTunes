///@desc Animate "playing" effect
anim_index += 1;
if anim_index < sprite_get_number(spr_notehit_tl)-1 then alarm[0] = 2 else
	{
	anim_playing = false;
	anim_index = 0;
	}