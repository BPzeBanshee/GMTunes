rfps_timer += 1;
rfps_avg += max(0,fps_real);
if rfps_timer == 60
    {
    rfps_txt = string(round(rfps_avg/60));
    rfps_avg = 0;
    rfps_timer = 0;
    }

if keyboard_check_pressed(vk_f1)
	{
	global.use_texfilter = !global.use_texfilter;
	gpu_set_texfilter(global.use_texfilter);
	}
if keyboard_check_pressed(vk_f2)
	{
	game_restart();
	}
if keyboard_check_pressed(vk_f4)
	{
	if keyboard_check(vk_lalt) or keyboard_check(vk_ralt)
	then game_end()
	else window_set_fullscreen(!window_get_fullscreen());
	}
if keyboard_check_pressed(vk_f12)
	{
	show_debug_overlay(!is_debug_overlay_open());
	}