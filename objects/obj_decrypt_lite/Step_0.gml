event_inherited();
if selected
	{
	if keyboard_check_pressed(vk_enter)
		{
		mode = !mode;
		
		// Prepare window
		if mode == 1
			{
			image_xscale = sprite_get_width(spr_notehit_tl)/2;
			image_yscale = sprite_get_height(spr_notehit_tl)/2;
			}
		else
			{
			sw = surface_get_width(surf)/2;
			sh = surface_get_height(surf)/2;
			image_xscale = sw;
			image_yscale = sh;
			spr_index = 0;
			}
		}
	
	if mode == 1
		{
		if keyboard_check_pressed(vk_left)
			{
			spr_index -= 1;  
			if spr_index < 0 then spr_index = sprite_get_number(spr_notehit_tl);
			}
		if keyboard_check_pressed(vk_right)
			{
			spr_index += 1;  
			if spr_index == sprite_get_number(spr_notehit_tl) then spr_index = 0;
			}
		}
	else
		{
		/*if keyboard_check_pressed(vk_left)
			{
			if spr_index > 0 then spr_index -= 1;
			}
		if keyboard_check_pressed(vk_right)
			{
			if spr_index < array_length(spr2)-1 then spr_index += 1;
			}*/
		if keyboard_check_pressed(vk_up) then surf_scale += 1;
		if keyboard_check_pressed(vk_down) && surf_scale > 0 then surf_scale -= 1;
		}
	}