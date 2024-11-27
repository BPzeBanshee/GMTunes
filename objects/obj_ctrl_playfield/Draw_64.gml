// Feather disable GM2016
draw_set_alpha(1);
scr_draw_vars(global.fnt_bold,fa_center,c_white);
draw_set_valign(fa_middle);
if loading_prompt
	{
	draw_rectangle_color(0,0,640,480,0,0,0,0,false);
	draw_text(320,240,"NOW LOADING\n(MAY LAG A BIT)");
	return;
	}
	
if watch_mode
	{
	draw_rectangle_color(0,416,640,480,0,0,0,0,false);
	var v = draw_get_valign();
	draw_set_valign(fa_top);
	draw_text(320,416+10,playfield_name);
	draw_set_font(global.fnt_italic);
	draw_text(320,416+22,playfield_author);
	draw_set_font(global.fnt_default);
	draw_text(320,416+35,string_wordwrap_width(playfield_desc,600));
	draw_set_valign(v);
	return;
	}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var mb = mouse_check_button_pressed(mb_left);
var bx = 63;
var by = 416;
if use_classic_gui 
	{
	switch menu
		{
		// paint
		case 0:
			{
			draw_sprite(gui.paint,0,0,by); 
			draw_rectangle_color(bx,by,533,by+64,0,0,0,0,false);
			
			// musical selector (55,14)
			var music_x = bx-8;
			var music_y = by+14;
			draw_sprite(global.spr_ui.playnote[play_index],0,music_x,music_y);
		
			// top row
			var note_x = bx;
			var note_y = by;
			for (var i=1;i<=25;i++)
				{
				var xx = note_x + (16*(i-1));
				if global.use_external_assets
				draw_sprite(global.spr_note2[0][i],0,xx,note_y)
				else draw_sprite(spr_note,i-1,xx,note_y);
				}
			
			// bottom row
			for (var i=1;i<=14;i++)
				{
				if i == 9 then i++;
				var xx = note_x + (16*(i-1));
				if global.use_external_assets
				draw_sprite(global.spr_note2[i][0],0,xx,by+16)
				else draw_sprite(spr_note_ctrl,i-1,xx,by+16);
				}
				
			// Rainbow option
			var rainbow_x = bx+400; //463
			var rainbow_y = by;
			draw_sprite(spr_note_rainbow,0,rainbow_x,rainbow_y);
			break;
			}
		
		// stamps
		case 1: 
			{
			draw_sprite(gui.stamp,0,0,by);
			//draw_text(bx,by+16,"STAMP TBA"); 
			
			// Copy
			var copy_x = 65;
			var copy_y = by;
			if draw_flash == 1 draw_sprite(global.spr_ui.onclick_top,0,copy_x,copy_y);
			
			// Move
			var move_x = 155;
			var move_y = by;
			if draw_flash == 2 draw_sprite(global.spr_ui.onclick_top,0,move_x,move_y);
			
			// Load
			var load_stamp_x = 83;
			var load_stamp_y = by+38;
			if draw_flash == 3 draw_sprite(global.spr_ui.onclick_bottom,0,load_stamp_x,load_stamp_y);
			
			// Save
			var save_stamp_x = 174;
			var save_stamp_y = by+38;
			if draw_flash == 4 draw_sprite(global.spr_ui.onclick_bottom,0,save_stamp_x,save_stamp_y);
			
			// Preset Stamps
			var preset_x = 155+90+76;
			var preset_y = by+3;
			for (var i=0;i<5;i++)
				{
				var j = (pstamp_page * 5) + i;
				var g = 32 * i;
				var gg = 32 * (i+1);
				if sprite_exists(pstamp_spr[j]) draw_sprite(pstamp_spr[j],0,preset_x+g+6,preset_y+6);
				//draw_rectangle_inline(preset_x+g,preset_y,preset_x+gg,preset_y+30);
				if point_in_rectangle(mx,my,preset_x+g,preset_y,preset_x+gg,preset_y+30) && mb
					{
					if !instance_exists(obj_mouse_stamp) 
						{
						instance_destroy(m);
						mouse_create(obj_mouse_stamp);
						}
					m.note_array = pstamp[j].note_array;
					m.ctrl_array = pstamp[j].ctrl_array;
					m.loaded = true;
					m.move_mode = false;
					m.width = array_length(pstamp[j].note_array);
					m.height = array_length(pstamp[j].note_array[0]);
					m.copy_w = m.width;
					m.copy_h = m.height;
					m.copy_x = m.width/2;
					m.copy_y = m.height/2;
					m.update_surf();
					}
				}
				
			var preset_up_x = 494;
			var preset_up_y = by+3;
			if draw_flash == 5 draw_sprite(global.spr_ui.stamp_up,0,preset_up_x,preset_up_y);
			//draw_rectangle_inline(		preset_up_x,preset_up_y,preset_up_x+12,preset_up_y+6);
			if point_in_rectangle(mx,my,preset_up_x,preset_up_y,preset_up_x+12,preset_up_y+6) && mb
				{
				pstamp_page--;
				if pstamp_page < 0 pstamp_page = 19;
				flash(5);
				}
				
			draw_set_font(fnt_system);
			draw_set_color(c_black);
			draw_text(preset_up_x+6,preset_up_y+16,string(pstamp_page+1));
			draw_set_color(c_white);
			
			var preset_down_x = preset_up_x;
			var preset_down_y = preset_up_y+24;
			if draw_flash == 6 draw_sprite(global.spr_ui.stamp_down,0,preset_down_x,preset_down_y);
			//draw_rectangle_inline(		preset_down_x,preset_down_y,preset_down_x+12,preset_down_y+6);
			if point_in_rectangle(mx,my,preset_down_x,preset_down_y,preset_down_x+12,preset_down_y+6) && mb
				{
				pstamp_page++;
				if pstamp_page > 19 pstamp_page = 0;
				flash(6);
				}
			
			// Greyed area
			var not_ready_x = 176;
			var not_ready_y = by+38;
			var e = instance_exists(obj_mouse_stamp);
			if !e or (e && !m.loaded)
				{
				draw_set_alpha(0.5);
				draw_set_color(c_black);
				draw_rectangle(not_ready_x,not_ready_y,not_ready_x+298,not_ready_y+26,false);
				draw_set_alpha(1);
				}
			else
				{
				var scale_up_x = 414;
				var scale_up_y = by+39;
				if m.size == 5
					{
					draw_set_alpha(0.5);
					draw_set_color(c_black);
					draw_rectangle(scale_up_x,scale_up_y,scale_up_x+29,scale_up_y+25,false);
					draw_set_alpha(1);
					}
				
				var toggle_clear_x = 482;
				var toggle_clear_y = by+39;
				draw_sprite(global.spr_ui.stamp_clearback[!clear_back],0,toggle_clear_x,toggle_clear_y);
				}
			break;
			}
	
		// *** EXPLORE ***
		case 2: 
			{
			draw_rectangle_color(0,416,640,480,0,0,0,0,false);
			/*draw_sprite(gui.explore,0,0,by);*/ 
			draw_set_halign(fa_left);
			draw_text(bx,by+16,"FIELD/EXPLORE TBA"); 
			break;
			}
		
		// *** BUGZ ***
		case 3: 
			{
			draw_sprite(gui.bugz,0,0,by);
			
			// CHOOSE!
			var choose_x = 66;
			var choose_y = by+1;
			if draw_flash == 1 draw_sprite(global.spr_ui.onclick_top,0,choose_x,choose_y);
			
			// STOP!
			var stop_x = 174;
			var stop_y = by+1;
			if draw_flash == 2 draw_sprite(global.spr_ui.onclick_stopgo,0,stop_x,stop_y);
			
			// Bug Buttons
			var bugpic_x = 246;
			var bugpic_y = by+1;
			var bug = [bug_yellow,bug_green,bug_blue,bug_red];
			for (var i=0;i<4;i++)
				{
				if instance_exists(bug[i])
					{
					// Background image border changes if paused/unpaused
					var bo = bugpic_x+(50*i);
					draw_sprite(global.spr_ui.bug[i][bug[i].paused],0,bo,bugpic_y);
				
					// draw bug sprite
					draw_sprite_ext(bug[i].spr_up[1,round(bug[i].spr_subimg)],0,bo+30,by+19,1,1,bug[i].direction-90,c_white,1)
					}
				}
				
			// GO!
			var go_x = 446;
			var go_y = by+1;
			if draw_flash == 3 draw_sprite(global.spr_ui.onclick_stopgo,0,go_x,go_y);
			
			// Volume Increment Down
			var vol_down_x = 83;
			var vol_down_y = by+37;
			if draw_flash == 4 draw_sprite(global.spr_ui.onclick_slider_left,0,vol_down_x,vol_down_y);
			
			// Volume Increment Up
			var vol_up_x = 207;
			var vol_up_y = by+37;
			if draw_flash == 5 draw_sprite(global.spr_ui.onclick_slider_right,0,vol_up_x,vol_up_y);
			
			// Speed Increment Down
			var spd_down_x = 241;
			var spd_down_y = by+37;
			if draw_flash == 6 draw_sprite(global.spr_ui.onclick_slider_left,0,spd_down_x,spd_down_y);
			
			// Speed Increment Up
			var spd_up_x = 365;
			var spd_up_y = by+37;
			if draw_flash == 7 draw_sprite(global.spr_ui.onclick_slider_right,0,spd_up_x,spd_up_y);
			
			// RESTART
			var restart_x = 402;
			var restart_y = by+37;
			var flags = global.flag_list[0,2] + global.flag_list[1,2] 
			+ global.flag_list[2,2] + global.flag_list[3,2];
			if flags == -4
				{
				draw_set_alpha(0.5);
				draw_rectangle_color(restart_x,restart_y,restart_x+75,restart_y+26,0,0,0,0,false);
				draw_set_alpha(1);
				}
			if draw_flash == 8 draw_sprite(global.spr_ui.onclick_flagrestart,0,restart_x,restart_y);
			
			// Volume sliders
			var vol_x = 122;
			var vol_y = by+38;
			for (var i=0;i<4;i++)
				{
				if instance_exists(bug[i]) 
					{
					var current_percent = clamp(75 * (bug[i].volume/128),0,75);
				
					if point_in_rectangle(mx,my,vol_x,vol_y+(6*i),vol_x+75,vol_y+(6*i)+6) && !show_menu
						{
						if mouse_check_button(mb_left)
							{
							current_percent = clamp(75 * ((mx-vol_x)/75),0,76);
							}
						if mouse_check_button_released(mb_left)
							{
							var mouse_percent = clamp(128 * ((mx-vol_x)/75),0,128);
							bug[i].volume = mouse_percent;
							trace("bug {0} volume set to {1}",i,mouse_percent);
							}
						}
					
					draw_sprite(global.spr_ui.slider[i],0,vol_x+current_percent,vol_y+3+(6*i));
					}
				}
			
			// Speed/gear sliders
			var spd_x = 280;
			var spd_y = by+38;
			for (var i=0;i<4;i++)
				{
				if instance_exists(bug[i]) 
					{
					var current_percent = clamp(75 * (bug[i].gear/8),0,75);
				
					if point_in_rectangle(mx,my,spd_x,spd_y+(6*i),spd_x+75,spd_y+(6*i)+6) && !show_menu
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
					
					draw_sprite(global.spr_ui.slider[i],0,spd_x+current_percent,spd_y+3+(6*i));
					}
				}
			break;
			}
		
		// config/file
		case 4: 
			{
			draw_sprite(gui.file,0,0,by); 
			//draw_text(bx,by+16,"CONFIG/FILE TBA"); 
		
			var gal_x = 65;
			var gal_y = by;
			if draw_flash == 1 draw_sprite(global.spr_ui.onclick_top,0,gal_x,gal_y);
			
			var watch_x = 155;
			var watch_y = by+1;
			if draw_flash == 2 draw_sprite(global.spr_ui.onclick_top,0,watch_x,watch_y);
		
			var load_x = 246;
			var load_y = by;
			if draw_flash == 3 draw_sprite(global.spr_ui.onclick_top,0,load_x,load_y);
		
			var save_x = 337;
			var save_y = by;
			if draw_flash == 4 draw_sprite(global.spr_ui.onclick_top,0,save_x,save_y);
		
			var quit_x = 428;
			var quit_y = by;
			if draw_flash == 5 draw_sprite(global.spr_ui.onclick_top,0,quit_x,quit_y);
		
			var backdrop_x = 88;
			var backdrop_y = by+37;
			if draw_flash == 6 draw_sprite(global.spr_ui.onclick_bottom,0,backdrop_x,backdrop_y);
			break;
			}
		}
	
	var undo_x = 578;
	var undo_y = by+35;
	if draw_flash == 101 draw_sprite(global.spr_ui.onclick_undo,0,undo_x,undo_y);
	
	var reset_x = 609;
	var reset_y = by+35;
	if draw_flash == 102 draw_sprite(global.spr_ui.onclick_zap,0,reset_x,reset_y);
	
	var chooser_x = bx-20;
	var chooser_y = by+40;
	draw_sprite(global.spr_ui.chooser[!show_menu],0,chooser_x,chooser_y);
	if point_in_rectangle(mx,my,chooser_x,chooser_y,chooser_x+20,chooser_y+20) && mb
		{
		show_menu = !show_menu;
		audio_play_sound(global.snd_ui.menu[show_menu],0,false);
		}
		
	var mmy = 480 - round(menu_y);
	var mmx = bx+7;
	if menu_y>0 draw_sprite(global.spr_ui.menu[menu],0,bx,mmy);
	}
else
	{
	draw_rectangle_color(0,416,640,480,0,0,0,0,false);
	switch menu
		{
		// paint
		case 0:
			{
			// top row
			for (var i=1;i<=25;i++)
				{
				draw_sprite(spr_note,i-1,bx+(16*i),by);
				}
			
			// bottom row
			for (var i=1;i<=14;i++)
				{
				if i == 9 then i++;
				draw_sprite(spr_note_ctrl,i-1,bx+(16*i),by+16);
				}
				
			// Rainbow option
			var rainbow_x = bx+400; //463
			var rainbow_y = by;
			draw_sprite(spr_note_rainbow,0,rainbow_x,rainbow_y);
			break;
			}
		
		// stamps
		case 1: 
			{
			draw_set_color(c_white);
			draw_set_halign(fa_center);
			//draw_text(bx,by+16,"STAMP TBA"); 
			// Copy
			var copy_x = 65;
			var copy_y = by;
			draw_rectangle(copy_x,copy_y,copy_x+89,copy_y+32,true);
			draw_text(copy_x+44,copy_y+16,"COPY");
			if draw_flash == 1 draw_rectangle(copy_x,copy_y,copy_x+89,copy_y+32,false);
			
			// Move
			var move_x = 155;
			var move_y = by;
			draw_rectangle(move_x,move_y,move_x+89,move_y+32,true);
			draw_text(move_x+44,move_y+16,"MOVE");
			if draw_flash == 2 draw_rectangle(move_x,move_y,move_x+89,move_y+32,false);
			
			// Load
			var load_stamp_x = 83;
			var load_stamp_y = by+38;
			draw_rectangle(load_stamp_x,load_stamp_y,load_stamp_x+89,load_stamp_y+24,true);
			draw_text(load_stamp_x+44,load_stamp_y+12,"LOAD STP");
			if draw_flash == 3 draw_rectangle(load_stamp_x,load_stamp_y,load_stamp_x+89,load_stamp_y+24,false);
			
			// Save
			var save_stamp_x = 174;
			var save_stamp_y = by+38;
			draw_rectangle(save_stamp_x,save_stamp_y,save_stamp_x+89,save_stamp_y+24,true);
			draw_text(save_stamp_x+44,save_stamp_y+12,"SAVE STP");
			if draw_flash == 4 draw_rectangle(save_stamp_x,save_stamp_y,save_stamp_x+89,save_stamp_y+24,false);
			
			var scale_up_x = 414;
			var scale_up_y = by+39;
			draw_rectangle(scale_up_x,scale_up_y,scale_up_x+29,scale_up_y+25,true);
			draw_text(scale_up_x+14,scale_up_y+12,"SC+");
			
					
			var scale_down_x = 445;
			var scale_down_y = by+39;
			draw_rectangle(scale_down_x,scale_down_y,scale_down_x+29,scale_down_y+25,true);
			draw_text(scale_down_x+14,scale_down_y+12,"SC-");
				
			var toggle_clear_x = 482;
			var toggle_clear_y = by+39;
			draw_rectangle(toggle_clear_x,toggle_clear_y,toggle_clear_x+29,toggle_clear_y+25,true);
			draw_text(toggle_clear_x+14,toggle_clear_y+12,clear_back ? "CLR" : "OPQ");
			//draw_sprite(global.spr_ui.stamp_clearback[!clear_back],0,toggle_clear_x,toggle_clear_y);
			
			// Preset Stamps
			var preset_x = 155+90+76;
			var preset_y = by+3;
			for (var i=0;i<5;i++)
				{
				var j = (pstamp_page * 5) + i;
				var g = 32 * i;
				var gg = 32 * (i+1);
				if sprite_exists(pstamp_spr[j]) draw_sprite(pstamp_spr[j],0,preset_x+g+6,preset_y+6);
				draw_rectangle_inline(preset_x+g,preset_y,preset_x+gg,preset_y+30);
				if point_in_rectangle(mx,my,preset_x+g,preset_y,preset_x+gg,preset_y+30) && mb
					{
					if !instance_exists(obj_mouse_stamp) 
						{
						instance_destroy(m);
						mouse_create(obj_mouse_stamp);
						}
					m.note_array = pstamp[j].note_array;
					m.ctrl_array = pstamp[j].ctrl_array;
					m.loaded = true;
					m.move_mode = false;
					m.width = array_length(pstamp[j].note_array);
					m.height = array_length(pstamp[j].note_array[0]);
					m.copy_w = m.width;
					m.copy_h = m.height;
					m.copy_x = m.width/2;
					m.copy_y = m.height/2;
					m.update_surf();
					}
				}
				
			var preset_up_x = 494;
			var preset_up_y = by+3;
			if draw_flash == 5 draw_rectangle(preset_up_x,preset_up_y,preset_up_x+12,preset_up_y+6,false);
			draw_rectangle_inline(		preset_up_x,preset_up_y,preset_up_x+12,preset_up_y+6);
			if point_in_rectangle(mx,my,preset_up_x,preset_up_y,preset_up_x+12,preset_up_y+6) && mb
				{
				pstamp_page--;
				if pstamp_page < 0 pstamp_page = 19;
				flash(5);
				}
				
			draw_set_font(fnt_system);
			draw_set_color(c_white);
			draw_text(preset_up_x+6,preset_up_y+16,string(pstamp_page+1));
			
			var preset_down_x = preset_up_x;
			var preset_down_y = preset_up_y+24;
			if draw_flash == 6 draw_rectangle(preset_down_x,preset_down_y,preset_down_x+12,preset_down_y+6,false);
			draw_rectangle_inline(		preset_down_x,preset_down_y,preset_down_x+12,preset_down_y+6);
			if point_in_rectangle(mx,my,preset_down_x,preset_down_y,preset_down_x+12,preset_down_y+6) && mb
				{
				pstamp_page++;
				if pstamp_page > 19 pstamp_page = 0;
				flash(6);
				}
			
			// Greyed area
			var not_ready_x = 174;//176
			var not_ready_y = by+38;
			var e = instance_exists(obj_mouse_stamp);
			
			if !e or (e && !m.loaded)
				{
				draw_set_alpha(0.5);
				draw_set_color(c_black);
				draw_rectangle(not_ready_x,not_ready_y,not_ready_x+298,not_ready_y+26,false);
				draw_set_alpha(1);
				}
			else
				{
				if m.size == 5
					{
					draw_set_alpha(0.5);
					draw_set_color(c_black);
					draw_rectangle(scale_up_x,scale_up_y,scale_up_x+29,scale_up_y+25,false);
					draw_set_alpha(1);
					}
				}
			break;
			}
	
		// field/explore
		case 2: draw_set_halign(fa_left); draw_text(bx,by+16,"FIELD/EXPLORE TBA"); break;
		
		// bugz
		case 3: 
			{
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			var bbx = bx;
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
				draw_rectangle_inline_c(bbx,by,bbx+62,by+32,c);
				draw_rectangle_inline_c(bbx,by+33,bbx+62,by+63,c);
			
				// draw bug sprite
				if instance_exists(bug[i])
					{
					draw_sprite_ext(bug[i].spr_up[2,round(bug[i].spr_subimg)],0,bbx+32,by+16,1,1,bug[i].direction-90,c_white,1)
					draw_text(bbx+32,by+48,string(bug[i].gear));
					draw_text(bbx+16,by+48,"<");
					draw_text(bbx+48,by+48,">");
					}
				else 
					{
					draw_text(bbx+32,by+16,"N/A");
					draw_text(bbx+32,by+48,"N/A");
					}
					
				// bug speed
				if point_in_rectangle(mx,my,bbx,by+33,bbx+32,by+63) && mb && !show_menu
					{
					if instance_exists(bug[i])
						{
						bug[i].gear -= 1;
						if bug[i].gear < 0 bug[i].gear = 0;
						bug[i].calculate_timer();
						}
					}
				if point_in_rectangle(mx,my,bbx+33,by+33,bbx+64,by+63) && mb && !show_menu
					{
					if instance_exists(bug[i])
						{
						bug[i].gear += 1;
						if bug[i].gear > 8 bug[i].gear = 8;
						bug[i].calculate_timer();
						}
					}
			
				// pause state
				if point_in_rectangle(mx,my,bbx,by,bbx+64,by+32) && mb
					{
					if instance_exists(bug[i]) then bug[i].paused = !bug[i].paused;
					}
				bbx += 64;
				}
			
			// Stop all bugs
			draw_rectangle_inline(bbx,by,bbx+63,by+32);
			draw_text(bbx+32,by+16,"STOP!");
			if point_in_rectangle(mx,my,bbx,by,bbx+64,by+32) && mb
				{
				for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = true;
				}
				
			// Rally Bugz to flags
			draw_rectangle_inline(bbx,by+33,bbx+63,by+63);
			draw_text(bbx+32,by+48,"RALLY");
			if point_in_rectangle(mx,my,bbx,by+33,bbx+64,by+63) && mb && !show_menu
				{
				rally_bugz_to_flags();
				}
			bbx += 64;
		
			draw_rectangle_inline(bbx,by,bbx+63,by+32);
			draw_text(bbx+32,by+16,"GO!");
			if point_in_rectangle(mx,my,bbx,by,bbx+64,by+32) && mb
				{
				for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = false;
				}
				
			for (var i=0;i<4;i++)
				{
				var xx = bbx+(32*i);
				draw_sprite(spr_flag,i,xx+2+sprite_get_xoffset(spr_flag),by+34+sprite_get_yoffset(spr_flag));
				//draw_rectangle_color(xx,by+33,xx+33,by+63,c_white,c_white,c_white,c_white,true);
				if point_in_rectangle(mx,my,xx,by+33,xx+33,by+63) && mb && !show_menu
					{
					mouse_create(obj_mouse_flag);
					m.flag_id = i;
					}
				}
			
				
			bbx += 64;
			
			draw_rectangle_inline(bbx,by,bbx+63,by+32);
			draw_text(bbx+32,by+16,"CHOOSE");
			if point_in_rectangle(mx,my,bbx,by,bbx+64,by+32) && mb
				{
				menu_bugz();
				}
			
			draw_set_halign(fa_left);
			//draw_text(bx,by,"BUGZ");
			break;
			}
		
		// config/file
		case 4: //draw_text(bx,by+16,"CONFIG/FILE TBA"); 
			{
			draw_set_halign(fa_center);
			
			var backdrop_x = 89;
			var backdrop_y = by+38;
			draw_rectangle_inline(backdrop_x,backdrop_y,backdrop_x+88,backdrop_y+26);
			draw_text(backdrop_x+44,backdrop_y+13,"BACKDROP");
	
			//+90,+34
			var gal_x = 66;
			var gal_y = by+1;
			draw_rectangle_inline(gal_x,gal_y,gal_x+90,gal_y+34);
			draw_text(gal_x+45,gal_y+16,"GALLERY");
			
			var watch_x = 155;
			var watch_y = by+1;
			draw_rectangle_inline(watch_x,watch_y,watch_x+90,watch_y+34);
			draw_text(watch_x+45,watch_y+16,"WATCH");
	
			//+90,+34
			var load_x = 247;
			var load_y = by+1;
			draw_rectangle_inline(load_x,load_y,load_x+90,load_y+34);
			draw_text(load_x+45,load_y+16,"LOAD");
		
			var save_x = 338;
			var save_y = by+1;
			draw_rectangle_inline(save_x,save_y,save_x+90,save_y+34);
			draw_text(save_x+45,save_y+16,"SAVE");
		
			var quit_x = 429;
			var quit_y = by+1;
			draw_rectangle_inline(quit_x,quit_y,quit_x+90,quit_y+34);
			draw_text(quit_x+48,quit_y+16,"QUIT");
			break;
			}
		}
		
	// Constant items that are at the same place no matter which menu is present
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	var zoom_x = 534;
	var zoom_y = by+1;
	draw_circle(zoom_x+8,zoom_y+8,8,true);
	draw_line(zoom_x+8,zoom_y+16,zoom_x+8,zoom_y+32);
	
	var tweezer_x = 556;
	var tweezer_y = by+1;
	draw_line(tweezer_x,tweezer_y,tweezer_x+8,tweezer_y+32);
	draw_line(tweezer_x+8,tweezer_y+32,tweezer_x+16,tweezer_y);
	
	var undo_x = 578;
	var undo_y = by+35;
	draw_rectangle_inline(undo_x,undo_y,undo_x+29,undo_y+29);
	draw_text(undo_x+14,undo_y+14,"UNDO");
	if draw_flash == 101 draw_rectangle(undo_x,undo_y,undo_x+29,undo_y+29,false);
	
	var reset_x = 609;
	var reset_y = by+35;
	draw_rectangle_inline(reset_x,reset_y,reset_x+29,reset_y+29);
	draw_text(reset_x+14,reset_y+14,"RESET");
	if draw_flash == 102 draw_rectangle(reset_x,reset_y,reset_x+29,reset_y+29,false);
	
	var chooser_x = bx-20;
	var chooser_y = by+40;
	draw_rectangle_inline(chooser_x,chooser_y,chooser_x+20,chooser_y+20);
	draw_text(chooser_x+10,chooser_y+10,show_menu ? "O" : "X");
	if point_in_rectangle(mx,my,chooser_x,chooser_y,chooser_x+20,chooser_y+20) && mb
		{
		show_menu = !show_menu;
		}
		
	var mmx = bx+7;	
	var mmy = 480 - round(menu_y);
	if menu_y > 0
		{
		draw_rectangle_color(mmx,mmy,mmx+(95*4)+95,mmy+24,0,0,0,0,false);
		draw_rectangle_inline(mmx,mmy,mmx+(95*4)+95,mmy+24);
		draw_text(mmx+48,mmy+12,"PAINT");
		draw_text(mmx+(95)+48,mmy+12,"STAMP");
		draw_text(mmx+(95*2)+48,mmy+12,"EXPLORE");
		draw_text(mmx+(95*3)+48,mmy+12,"BUGZ");
		draw_text(mmx+(95*4)+48,mmy+12,"FILE");
		}
	}