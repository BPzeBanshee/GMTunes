timer += 1;
switch mode
	{
	case 0:
	case 1:
		{
		if timer < 120
			{
			if alpha < 1 then alpha += 0.05;
			}
		if keyboard_check_pressed(vk_anykey) && timer < 120 then timer = 120;
		if timer > 120
			{
			alpha -= 0.05;
			if alpha == 0
				{
				timer = 0;
				mode++;
				}
			}
		break;
		}
	case 2:
		{
		if audio_exists(s)
			{
			audio_play_sound(s,0,false);
			timer = 0;
			alpha = 1;
			alarm[0] = ceil(60/ff);
			mode++;
			}
		else mode = 4;
		break;
		}
	case 3:
		{
		if timer >= (audio_sound_length(s)*60) 
		or (keyboard_check_pressed(vk_anykey) && !keyboard_check(vk_f4))
			{
			audio_stop_sound(s);
			mode++;
			}
		break;
		}
	case 4:
		{
		room_goto(rm_main);
		break;
		}
	}