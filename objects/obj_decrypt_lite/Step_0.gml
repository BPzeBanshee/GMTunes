event_inherited();
if selected
	{
	if keyboard_check_pressed(vk_space)
		{
		if sprite_exists(spr_notehit_sheet) sprite_delete(spr_notehit_sheet);
		event_user(0);
		}
	
	if keyboard_check_pressed(vk_shift)
		{
		mode = !mode;
		
		// Prepare window
		if mode == 1
			{
			image_xscale = sprite_get_width(spr_notehit_tl[0]);
			image_yscale = sprite_get_height(spr_notehit_tl[0]);
			}
		else
			{
			sw = sprite_get_width(spr_notehit_sheet)/2;
			sh = sprite_get_height(spr_notehit_sheet)/2;
			image_xscale = sw;
			image_yscale = sh;
			spr_index = 0;
			}
		}
	
	if keyboard_check_pressed(vk_enter)
		{
		var f = get_save_filename("*.png","styl_lite.png");
		if f != "" && sprite_exists(spr_notehit_sheet) 
			{
			sprite_save(spr_notehit_sheet,0,f);
			
			var j = json_stringify(ltxy_data,true);
			//trace("obj_decrypt_lite: json_stringified ltxy_data: {0}",j);
			var t = file_text_open_write(filename_path(f)+"ltxy_data.json");
			file_text_write_string(t,j);
			file_text_close(t);
			
			j = json_stringify(ltcc_data,true);
			//trace("obj_decrypt_lite: json_stringified ltcc_data: {0}",j);
			t = file_text_open_write(filename_path(f)+"ltcc_data.json");
			file_text_write_string(t,j);
			file_text_close(t);
			}
		}
	
	if mode == 1
		{
		if keyboard_check_pressed(vk_left)
			{
			spr_index -= 1;  
			if spr_index < 0 spr_index = array_length(spr_notehit_tl)-1;
			}
		if keyboard_check_pressed(vk_right)
			{
			spr_index += 1;  
			if spr_index > array_length(spr_notehit_tl)-1 spr_index = 0;
			}
		}
	else
		{
		if keyboard_check_pressed(vk_up) surf_scale += 1;
		if keyboard_check_pressed(vk_down) && surf_scale > 0 surf_scale -= 1;
		}
	}