// Feather disable GM2016
draw_set_alpha(1);
scr_draw_vars(global.fnt_bold,fa_left,c_white);
draw_set_valign(fa_middle);
if loading_prompt
	{
	draw_rectangle_color(0,0,640,480,0,0,0,0,false);
	draw_set_halign(fa_center);
	draw_text(320,240,"NOW LOADING\n(MAY LAG A BIT)");
	return;
	}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var mb = mouse_check_button_pressed(mb_left);
var bx = 64;
var by = 416;

if use_classic_gui 
	{
	// Constant items that are at the same place no matter which menu is present
	var zoom_x = 534;
	var zoom_y = by+1;
	if point_in_rectangle(mx,my,zoom_x,zoom_y,zoom_x+22,zoom_y+33)
		{
		if mb mouse_create(obj_mouse_zoom);
		}
	
	var tweezer_x = 556;
	var tweezer_y = by+1;
	if point_in_rectangle(mx,my,tweezer_x,tweezer_y,tweezer_x+20,tweezer_y+33)
		{
		if mb mouse_create(obj_mouse_grab);
		}
	
	switch menu
		{
		// paint
		case 0:
			{
			draw_sprite(gui.paint,0,0,by); 
		
			// top row
			var mmy = (my >= by && my <= by+15) ? true : false;
			for (var i=1;i<=25;i++)
				{
				var xx = bx+(16*i);
				if global.use_external_assets
				draw_sprite(global.spr_note2[0][i],0,xx,by)
				else draw_sprite(spr_note,i,xx,by);
				if (mx >= xx && mx <= xx+16 && mmy) && mb
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
			mmy = (my >= by+16 && my <= by+32) ? true : false;
			for (var i=1;i<=14;i++)
				{
				if i == 9 then i++;
				var xx = bx+(16*i);
				if global.use_external_assets
				draw_sprite(global.spr_note2[i][0],0,xx,by+16)
				else draw_sprite(spr_note_ctrl,i,xx,by+16);
				if (mx >= xx && mx <= xx+16 && mmy) && mb
					{
					if !instance_exists(obj_mouse_ctrl)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_ctrl); 
						}
					m.note = i;
					}
				}
			break;
			}
		
		// stamps
		case 1: 
			{
			draw_sprite(gui.stamp,0,0,by);
	
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
					m.copy_mode = true;
					m.move_mode = false;
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
					m.copy_mode = false;
					m.move_mode = true;
					}
				}
	
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
						var f = get_open_filename("*.STP","");
						if f != "" then m.load_stamp(f);
						}
					}
				}
	
			//draw_text(bx,by+16,"STAMP TBA"); 
			break;
			}
	
		// *** EXPLORE ***
		case 2: /*draw_sprite(gui.explore,0,0,by);*/ draw_text(bx,by+16,"FIELD/EXPLORE TBA"); break;
		
		// *** BUGZ ***
		case 3: 
			{
			draw_sprite(gui.bugz,0,0,by);
			var bug = [bug_yellow,bug_green,bug_blue,bug_red];
		
			// CHOOSE!
			var choose_x = 66;
			var choose_y = by+1;
			if point_in_rectangle(mx,my,choose_x,choose_y,choose_x+90,choose_y+34)
				{
				if mb menu_bugz();
				}
			
			// STOP!
			var stop_x = 174;
			var stop_y = by+1;
			if point_in_rectangle(mx,my,stop_x,stop_y,stop_x+72,stop_y+34)
				{
				if mb for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = true;
				}
			
			// Bug Buttons
			var bugpic_x = 246;
			var bugpic_y = by+1;
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			for (var i=0;i<4;i++)
				{
				var paused = false;
				if instance_exists(bug[i])
					{
					// Background image border changes if paused/unpaused
					var bo = bugpic_x+(50*i);
					draw_sprite(global.spr_ui_bug[i][bug[i].paused],0,bo,bugpic_y);
				
					// draw bug sprite
					draw_sprite_ext(bug[i].spr_up[1,round(bug[i].spr_subimg)],0,bo+30,by+19,1,1,bug[i].direction-90,c_white,1)
				
					// Click to pause/unpause
					if point_in_rectangle(mx,my,bo,bugpic_y,bo+50,bugpic_y+34)
						{
						if mb if instance_exists(bug[i]) bug[i].paused = !bug[i].paused;
						}
					}
				}
			
			// GO!
			var go_x = 446;
			var go_y = by+1;
			if point_in_rectangle(mx,my,go_x,go_y,go_x+72,go_y+34)
				{
				if mb for (var i=0;i<4;i++) if instance_exists(bug[i]) bug[i].paused = false;
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
					if mb rally_bugz_to_flags();
					}
				}
			else 
				{
				draw_set_alpha(0.5);
				draw_rectangle_color(restart_x,restart_y,restart_x+75,restart_y+26,c_black,c_black,c_black,c_black,false);
				draw_set_alpha(1);
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
						mouse_create(obj_mouse_flag);
						m.flag_id = i;
						}
					}
				}
			
			// Volume down
			var vol_down_x = 84;
			var vol_down_y = by+38;
			if point_in_rectangle(mx,my,vol_down_x,vol_down_y,vol_down_x+26,vol_down_y+26)
				{
				if mb for (var i=0;i<4;i++)
					{
					if instance_exists(bug[i])
						{
						bug[i].volume -= 16;
						if bug[i].volume < 0 bug[i].volume = 0;
						}
					}
				}
			
			// Volume slider
			var volume_x = 122;
			var volume_y = by+38;
			for (var i=0;i<4;i++)
				{
				if instance_exists(bug[i]) 
					{
					var current_percent = clamp(75 * (bug[i].volume/128),0,75);
				
					if point_in_rectangle(mx,my,volume_x,volume_y+(6*i),volume_x+75,volume_y+(6*i)+6)
						{
						if mouse_check_button(mb_left)
							{
							current_percent = clamp(75 * ((mx-volume_x)/75),0,76);
							}
						if mouse_check_button_released(mb_left)
							{
							var mouse_percent = clamp(128 * ((mx-volume_x)/75),0,128);
							bug[i].volume = mouse_percent;
							trace("bug {0} volume set to {1}",i,mouse_percent);
							}
						}
					
					draw_sprite(global.spr_ui_slider[i],0,volume_x+current_percent,volume_y+3+(6*i));
					}
				}
			
			// Volume up
			var vol_up_x = 208;
			var vol_up_y = by+38;
			if point_in_rectangle(mx,my,vol_up_x,vol_up_y,vol_up_x+26,vol_up_y+26)
				{
				if mb for (var i=0;i<4;i++)
					{
					if instance_exists(bug[i])
						{
						bug[i].volume += 16;
						if bug[i].volume > 128 bug[i].volume = 128;
						}
					}
				}
			
			// Speed/Gear down
			var spd_down_x = 242;
			var spd_down_y = by+38;
			if point_in_rectangle(mx,my,spd_down_x,spd_down_y,spd_down_x+26,spd_down_y+26)
				{
				if mb for (var i=0;i<4;i++)
					{
					if instance_exists(bug[i])
						{
						bug[i].gear -= 1;
						if bug[i].gear < 0 bug[i].gear = 0;
						bug[i].calculate_timer();
						}
					}
				}
			
			// Speed/gear slider
			var spd_x = 280;
			var spd_y = by+38;
			for (var i=0;i<4;i++)
				{
				if instance_exists(bug[i]) 
					{
					var current_percent = clamp(75 * (bug[i].gear/8),0,75);
				
					if point_in_rectangle(mx,my,spd_x,spd_y+(6*i),spd_x+75,spd_y+(6*i)+6)
						{
						if mouse_check_button(mb_left)
							{
							current_percent = clamp(75 * ((mx-spd_x)/75),0,75);
							}
						if mouse_check_button_released(mb_left)
							{
							var mouse_percent = clamp(round(8 * ((mx-spd_x)/75)),0,8);
							bug[i].gear = mouse_percent;
							trace("bug {0} gear set to {1}",i,mouse_percent);
							}
						}
					
					draw_sprite(global.spr_ui_slider[i],0,spd_x+current_percent,spd_y+3+(6*i));
					}
				}
			
			// Gear/speed up
			var spd_up_x = 366;
			var spd_up_y = by+38;
			if point_in_rectangle(mx,my,spd_up_x,spd_up_y,spd_up_x+26,spd_up_y+26)
				{
				if mb for (var i=0;i<4;i++)
					{
					if instance_exists(bug[i])
						{
						bug[i].gear += 1;
						if bug[i].gear > 8 bug[i].gear = 8;
						bug[i].calculate_timer();
						}
					}
				}
			break;
			}
		
		// config/file
		case 4: 
		draw_sprite(gui.file,0,0,by); 
		//draw_text(bx,by+16,"CONFIG/FILE TBA"); 
	
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
		break;
		}
	}
else
	{
	draw_rectangle_color(0,416,640,480,0,0,0,0,false);
	switch menu
		{
		// paint
		case 0:
			{
			var xx = 0;
			// top row
			for (var i=1;i<=25;i++)
				{
				xx = bx+(16*i);
				draw_sprite(spr_note,i-1,xx,by);
				if point_in_rectangle(mx,my,xx,by,xx+16,by+15) && mb
					{
					if !instance_exists(obj_mouse_parent)
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
				if i == 9 then i++;
				xx = bx+(16*i);
				draw_sprite(spr_note_ctrl,i-1,xx,by+16);
				if point_in_rectangle(mx,my,xx,by+16,xx+16,by+32) && mb
					{
					if !instance_exists(obj_mouse_parent)
						{
						instance_destroy(m);
						mouse_create(obj_mouse_ctrl); 
						}
					m.note = i;
					}
				}
			break;
			}
		
		// stamps
		case 1: draw_text(bx,by+16,"STAMP TBA"); break;
	
		// field/explore
		case 2: draw_text(bx,by+16,"FIELD/EXPLORE TBA"); break;
		
		// bugz
		case 3: 
			{
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			var bbx = bx;
			var mmx = (mx >= bbx && mx <= bbx+64) ? true : false;
			var mmy = (my >= by && my <= by+32) ? true : false;
			var bug = [bug_yellow,bug_green,bug_blue,bug_red];
			for (var i=0;i<4;i++)
				{
				// draw rectangles
				var c = c_white;
				switch i
					{
					case 0: c = c_yellow; break;
					case 1: c = c_lime; break;
					case 2: c = c_aqua; break;
					case 3: c = c_red; break;
					}
				draw_rectangle_color(bbx,by,bbx+62,by+32,c,c,c,c,true);
			
				// draw bug sprite
				if instance_exists(bug[i])
				draw_sprite_ext(bug[i].spr_up[2,round(bug[i].spr_subimg)],0,bbx+32,by+16,1,1,bug[i].direction-90,c_white,1)
				else draw_text(bbx+32,by+16,"N/A");
			
				// pause state
				mmx = (mx >= bbx && mx <= bbx+64) ? true : false;
				if (mmx && mmy) && mb
					{
					if instance_exists(bug[i]) then bug[i].paused = !bug[i].paused;
					}
				
				bbx += 64;
				}
			
			draw_rectangle_color(bbx,by,bbx+63,by+32,c_white,c_white,c_white,c_white,true);
			draw_text(bbx+32,by+16,"STOP!");
			mmx = (mx >= bbx && mx <= bbx+64) ? true : false;
			if (mmx && mmy) && mb
				{
				for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = true;
				}
			bbx += 64;
		
			draw_rectangle_color(bbx,by,bbx+63,by+32,c_white,c_white,c_white,c_white,true);
			draw_text(bbx+32,by+16,"GO!");
			mmx = (mx >= bbx && mx <= bbx+64) ? true : false;
			if (mmx && mmy) && mb
				{
				for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = false;
				}
			bbx += 64;
			draw_set_halign(fa_left);
			//draw_text(bx,by,"BUGZ");
			break;
			}
		
		// config/file
		case 4: draw_text(bx,by+16,"CONFIG/FILE TBA"); break;
		}
	}