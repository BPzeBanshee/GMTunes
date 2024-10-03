/*var tun_struct = global.playfield;
var bugz = [tun_struct.bugz.yellow,tun_struct.bugz.green,tun_struct.bugz.blue,tun_struct.bugz.red];

for (var i=0;i<4;i++)
	{
	if (ds_map_find_value(async_load, "id") == loadid[i] && loadid[i] > -1)
		{
	    if (ds_map_find_value(async_load, "status") == false)
			{
	        show_debug_message("Load ID {0} failed!",loadid[i]);
			}
		else
			{
			var bug = bug_create_from_buffer(bugz[i].pos[0],bugz[i].pos[1],bugz[i].filename,buf[i]);
			bug.gear = bugz[i].gear;
			bug.paused = bugz[i].paused;
			bug.volume = bugz[i].volume;
			bug.direction = bugz[i].dir;
			bug.calculate_timer();
	
			// apply the bugz to obj_ctrl_playfield's local bug tracking
			switch i
				{
				case 0: bug_yellow = bug; break;
				case 1: bug_green = bug; break;
				case 2: bug_blue = bug; break;
				case 3: bug_red = bug; break;
				}
			}
		}
	}*/