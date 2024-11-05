event_inherited();

if selected
    {
    if keyboard_check_pressed(vk_left)
        {
        if index > 0 then index -= 1;
        }
    if keyboard_check_pressed(vk_right)
        {
        if index < array_length(snd)-1 then index += 1;
        }
    if keyboard_check_pressed(ord("Z"))
        {
        audio_play_sound(snd[index],0,false);
        }
	if keyboard_check_pressed(vk_space)
		{
		save_sounds();
		}
    }