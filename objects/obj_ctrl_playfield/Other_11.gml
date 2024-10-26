///@desc Keyboard Functions
// Trying to be authentic to SimTunes here where possible
// Failing that we comment out until features are implemented

// Camera movement
var xo = 0;
var yo = 0;
if keyboard_check(vk_left) or keyboard_check(ord("A")) then xo = -global.zoom*4;
if keyboard_check(vk_right) or keyboard_check(ord("D")) then xo = global.zoom*4;
if keyboard_check(vk_up) or keyboard_check(ord("W")) then yo = -global.zoom*4;
if keyboard_check(vk_down) or keyboard_check(ord("S")) then yo = global.zoom*4;
var cam = view_camera[0];
var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);

var xform = room_width - camera_get_view_width(cam);
var yform = 0;
switch global.zoom
	{
	case 2: yform = 1664 - 416; break;
	case 1: yform = 1664 - (416*2); break;
	case 0: break;
	}
// (64 * global.zoom);// (64 * (global.zoom/2));
//room_height+(256/(global.zoom+1))-ch;
camera_set_view_pos(cam,clamp(cx+xo,0,xform),clamp(cy+yo,0,yform));

// Bugz
if keyboard_check_pressed(vk_space)
	{
	paused = !paused;
	if instance_exists(obj_bug) obj_bug.paused = !obj_bug.paused;
	}
if keyboard_check_pressed(ord("U")) then if bug_yellow then bug_yellow.muted = !bug_yellow.muted;
if keyboard_check_pressed(ord("I")) then if bug_green then bug_green.muted = !bug_green.muted;
if keyboard_check_pressed(ord("O")) then if bug_blue then bug_blue.muted = !bug_blue.muted;
if keyboard_check_pressed(ord("P")) then if bug_red then bug_red.muted = !bug_red.muted;
if keyboard_check(ord("Y"))
|| keyboard_check(ord("G"))
|| keyboard_check(ord("B"))
|| keyboard_check(ord("R"))
	{
	if !instance_exists(obj_mouse_grab) then mouse_create(obj_mouse_grab);
	}
else if keyboard_check(ord("M"))
	{
	if !instance_exists(obj_mouse_zoom) then mouse_create(obj_mouse_zoom);
	}
else
	{
	if !instance_exists(m) && m_prev != noone
		{
		mouse_create(m_prev);
		}
	}
	
// File
// Zap (Erase) Screen
// TODO: just the screen or entire map?
if (keyboard_check(vk_control) && keyboard_check(vk_f4))
	{
	reset_playfield();
	}
	
// Load Game
if keyboard_check_pressed(vk_f3) or (keyboard_check(vk_control) && keyboard_check(ord("L")))
	{
	load_tun();
	}
	
// Save Game
if keyboard_check_pressed(vk_f2) or (keyboard_check(vk_control) && keyboard_check(ord("S")))
	{
	save_tun();
	}

// Exit Game
if (keyboard_check(vk_control) && keyboard_check(ord("Q")))
or (keyboard_check(vk_alt) && keyboard_check(vk_f4))
then game_end();
	
if keyboard_check_pressed(vk_tab)
	{
	menu += 1;
	if menu > 4 then menu = 0;
	}
if keyboard_check_pressed(vk_enter)
	{
	dialog = get_integer_async("Bugz Gear Speed",-1);
	/*var g = clamp(get_integer("gear num",-1),-1,8);
	with obj_bug
		{
		gear = g;
		calculate_timer();
		}*/
	}
if keyboard_check(vk_control) && keyboard_check_pressed(ord("B")) menu_bugz();

if keyboard_check_pressed(ord("1")) then place_flag(0);
if keyboard_check_pressed(ord("2")) then place_flag(1);
if keyboard_check_pressed(ord("3")) then place_flag(2);
if keyboard_check_pressed(ord("4")) then place_flag(3);
if keyboard_check_pressed(ord("5")) then rally_bugz_to_flags();