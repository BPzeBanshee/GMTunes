///@desc Obsolete functions
/*
place_flag = function(flag_id){
if mouse_y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(mouse_x/16);
var yy = floor(mouse_y/16);
if xx == global.flag_list[flag_id,0] && yy == global.flag_list[flag_id,1]
	{
	global.flag_list[flag_id,2] += 90;
	if global.flag_list[flag_id,2] >= 360 global.flag_list[flag_id,2] = 0;
	}
else global.flag_list[flag_id,2] = 0;
global.flag_list[flag_id,0] = xx;
global.flag_list[flag_id,1] = yy;
}

if keyboard_check_pressed(ord("1")) then place_flag(0);
if keyboard_check_pressed(ord("2")) then place_flag(1);
if keyboard_check_pressed(ord("3")) then place_flag(2);
if keyboard_check_pressed(ord("4")) then place_flag(3);
if keyboard_check_pressed(ord("5")) then rally_bugz_to_flags();
*/
