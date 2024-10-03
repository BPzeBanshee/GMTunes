event_inherited();
if selected
	{
	if keyboard_check_pressed(vk_up) surf_scale += 1.0;
	if keyboard_check_pressed(vk_down) && surf_scale > 1.0 surf_scale -= 1.0;
	if keyboard_check_pressed(vk_left) direction += 90;
	if keyboard_check_pressed(vk_right) direction -= 90;
	if keyboard_check_pressed(vk_space)
		{
		if sprite_exists(spr) then sprite_delete(spr);
		event_user(0);
		}
	if keyboard_check_pressed(vk_enter)
		{
		var f = get_save_filename("*.png","show.png");
		if f != "" sprite_save(spr,0,f);
		}
	}