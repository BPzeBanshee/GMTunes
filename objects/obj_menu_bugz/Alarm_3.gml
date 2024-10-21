///@desc Load selected bugs and exit
// TODO: assign already loaded assets to save time/memory
if loading_obj.alpha < 1
alarm[3] = 1
else
	{
	instance_activate_object(obj_ctrl_playfield);
	instance_activate_object(obj_bug);
	var mybug;
	var lists = [list_yellow,list_green,list_blue,list_red];
	for (var i=0;i<4;i++)
		{
		trace(lists[i][bug_index[i]]);
		var o = obj_ctrl_playfield;
		switch i
			{
			case 0: o.load_yellow(dir+lists[i][bug_index[i]]); mybug = o.bug_yellow; break;
			case 1: o.load_green(dir+lists[i][bug_index[i]]); mybug = o.bug_green; break;
			case 2: o.load_blue(dir+lists[i][bug_index[i]]); mybug = o.bug_blue; break;
			case 3: o.load_red(dir+lists[i][bug_index[i]]); mybug = o.bug_red; break;
			}
		if bug_x[i] > -1 
			{
			mybug.x = bug_x[i];
			mybug.y = bug_y[i];
			mybug.ctrl_x = bug_ctrl_x[i];
			mybug.ctrl_y = bug_ctrl_y[i];
			mybug.warp = bug_warp[i];
			mybug.paused = bug_paused[i];
			mybug.direction = bug_dir[i];
			mybug.gear = bug_gear[i];
			mybug.volume = bug_volume[i];
			}
		}

	loading_obj.mode = 2;
	instance_destroy();
	}