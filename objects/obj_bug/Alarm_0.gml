///@desc Animate "playing" effect
anim_index += 1;
if anim_index < array_length(spr_notehit_tl) then alarm[0] = 2 else
	{
	anim_playing = false;
	anim_index = 0;
	}