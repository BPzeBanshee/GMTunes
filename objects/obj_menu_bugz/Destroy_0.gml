var cam = view_camera[0];
camera_set_view_pos(cam,cam_pos[0],cam_pos[1]);
camera_set_view_size(cam,cam_siz[0],cam_siz[1]);
instance_activate_object(obj_ctrl_playfield);
with obj_button_dgui alarm[2] = 5;
with obj_bug paused = false;