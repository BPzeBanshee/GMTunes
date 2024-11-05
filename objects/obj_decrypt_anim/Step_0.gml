event_inherited();
index += 0.25;
if index > 7 index = 0;

if selected
	{
	if keyboard_check_pressed(vk_up) if zoom < 2 zoom++;
	if keyboard_check_pressed(vk_down) && zoom > 0 zoom--;
	if keyboard_check_pressed(vk_left) direction -= 90;
	if keyboard_check_pressed(vk_right) direction += 90;
	if keyboard_check_pressed(vk_space)
		{
		delete_sprites();
		event_user(0);
		}
	if keyboard_check_pressed(vk_enter)
		{
		var f = get_save_filename("*.png","anim0.png");
		if string_length(f)>0 save_sprites(f);
		}
	}