event_inherited();

bug_to_grab = noone;
if keyboard_check(ord("Y"))
	{
	image_blend = c_yellow;
	bug_to_grab = parent.bug_yellow;
	}
if keyboard_check(ord("G"))
	{
	image_blend = c_lime;
	bug_to_grab = parent.bug_green;
	}
if keyboard_check(ord("B"))
	{
	image_blend = c_blue;
	bug_to_grab = parent.bug_blue;
	}
if keyboard_check(ord("R"))
	{
	image_blend = c_red;
	bug_to_grab = parent.bug_red;
	}
if bug_to_grab == noone then image_blend = c_white;

if y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
if mouse_check_button(mb_left) or mouse_check_button(mb_right)
	{
	pressed = true;
	released = false;
	grab_bug();
	}
else
	{
	pressed = false;
	if released == false
		{
		drop_bug();
		released = true;
		}
	}