///@desc Obsolete functions
/*
load_bug = function(bugzid,filename=""){
var mycolor,dir;
switch bugzid
	{
	case 0: mycolor = "Yellow"; dir=0; break;
	case 1: mycolor = "Green"; dir=90; break;
	case 2: mycolor = "Blue"; dir=180; break;
	case 3: mycolor = "Red"; dir=270; break;
	default: return -1;
	}
if filename == ""
filename = get_open_filename_ext("Bugz File|*.BUG","",global.main_dir+"/BUGZ",string("Load {0} Bug",mycolor));
if filename != ""
	{
	var mybug = bug_create(room_width*0.5,room_height*0.5,filename);
	mybug.direction = dir;
	mybug.gear = 3;
	mybug.timer = game_get_speed(gamespeed_fps) / 3;
	mybug.paused = paused;
	return mybug;
	}
return -2;
}
load_yellow = function(filename=""){
var mybug = load_bug(0,filename);
if instance_exists(mybug)
	{
	instance_destroy(bug_yellow);
	bug_yellow = mybug;
	return 0;
	}
}
load_green = function(filename=""){
var mybug = load_bug(1,filename);
if instance_exists(mybug)
	{
	instance_destroy(bug_green);
	bug_green = mybug;
	return 0;
	}
}
load_blue = function(filename=""){
var mybug = load_bug(2,filename);
if instance_exists(mybug)
	{
	instance_destroy(bug_blue);
	bug_blue = mybug;
	return 0;
	}
}
load_red = function(filename=""){
var mybug = load_bug(3,filename);
if instance_exists(mybug)
	{
	instance_destroy(bug_red);
	bug_red = mybug;
	return 0;
	}
}
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
