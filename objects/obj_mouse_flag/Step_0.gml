if mouse_check_button_pressed(mb_left)
	{
	if mouse_y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
	var o = obj_ctrl_playfield;
	var col = collision_point(mouse_x,mouse_y,o.flag[flag_id],false,false);
	if col
		{
		col.direction += 90;
		if col.direction >= 360 col.direction = 0;
		//col.image_angle = col.direction;
		}
	else
		{
		if instance_exists(o.flag[flag_id]) then instance_destroy(o.flag[flag_id]);
	
		o.flag[flag_id] = instance_create_depth(mouse_x,mouse_y,98,obj_flag);
		o.flag[flag_id].flagtype = flag_id;
		o.flag[flag_id].image_index = flag_id;
		if !global.use_int_spr then o.flag[flag_id].sprite_index = global.spr_flag2[flag_id];
		}
	}