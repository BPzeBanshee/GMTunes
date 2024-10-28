///@desc Do Tasks

// While fading in, do nothing
if loading_obj.alpha < 1
	{
	alarm[0] = 1;
	exit;
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
/*for (var xx=0;xx<4;xx++)
	{
	for (var yy=0; yy < array_length(lists[xx]); yy++)
		{
		bug[xx][yy] = load_bug_metadata(dir+lists[xx][yy]);
		}
	}*/
	
// Fade out when done, otherwise keep doing stuff
loading_obj.tasks++;
if loading_obj.tasks == loading_obj.max_tasks
	{
	ready = true;
	loading_obj.mode = 2;
	alarm[1] = 3;
	}
else alarm[0] = 1;