// Button events
if instance_exists(obj_trans) exit;

// Camera movement
update_camera();

// Keyboard events
event_user(1);

// UI Button events
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var mb = mouse_check_button_pressed(mb_left);
var bx = 64;
var by = 416;
if show_menu 
	{
	if menu_y < 28 menu_y += 4;
	}
else if menu_y > 0 menu_y -= 4;

// Watch mode
if watch_mode
	{
	if (keyboard_check_pressed_sane(vk_anykey)
	or mouse_check_button_pressed(mb_any))
	&& alarm[2] < (game_get_speed(gamespeed_fps)*6)-1 // button press check immediately on setting alarm
		{
		watch_mode = false;
		watch_count = 0;
		watch_target = noone;
		mouse_create(m_prev);
		alarm[2] = -1;
		}
	exit;
	}

// Constant items that are at the same place no matter which menu is present
var zoom_x = 534;
var zoom_y = by+1;
if point_in_rectangle(mx,my,zoom_x,zoom_y,zoom_x+22,zoom_y+33) && mb
	{
	button_click();
	mouse_create(obj_mouse_zoom);
	}
	
var tweezer_x = 556;
var tweezer_y = by+1;
if point_in_rectangle(mx,my,tweezer_x,tweezer_y,tweezer_x+20,tweezer_y+33) && mb
	{
	button_click();
	mouse_create(obj_mouse_grab);
	}
	
var undo_x = 579;
var undo_y = by+36;
if point_in_rectangle(mx,my,undo_x,undo_y,undo_x+28,undo_y+28)
	{
	if mb {undo(); flash(101);}
	}
	
var reset_x = 610;
var reset_y = by+36;
if point_in_rectangle(mx,my,reset_x,reset_y,reset_x+28,reset_y+28)
	{
	if mb {reset_playfield(false); flash(102);}
	}

if use_classic_gui
	{
	switch menu
		{
		// PAINT
		case 0: 
			{
			// musical selector (55,14)
			var music_x = bx-9;
			var music_y = by+14;
			if point_in_rectangle(mx,my,music_x,music_y,music_x+5,music_y+9)
				{
				if mb
					{
					button_click();
					play_index++; if play_index > 4 play_index = 0;
					}
				}
				
			// top row
			var note_x = bx;
			var note_y = by;
			for (var i=1;i<=25;i++)
				{
				var xx = note_x + (16*(i-1));
				if point_in_rectangle(mx,my,xx,note_y,xx+16,note_y+16) && mb
					{
					if !instance_exists(obj_mouse_colour)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_colour); 
						}
					m.note = i;
					
					if global.use_external_assets
						{
						var snd = global.snd_ui.beep[i-1];
						switch play_index
							{
							case 1: if instance_exists(bug_yellow) snd = bug_yellow.snd_struct.snd[i-1]; break;
							case 2: if instance_exists(bug_green) snd = bug_green.snd_struct.snd[i-1]; break;
							case 3: if instance_exists(bug_blue) snd = bug_blue.snd_struct.snd[i-1]; break;
							case 4: if instance_exists(bug_red) snd = bug_red.snd_struct.snd[i-1]; break;
							default: break;
							}
						if audio_exists(play_handle) audio_stop_sound(play_handle);
						play_handle = audio_play_sound(snd,0,false);
						}
					}
				}
				
			// Bottom row
			for (var i=1;i<=14;i++)
				{
				if i == 9 then i++; // skip teleport destination note
				var xx = note_x + (16*(i-1));
				if point_in_rectangle(mx,my,xx,by+16,xx+16,by+32) && mb
					{
					button_click();
					if !instance_exists(obj_mouse_ctrl)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_ctrl); 
						}
					m.note = i;
					}
				}
				
			// Rainbow option
			var rainbow_x = bx+400; //463
			var rainbow_y = by;
			if point_in_rectangle(mx,my,rainbow_x,rainbow_y,rainbow_x+16,rainbow_y+16) && mb
				{
				button_click();
				if !instance_exists(obj_mouse_rainbow)
					{
					instance_destroy(m);
					mouse_create(obj_mouse_rainbow); 
					}
				}
			break;
			}
		// STAMP
		case 1: 
			{
			var copy_x = 66;
			var copy_y = by+1;
			if point_in_rectangle(mx,my,copy_x,copy_y,copy_x+90,copy_y+34)
				{
				if mb
					{
					button_click();
					if !instance_exists(obj_mouse_stamp)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_stamp); 
						}
					m.move_mode = false;
					m.clear_back = clear_back;
					m.unload_stamp();
					flash(1);
					}
				}
		
			var move_x = 156;
			var move_y = by+1;
			if point_in_rectangle(mx,my,move_x,move_y,move_x+90,copy_y+34)
				{
				if mb
					{
					button_click();
					if !instance_exists(obj_mouse_stamp)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_stamp); 
						}
					m.move_mode = true;
					m.clear_back = clear_back;
					m.unload_stamp();
					flash(2);
					}
				}
				
			if show_menu exit;
	
			var load_stamp_x = 85;
			var load_stamp_y = by+38;
			if point_in_rectangle(mx,my,load_stamp_x,load_stamp_y,load_stamp_x+89,load_stamp_y+26)
				{
				if mb
					{
					button_click();
					if !instance_exists(obj_mouse_stamp)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_stamp); 
						}
					var f = get_open_filename("*.STP","");
					if f != "" m.load_stamp_from_file(f);
					flash(3);
					}
				}
				
			var save_stamp_x = 176;
			var save_stamp_y = by+38;
			if point_in_rectangle(mx,my,save_stamp_x,save_stamp_y,save_stamp_x+89,save_stamp_y+26)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp)
					if m.loaded
						{
						button_click();
						var f = get_save_filename("*.STP","");
						if f != "" m.save_stamp_to_file(f);
						flash(4);
						}
					}
				}
				
			var rotate_right_x = 278;
			var rotate_right_y = by+39;
			if point_in_rectangle(mx,my,rotate_right_x,rotate_right_y,rotate_right_x+29,rotate_right_y+25)
				{
				if mb
					{
					button_click();
					if instance_exists(obj_mouse_stamp) if m.loaded m.rotate_right();
					}
				}
				
			var rotate_left_x = 309;
			var rotate_left_y = by+39;
			if point_in_rectangle(mx,my,rotate_left_x,rotate_left_y,rotate_left_x+29,rotate_left_y+25)
				{
				if mb
					{
					button_click();
					if instance_exists(obj_mouse_stamp) if m.loaded m.rotate_left();
					}
				}
				
			var flip_h_x = 346;
			var flip_h_y = by+39;
			if point_in_rectangle(mx,my,flip_h_x,flip_h_y,flip_h_x+29,flip_h_y+25)
				{
				if mb
					{
					button_click();
					if instance_exists(obj_mouse_stamp) if m.loaded m.flip_horizontal();
					}
				}
				
			var flip_v_x = 377;
			var flip_v_y = by+39;
			if point_in_rectangle(mx,my,flip_v_x,flip_v_y,flip_v_x+29,flip_v_y+25)
				{
				if mb
					{
					button_click();
					if instance_exists(obj_mouse_stamp) if m.loaded m.flip_vertical();
					}
				}
				
			var scale_up_x = 414;
			var scale_up_y = by+39;
			if point_in_rectangle(mx,my,scale_up_x,scale_up_y,scale_up_x+29,scale_up_y+25)
				{
				if mb
					{
					button_click();
					if instance_exists(obj_mouse_stamp) if m.loaded m.scale_up();
					}
				}
				
			var scale_down_x = 445;
			var scale_down_y = by+39;
			if point_in_rectangle(mx,my,scale_down_x,scale_down_y,scale_down_x+29,scale_down_y+25)
				{
				if mb
					{
					button_click();
					if instance_exists(obj_mouse_stamp) if m.loaded m.scale_down();
					}
				}
				
			var toggle_clear_x = 482;
			var toggle_clear_y = by+39;
			if point_in_rectangle(mx,my,toggle_clear_x,toggle_clear_y,toggle_clear_x+29,toggle_clear_y+25)
				{
				if mb
					{
					button_click();
					if instance_exists(obj_mouse_stamp) 
						{
						clear_back = !clear_back;
						m.toggle_clear();
						}
					}
				}
			break;
			}
		// BUGZ
		case 3:
			{
			// CHOOSE!
			var choose_x = 66;
			var choose_y = by+1;
			if point_in_rectangle(mx,my,choose_x,choose_y,choose_x+90,choose_y+34)
				{
				if mb 
					{
					button_click();
					menu_bugz(); 
					flash(1);
					}
				}
				
			var bug = [bug_yellow,bug_green,bug_blue,bug_red];
			
			// STOP!
			var stop_x = 174;
			var stop_y = by+1;
			if point_in_rectangle(mx,my,stop_x,stop_y,stop_x+72,stop_y+34)
				{
				if mb 
					{
					button_click();
					for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = true;
					flash(2);
					}
				}
				
			// Bug Buttons
			var bugpic_x = 246;
			var bugpic_y = by+1;
			for (var i=0;i<4;i++)
				{
				if instance_exists(bug[i])
					{
					// Click to pause/unpause
					var bo = bugpic_x+(50*i);
					if point_in_rectangle(mx,my,bo,bugpic_y,bo+50,bugpic_y+34) && mb
						{
						button_click();
						if instance_exists(bug[i]) bug[i].paused = !bug[i].paused;
						}
					}
				}
				
			// GO!
			var go_x = 446;
			var go_y = by+1;
			if point_in_rectangle(mx,my,go_x,go_y,go_x+72,go_y+34)
				{
				if mb 
					{
					button_click();
					for (var i=0;i<4;i++) if instance_exists(bug[i]) bug[i].paused = false;
					flash(3);
					}
				}
				
			if show_menu break;
				
			// Volume down
			var vol_down_x = 84;
			var vol_down_y = by+38;
			if point_in_rectangle(mx,my,vol_down_x,vol_down_y,vol_down_x+26,vol_down_y+26)
				{
				if mb 
					{
					button_click();
					for (var i=0;i<4;i++)
						{
						if instance_exists(bug[i])
							{
							bug[i].volume -= 16;
							if bug[i].volume < 0 bug[i].volume = 0;
							}
						}
					flash(4);
					}
				}
				
			// Volume up
			var vol_up_x = 208;
			var vol_up_y = by+38;
			if point_in_rectangle(mx,my,vol_up_x,vol_up_y,vol_up_x+26,vol_up_y+26)
				{
				if mb 
					{
					button_click();
					for (var i=0;i<4;i++)
						{
						if instance_exists(bug[i])
							{
							bug[i].volume += 16;
							if bug[i].volume > 128 bug[i].volume = 128;
							}
						}
					flash(5);
					}
				}
			
			// Speed/Gear down
			var spd_down_x = 242;
			var spd_down_y = by+38;
			if point_in_rectangle(mx,my,spd_down_x,spd_down_y,spd_down_x+26,spd_down_y+26)
				{
				if mb 
					{
					button_click();
					for (var i=0;i<4;i++)
						{
						if instance_exists(bug[i])
							{
							bug[i].gear -= 1;
							if bug[i].gear < 0 bug[i].gear = 0;
							bug[i].calculate_timer();
							}
						}
					flash(6);
					}
				}
				
			// Gear/speed up
			var spd_up_x = 366;
			var spd_up_y = by+38;
			if point_in_rectangle(mx,my,spd_up_x,spd_up_y,spd_up_x+26,spd_up_y+26)
				{
				if mb 
					{
					button_click();
					for (var i=0;i<4;i++)
						{
						if instance_exists(bug[i])
							{
							bug[i].gear += 1;
							if bug[i].gear > 8 bug[i].gear = 8;
							bug[i].calculate_timer();
							}
						}
					flash(7);
					}
				}
				
			// RESTART
			var restart_x = 400;
			var restart_y = by+38;
			var flags = global.flag_list[0,2] + global.flag_list[1,2] 
			+ global.flag_list[2,2] + global.flag_list[3,2];
			if flags > -4
				{
				if point_in_rectangle(mx,my,restart_x,restart_y,restart_x+75,restart_y+26)
					{
					if mb 
						{
						button_click();
						rally_bugz_to_flags();
						flash(8);
						}
					}
				}
				
			// Flags
			var flag_x = 477;
			var flag_y = by+38;
			for (var i=0;i<4;i++)
				{
				if point_in_rectangle(mx,my,flag_x+(18*i),flag_y,flag_x+(18*i)+18,flag_y+26)
					{
					if mb 
						{
						button_click();
						mouse_create(obj_mouse_flag);
						m.flag_id = i;
						}
					}
				}
			break;
			}		
		// MENU
		case 4: 
			{
			//+90,+34
			var gal_x = 66;
			var gal_y = by+1;
			if point_in_rectangle(mx,my,gal_x,gal_y,gal_x+90,gal_y+34)
				{
				if mb//load_tun();
					{
					button_click();
					callmethod = load_gal;
					loading_prompt = true;
					alarm[0] = 2;
					flash(1);
					}
				}
				
			var watch_x = 155;
			var watch_y = by+1;
			if point_in_rectangle(mx,my,watch_x,watch_y,watch_x+90,watch_y+34)
				{
				if mb 
					{
					button_click();
					flash(2);
					start_watch_mode();
					}
				}
			
			//+90,+34
			var load_x = 247;
			var load_y = by+1;
			if point_in_rectangle(mx,my,load_x,load_y,load_x+90,load_y+34)
				{
				if mb//load_tun();
					{
					button_click();
					flash(3);
					callmethod = load_tun;
					loading_prompt = true;
					alarm[0] = 2;
					}
				}
		
			var save_x = 338;
			var save_y = by+1;
			if point_in_rectangle(mx,my,save_x,save_y,save_x+90,save_y+34)
				{
				if mb
					{
					button_click();
					flash(4);
					callmethod = save_tun;
					loading_prompt = true;
					alarm[0] = 2;
					}
				}
		
			var quit_x = 429;
			var quit_y = by+1;
			if point_in_rectangle(mx,my,quit_x,quit_y,quit_x+90,quit_y+34)
				{
				if mb 
					{
					button_click();
					flash(5);
					back_to_main();
					}
				}
				
			if show_menu break;
				
			var backdrop_x = 89;
			var backdrop_y = by+38;
			if point_in_rectangle(mx,my,backdrop_x,backdrop_y,backdrop_x+88,backdrop_y+26)
				{
				if mb //load_bkg();
					{
					button_click();
					callmethod = load_bkg;
					loading_prompt = true;
					alarm[0] = 2;
					flash(6);
					}
				}
			break;
			}
		}
		
	// Menu controls
	if show_menu
		{
		var mmx = bx+7;
		var mmy = 480 - round(menu_y);
		for (var i=0;i<5;i++)
			{
			if point_in_rectangle(mx,my,mmx+(95*i),mmy,mmx+95+(95*i),mmy+24) && mb
				{
				menu = i;
				audio_play_sound(global.snd_ui.switcher,0,false);
				}
			}
		}
	}
else
	{
	switch menu
		{
		case 0: // PAINT
			{
			var xx = 0;
			// top row
			for (var i=1;i<=25;i++)
				{
				xx = bx+(16*i);
				if point_in_rectangle(mx,my,xx,by,xx+16,by+15) && mb
					{
					if !instance_exists(obj_mouse_colour)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_colour); 
						}
					m.note = i;
					}
				}
				
			// bottom row
			for (var i=1;i<=14;i++)
				{
				xx = bx+(16*i);
				if i == 9 then i++;
				if point_in_rectangle(mx,my,xx,by+16,xx+16,by+32) && mb
					{
					if !instance_exists(obj_mouse_ctrl)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_ctrl); 
						}
					m.note = i;
					}
				}
			
			// Rainbow option
			var rainbow_x = bx+400; //463
			var rainbow_y = by;
			if point_in_rectangle(mx,my,rainbow_x,rainbow_y,rainbow_x+16,rainbow_y+16) && mb
				{
				if !instance_exists(obj_mouse_rainbow)
					{
					instance_destroy(m);
					mouse_create(obj_mouse_rainbow); 
					}
				}
			break;
			}
		case 1: // STAMP
			{
			var copy_x = 66;
			var copy_y = by+1;
			if point_in_rectangle(mx,my,copy_x,copy_y,copy_x+90,copy_y+34)
				{
				if mb
					{
					if !instance_exists(obj_mouse_stamp)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_stamp); 
						}
					m.move_mode = false;
					m.clear_back = clear_back;
					m.unload_stamp();
					flash(1);
					}
				}
		
			var move_x = 156;
			var move_y = by+1;
			if point_in_rectangle(mx,my,move_x,move_y,move_x+90,copy_y+34)
				{
				if mb
					{
					if !instance_exists(obj_mouse_stamp)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_stamp); 
						}
					m.move_mode = true;
					m.clear_back = clear_back;
					m.unload_stamp();
					flash(2);
					}
				}
				
			if show_menu break;
	
			var load_stamp_x = 85;
			var load_stamp_y = by+38;
			if point_in_rectangle(mx,my,load_stamp_x,load_stamp_y,load_stamp_x+89,load_stamp_y+26)
				{
				if mb
					{
					if !instance_exists(obj_mouse_stamp)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_stamp); 
						}
					var f = get_open_filename("*.STP","");
					if f != "" then m.load_stamp_from_file(f);
					flash(3);
					}
				}
				
			var save_stamp_x = 176;
			var save_stamp_y = by+38;
			if point_in_rectangle(mx,my,save_stamp_x,save_stamp_y,save_stamp_x+89,save_stamp_y+26)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp)
					if m.loaded
						{
						var f = get_save_filename("*.STP","");
						if f != "" then m.save_stamp_to_file(f);
						}
					flash(4);
					}
				}
				
			var rotate_right_x = 278;
			var rotate_right_y = by+39;
			if point_in_rectangle(mx,my,rotate_right_x,rotate_right_y,rotate_right_x+29,rotate_right_y+25)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp) m.rotate_right();
					}
				}
				
			var rotate_left_x = 309;
			var rotate_left_y = by+39;
			if point_in_rectangle(mx,my,rotate_left_x,rotate_left_y,rotate_left_x+29,rotate_left_y+25)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp) m.rotate_left();
					}
				}
				
			var flip_h_x = 346;
			var flip_h_y = by+39;
			if point_in_rectangle(mx,my,flip_h_x,flip_h_y,flip_h_x+29,flip_h_y+25)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp) m.flip_horizontal();
					}
				}
				
			var flip_v_x = 377;
			var flip_v_y = by+39;
			if point_in_rectangle(mx,my,flip_v_x,flip_v_y,flip_v_x+29,flip_v_y+25)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp) m.flip_vertical();
					}
				}
				
			var scale_up_x = 414;
			var scale_up_y = by+39;
			if point_in_rectangle(mx,my,scale_up_x,scale_up_y,scale_up_x+29,scale_up_y+25)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp) m.scale_up();
					}
				}
				
			var scale_down_x = 445;
			var scale_down_y = by+39;
			if point_in_rectangle(mx,my,scale_down_x,scale_down_y,scale_down_x+29,scale_down_y+25)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp) m.scale_down();
					}
				}
				
			var toggle_clear_x = 482;
			var toggle_clear_y = by+39;
			if point_in_rectangle(mx,my,toggle_clear_x,toggle_clear_y,toggle_clear_x+29,toggle_clear_y+25)
				{
				if mb
					{
					if instance_exists(obj_mouse_stamp) 
						{
						clear_back = !clear_back;
						m.toggle_clear();
						}
					}
				}
			break;
			}
		case 3: // BUGZ
			{
			//TODO: currently handled in Draw GUI, needs changing
			break;
			}
		case 4: // FILE
			{
			//+90,+34
			var gal_x = 66;
			var gal_y = by+1;
			if point_in_rectangle(mx,my,gal_x,gal_y,gal_x+90,gal_y+34)
				{
				if mb//load_tun();
					{
					callmethod = load_gal;
					loading_prompt = true;
					alarm[0] = 2;
					}
				}
				
			var watch_x = 155;
			var watch_y = by+1;
			if point_in_rectangle(mx,my,watch_x,watch_y,watch_x+90,watch_y+34)
				{
				if mb 
					{
					flash(2);
					start_watch_mode();
					}
				}
	
			//+90,+34
			var load_x = 247;
			var load_y = by+1;
			if point_in_rectangle(mx,my,load_x,load_y,load_x+90,load_y+34)
				{
				if mb//load_tun();
					{
					callmethod = load_tun;
					loading_prompt = true;
					alarm[0] = 2;
					}
				}
		
			var save_x = 338;
			var save_y = by+1;
			if point_in_rectangle(mx,my,save_x,save_y,save_x+90,save_y+34)
				{
				if mb
					{
					callmethod = save_tun;
					loading_prompt = true;
					alarm[0] = 2;
					}
				}
		
			var quit_x = 429;
			var quit_y = by+1;
			if point_in_rectangle(mx,my,quit_x,quit_y,quit_x+90,quit_y+34)
				{
				if mb back_to_main();
				}
				
			if show_menu break;
			var backdrop_x = 89;
			var backdrop_y = by+38;
			if point_in_rectangle(mx,my,backdrop_x,backdrop_y,backdrop_x+88,backdrop_y+26)
				{
				if mb //load_bkg();
					{
					callmethod = load_bkg;
					loading_prompt = true;
					alarm[0] = 2;
					}
				}
			break;
			}
		}
	
	// Menu controls
	if show_menu
		{
		var mmx = bx+7;
		var mmy = 480 - round(menu_y);
		for (var i=0;i<5;i++)
			{
			if point_in_rectangle(mx,my,mmx+(95*i),mmy,mmx+95+(95*i),mmy+24) && mb
				{
				menu = i;
				}
			}
		}
	}