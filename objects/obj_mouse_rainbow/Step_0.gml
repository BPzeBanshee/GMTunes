if y >= room_height or device_mouse_y_to_gui(0) > 416 exit;
var xx = floor(x/16);
var yy = floor(y/16);
if point_in_rectangle(xx,yy,0,0,160,104)
	{
	if mouse_check_button_pressed(mb_left)
	or mouse_check_button_pressed(mb_right)
		{
		parent.record();
		}
	
	//Add/override note
	if mouse_check_button(mb_left)
		{
		var data = global.note_grid[xx][yy];
		if data != note && (xxlast != xx or yylast != yy)
			{
			global.note_grid[xx][yy] = note;
			(parent.field).update_surf_partial(xx,yy);
			
			note += 1;
			if note > 25 then note = 1; 
			xxlast = xx;
			yylast = yy;
			}
		}
	else
		{
		xxlast = -1;
		yylast = -1;
		}
		
	// Delete note
	if mouse_check_button(mb_right)
		{
		var data = global.note_grid[xx][yy];
		if data > 0 global.note_grid[xx][yy] = 0;
		(parent.field).update_surf_partial(xx,yy);
		}
	}