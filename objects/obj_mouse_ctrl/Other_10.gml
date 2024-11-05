// Feather disable GM2016
delete_teleporter_block = function(xx,yy,data)
	{
	var order = [0,1,2,3];
	if data == 9 order = [2,3,0,1];
	var ind = 0;
	for (var i=0; i<array_length(global.warp_list); i++)
		{
		if global.warp_list[i][order[0]] == xx
		&& global.warp_list[i][order[1]] == yy
		ind = i;
		}

	var ox = global.warp_list[ind][order[2]];
	var oy = global.warp_list[ind][order[3]];
	global.ctrl_grid[ox][oy] = 0;
	(parent.field).update_surf_partial(ox,oy);//ctrl
	array_delete(global.warp_list,ind,1);
		
	trace(string("[{0},{1}]",xx,yy)+" removed from warp list\nUpdated warp list: "+string(global.warp_list));
	}
	
delete_flag = function(xx,yy)
	{
	for (var i=0;i<4;i++)
		{
		if xx == global.flag_list[i,0] 
		&& yy == global.flag_list[i,1]
		global.flag_list[i,2] = -1;
		}
	}