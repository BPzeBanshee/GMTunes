// Feather disable GM2016
if mouse_check_button_pressed(mb_left)
	{
	if point_in_rectangle(mouse_x,mouse_y,226,449,226+110,449+32)
		{
		instance_activate_object(obj_ctrl_playfield);
		
		var lists = [list_yellow,list_green,list_blue,list_red];
		for (var i=0;i<4;i++)
			{
			trace(lists[i][bug_index[i]]);
			var o = obj_ctrl_playfield;
			switch i
				{
				case 0: o.load_yellow(dir+lists[i][bug_index[i]]); break;
				case 1: o.load_green(dir+lists[i][bug_index[i]]); break;
				case 2: o.load_blue(dir+lists[i][bug_index[i]]); break;
				case 3: o.load_red(dir+lists[i][bug_index[i]]); break;
				}
			}
			
		instance_destroy();
		}
		
	if point_in_rectangle(mouse_x,mouse_y,344,449,344+110,449+32)
		{
		instance_destroy();
		}
		
	if point_in_rectangle(mouse_x,mouse_y,461,449,461+110,449+32)
		{
		for (var i=0;i<4;i++)
			{
			bug_index[i] = 0;
			}
		}
	}