///@desc Load selected bugs and exit
// TODO: assign already loaded assets to save time/memory
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

loading_prompt = false;
instance_destroy();