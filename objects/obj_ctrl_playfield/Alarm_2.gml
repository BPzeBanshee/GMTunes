///@desc Cycle Watch mode vars
if !watch_mode exit; 
watch_count++;
if watch_count > 4 watch_count = 0;
switch watch_count
	{
	case 0: watch_target = noone; break;
	case 1: watch_target = bug_yellow; break;
	case 2: watch_target = bug_green; break;
	case 3: watch_target = bug_blue; break;
	case 4: watch_target = bug_red; break;
	}
if watch_count == 0 repeat 2 zoom_out();
else 
	{
	if global.zoom == 0 zoom_in();
	var rng = choose(0,1);
	if rng == 1 
		{
		if global.zoom == 2 zoom_out() else zoom_in();
		}
	}

alarm[2] = game_get_speed(gamespeed_fps)*6;