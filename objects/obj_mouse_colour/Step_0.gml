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
if keyboard_check(vk_shift)
	{
	if held_x == -1 
	&& held_y == -1
		{
		held_x = xx;
		held_y = yy;
		}
	else 
		{
		if xx != held_x && !hold_x hold_y = true;
		if yy != held_y && !hold_y hold_x = true;
		if hold_y yy = held_y;
		if hold_x xx = held_x;
		}
	}
else
	{
	held_x = -1; hold_x = false;
	held_y = -1; hold_y = false;	
	}
	


if point_in_rectangle(xx,yy,0,0,160,104)
	{
	// Color picker
	var colorpick = false;
	if keyboard_check_pressed(vk_oem_comma) mbr = true;
	if keyboard_check(vk_oem_comma)
		{
		colorpick = true;
		var data = global.note_grid[xx][yy];
		if mouse_check_button_pressed(mb_left) && data > 0 
			{
			note = data;
			mbr = false;
			}
		}
	
	// Record prior state
	if mouse_check_button_pressed(mb_left)
	or mouse_check_button_pressed(mb_right)
		{
		parent.record();
		}
		
	// Add/override note
	if mouse_check_button(mb_left) && !colorpick
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
		
	if !mouse_check_button(mb_left)
	&& !mouse_check_button(mb_right)
	&& !keyboard_check(vk_oem_comma)
	mbr = false;
	}