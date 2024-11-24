timer += 1;
switch mode
	{
	case 0:
	case 1:
		{
		if timer < g*2
			{
			if alpha < 1 then alpha += inc;
			}
		if (keyboard_check_pressed_sane(vk_anykey) || mouse_check_button_pressed(mb_any)) 
		&& timer < g*2 timer = g*2;
		if timer > g*2
			{
			alpha -= inc;
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
			alarm[0] = ceil(g/ff);
			mode++;
			}
		else mode = 4;
		break;
		}
	case 3:
		{
		if timer >= (audio_sound_length(s)*g)
		or ((keyboard_check_pressed_sane(vk_anykey) || mouse_check_button_pressed(mb_any))  
		&& !keyboard_check(vk_f4))
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