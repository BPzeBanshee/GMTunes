if mouse_wheel_up() or (keyboard_check_pressed(vk_anykey) && ord(keyboard_lastchar) == ord("["))
	{
	if note < 25 then note += 1;
	}
if mouse_wheel_down() or (keyboard_check_pressed(vk_anykey) && ord(keyboard_lastchar) == ord("]"))
	{
	if note > 1 then note -= 1;
	}
	
if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(x/16);
var yy = floor(y/16);
if point_in_rectangle(xx,yy,0,0,160,104)
	{
	// Add/override note
	if mouse_check_button_pressed(mb_left)
	or mouse_check_button_pressed(mb_right)
		{
		parent.record();
		}
	if mouse_check_button(mb_left) 
		{
		var data = global.note_grid[xx][yy];
		if data != note
			{
			global.note_grid[xx][yy] = note;
			(parent.field).update_surf_partial(xx,yy);
			}
		}
	
	// Delete note
	if mouse_check_button(mb_right) 
		{
		mbr = true;
		var data = global.note_grid[xx][yy];
		if data > 0 global.note_grid[xx][yy] = 0;
		(parent.field).update_surf_partial(xx,yy);
		}
	else mbr = false;
	}