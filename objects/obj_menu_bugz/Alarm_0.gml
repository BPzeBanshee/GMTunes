///@desc Do Tasks

// While fading in, do nothing
if loading_obj.alpha < 1
	{
	alarm[0] = 1;
	return;
	}

// Once faded in, start doing stuff
if xx == 0 && yy == 0
	{
	prep();
	
	if global.use_external_assets back = bmp_load_sprite(TUNERES+"Loadbugz.bmp");
	populate_list(list_yellow,dir+"YELLOW*.bug");
	populate_list(list_green,dir+"GREEN*.bug");
	populate_list(list_blue,dir+"BLUE*.bug");
	populate_list(list_red,dir+"RED*.bug");
	
	var max_tasks = array_length(list_yellow)+array_length(list_green)+array_length(list_blue)+array_length(list_red);
	loading_obj.max_tasks = max_tasks;
	loading_obj.mode = 1;
	}

var lists = [list_yellow,list_green,list_blue,list_red];
bug[xx][yy] = load_bug_metadata(dir+lists[xx][yy]);
if yy < array_length(lists[xx])-1
	{
	yy++;
	}
else
	{
	if xx < 4 
		{
		xx++;
		yy = 0;
		}
	}
/*
// Immediate load, but stalls app for some time
for (var _x=0;_x<4;_x++)
	{
	for (var _y=0; _y < array_length(lists[_x]); _y++)
		{
		bug[_x][_y] = load_bug_metadata(dir+lists[_x][_y]);
		}
	}
loading_obj.tasks = loading_obj.max_tasks-1;
*/
	
// Fade out when done, otherwise keep doing stuff
loading_obj.tasks++;
if loading_obj.tasks == loading_obj.max_tasks
	{
	ready = true;
	loading_obj.mode = 2;
	alarm[1] = g/20;
	}
else alarm[0] = 1;