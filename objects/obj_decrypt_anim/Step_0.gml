event_inherited();
if selected
	{
	if keyboard_check_pressed(vk_up) surf_scale += 1.0;
	if keyboard_check_pressed(vk_down) && surf_scale > 1.0 surf_scale -= 1.0;
	if keyboard_check_pressed(vk_left) && surf_side > 0 surf_side -= 1;
	if keyboard_check_pressed(vk_right) && surf_side < array_length(spr)-1 surf_side += 1;
	if keyboard_check_pressed(vk_space)
		{
		for (var ff=0;ff<array_length(spr);ff++)
		    {
		    //if surface_exists(surf[ff]) then surface_free(surf[ff]);
			if sprite_exists(spr[ff]) then sprite_delete(spr[ff]);
		    }
		event_user(0);
		}
	if keyboard_check_pressed(vk_enter)
		{
		var f = get_save_filename("*.png","anim0.png");
		if f != "" 
			{
			for (var z=0;z<3;z++) sprite_save(spr[z],0,filename_path(f)+"anim"+string(z)+".png");
			/*for (var i=0;i<8;i++)
				{
				sprite_save(spr_up[z][i],0,filename_path(f)+"spr_up+"+string(i)+"_zoom"+string(z)+".png");
				sprite_save(spr_down[z][i],0,filename_path(f)+"spr_up+"+string(i)+"_zoom"+string(z)+".png");
				sprite_save(spr_left[z][i],0,filename_path(f)+"spr_up+"+string(i)+"_zoom"+string(z)+".png");
				sprite_save(spr_right[z][i],0,filename_path(f)+"spr_up+"+string(i)+"_zoom"+string(z)+".png");
				}*/
			}
		}
	}