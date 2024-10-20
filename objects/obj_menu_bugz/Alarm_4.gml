if loading_obj.alpha < 1
alarm[4] = 1
else
	{
	var o = obj_ctrl_playfield;
	instance_activate_object(o);
	instance_activate_object(obj_bug);
	/*var bug_list = [o.bug_yellow,o.bug_green,o.bug_blue,o.bug_red];
	var mybug;
	for (var i=0;i<4;i++) 
		{
		switch i
			{
			case 0: mybug = o.bug_yellow; break;
			case 1: mybug = o.bug_green; break;
			case 2: mybug = o.bug_blue; break;
			case 3: mybug = o.bug_red; break;
			}
		if bug_x[i] > -1 
			{
			mybug.paused = bug_paused[i];
			}
		}*/
	loading_obj.mode = 2;
	instance_destroy();
	}