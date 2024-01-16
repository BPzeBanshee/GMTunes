event_inherited();

if selected
	{
	if keyboard_check_pressed(vk_up) then surf_scale += 1.0;
	if keyboard_check_pressed(vk_down) && surf_scale > 1.0 then surf_scale -= 1.0;
	if keyboard_check_pressed(vk_left) && surf_side > 0 then surf_side -= 1;
	if keyboard_check_pressed(vk_right) && surf_side < array_length(surf)-1
	then surf_side += 1;
	}