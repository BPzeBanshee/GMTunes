event_inherited();
if selected
	{
	if keyboard_check_pressed(vk_enter)
		{
		var f = get_save_filename("*.json",filename_change_ext(filename,".json"));
		if f != ""
			{
			var struct = {name: str_name, desc: str_desc};
			var t = json_stringify(struct,true);
			var ff = file_text_open_write(f);
			file_text_write_string(ff,t);
			file_text_close(ff);
			}
		}
	}