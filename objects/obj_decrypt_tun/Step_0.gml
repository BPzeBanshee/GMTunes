event_inherited();
if selected
	{
	if keyboard_check_pressed(vk_up) then surf_scale += 1;
	if keyboard_check_pressed(vk_down) && surf_scale > 0 then surf_scale -= 1;
	if keyboard_check_pressed(vk_space)
		{
		buffer_delete(oldchunk);
		buffer_delete(newchunk);
		if buffer_exists(newchunk_enc) buffer_delete(newchunk_enc);
		oldchunk = buffer_create(1,buffer_grow,1);
		newchunk = buffer_create(1,buffer_grow,1);
		event_user(0);
		}
	if keyboard_check_pressed(vk_enter)
		{
		var f = get_save_filename("*.dat","chunk_og.dat");
		if f != "" buffer_save(oldchunk,f);

		f = get_save_filename("*.dat","chunk_raw.dat");
		if f != "" buffer_save(newchunk,f);

		f = get_save_filename("*.dat","chunk_enc.dat");
		if f != "" buffer_save(newchunk_enc,f);
		}
	}