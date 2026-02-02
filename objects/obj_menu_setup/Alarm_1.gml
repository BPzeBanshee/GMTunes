///@desc Fade in/out
if loading_obj.alpha < 1
	{
	alarm[1] = 1;
	return;
	}

if exiting == false
	{
	prep();
	loading_obj.mode = 2;
	ready = true;
	}
if exiting == true
	{
	with obj_button_dgui enabled = true;
	with obj_button enabled = true;
	
	if instance_exists(obj_menu_main) with obj_menu_main
		{
		enabled = true;
		audio_play_sound(snd_menu,0,true);
		}
	loading_obj.mode = 2;
	instance_destroy();
	}