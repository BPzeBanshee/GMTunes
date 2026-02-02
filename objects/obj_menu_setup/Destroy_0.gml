if room == rm_playfield
	{
	var cam = view_camera[0];
	camera_set_view_pos(cam,cam_pos[0],cam_pos[1]);
	camera_set_view_size(cam,cam_siz[0],cam_siz[1]);
	instance_activate_object(obj_ctrl_playfield);
	instance_activate_object(obj_draw_playfield);
	instance_activate_object(obj_bug);
	instance_activate_object(mouse_old);
	with obj_button_dgui alarm[2] = 5;
	instance_destroy(mymouse);
	}