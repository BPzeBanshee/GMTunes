///@desc Keyboard Functions
// Trying to be authentic to SimTunes here where possible
// Failing that we comment out until features are implemented

//if keyboard_check_pressed(vk_anykey)
//trace("key: {0} / {1}, lastkey: {2} / {3}",keyboard_key,hex(keyboard_key),keyboard_lastkey,hex(keyboard_lastkey));

// Exit Game
if (keyboard_check(vk_control) && keyboard_check(ord("Q")))
or (keyboard_check(vk_alt) && keyboard_check(vk_f4))
	{
	game_end();
	return;
	}

// ==== Things that use a single key ====

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

// Tools
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
		trace("Mouse object deleted somehow, reverting to m_prev ({0})",object_get_name(m_prev.object_index));
		mouse_create(m_prev.object_index);
		}
	}
// TODO: expose mouse playfield position to allow color picking
/*if keyboard_check(ord(","))
	{
	if instance_exists(obj_mouse_colour)
		{
		if mouse_check_button_pressed(mb_left)
		m.note = global.note_grid[m.xx,m.yy];
		}
	}*/
	
// Menu category selection
for (var i=0;i<5;i++)
	{
	if keyboard_check_pressed(ord(string(i+1))) 
		{
		menu = i;
		audio_play_sound(global.snd_ui.switcher,0,false); // replace with actual menu sound
		}
	}
if keyboard_check_pressed(vk_capslock) show_menu = !show_menu;
	
// Load Game
if keyboard_check_pressed(vk_f3) load_tun();

// Save Game
if keyboard_check_pressed(vk_f2) save_tun();
	
// Unique to GMTunes: set custom speed for all Bugz
if keyboard_check_pressed(vk_enter)
	{
	dialog = get_integer_async("Bugz Gear Speed",-1);
	}
	
// ==== Things that use the CTRL key ====
if keyboard_check(vk_control)
	{
	// Undo
	if keyboard_check_pressed(ord("Z")) undo();
	
	// "Restart" / Rally bugz to flags
	if keyboard_check_pressed(ord("R")) rally_bugz_to_flags();
	
	// Watch mode
	if keyboard_check_pressed(ord("W")) start_watch_mode();
	
	// Cursor
	if keyboard_check_pressed(ord("C"))
		{
		if !instance_exists(obj_mouse_stamp) mouse_create(obj_mouse_stamp);
		m.copy_mode = true;
		}
	if keyboard_check_pressed(ord("X"))
		{
		if !instance_exists(obj_mouse_stamp) mouse_create(obj_mouse_stamp);
		m.copy_mode = false;
		}
	
	// Zap (Erase) Screen
	// F4 is soft (playfield only), N is hard (background & bugz)
	if keyboard_check_pressed(ord("N")) reset_playfield(true);
	if keyboard_check_pressed(vk_f4) reset_playfield();
	
	// Bugz speed up/down
	if keyboard_check_pressed(vk_oem_equals)
		{
		with obj_bug
			{
			gear += 1;
			if gear > 8 gear = 8;
			calculate_timer();
			}
		}
	if keyboard_check_pressed(vk_oem_minus)
		{
		with obj_bug
			{
			gear -= 1;
			if gear < 1 gear = 1;
			calculate_timer();
			}
		}
	
	// Bugz selection menu
	if keyboard_check_pressed(ord("B")) menu_bugz();
	
	// Align to grid (TODO)
	// if keyboard_check_pressed(ord("G")) align_to_grid = !align_to_grid;
	
	// Stamp transparency
	if keyboard_check_pressed(ord("T")) clear_back = !clear_back;
	
	// Save Game
	if keyboard_check_pressed(ord("S")) save_tun();
	
	// Load Game
	if keyboard_check_pressed(ord("L")) load_tun();
	}
