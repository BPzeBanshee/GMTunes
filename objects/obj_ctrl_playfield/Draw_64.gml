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
	switch menu
		{
		// paint
		case 0:
			{
			draw_sprite(gui.paint,0,0,by); 
			
			// musical selector (55,14)
			var music_x = bx-9;
			var music_y = by+14;
			draw_sprite(global.spr_ui.playnote[play_index],0,music_x,music_y);
		
			// top row
			var note_x = bx;
			var note_y = by;
			for (var i=1;i<=25;i++)
				{
				var xx = note_x + (16*i);
				if global.use_external_assets
				draw_sprite(global.spr_note2[0][i],0,xx,note_y)
				else draw_sprite(spr_note,i-1,xx,note_y);
				}
			
			// bottom row
			for (var i=1;i<=14;i++)
				{
				if i == 9 then i++;
				var xx = bx+(16*i);
				if global.use_external_assets
				draw_sprite(global.spr_note2[i][0],0,xx,by+16)
				else draw_sprite(spr_note_ctrl,i-1,xx,by+16);
				}
			break;
			}
		
		// stamps
		case 1: 
			{
			draw_sprite(gui.stamp,0,0,by);
			//draw_text(bx,by+16,"STAMP TBA"); 
			break;
			}
	
		// *** EXPLORE ***
		case 2: 
		draw_rectangle_color(0,416,640,480,0,0,0,0,false);
		/*draw_sprite(gui.explore,0,0,by);*/ 
		draw_text(bx,by+16,"FIELD/EXPLORE TBA"); 
		break;
		
		// *** BUGZ ***
		case 3: 
			{
			draw_sprite(gui.bugz,0,0,by);
			
			var bug = [bug_yellow,bug_green,bug_blue,bug_red];
			
			// Bug Buttons
			var bugpic_x = 246;
			var bugpic_y = by+1;
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
			
			// RESTART
			var restart_x = 400;
			var restart_y = by+38;
			var flags = global.flag_list[0,2] + global.flag_list[1,2] 
			+ global.flag_list[2,2] + global.flag_list[3,2];
			if flags == -4
				{
				draw_set_alpha(0.5);
				draw_rectangle_color(restart_x,restart_y,restart_x+75,restart_y+26,c_black,c_black,c_black,c_black,false);
				draw_set_alpha(1);
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
					
					draw_sprite(global.spr_ui.slider[i],0,volume_x+current_percent,volume_y+3+(6*i));
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
					
					draw_sprite(global.spr_ui.slider[i],0,spd_x+current_percent,spd_y+3+(6*i));
					}
				}
			break;
			}
		
		// config/file
		case 4: 
		draw_sprite(gui.file,0,0,by); 
		//draw_text(bx,by+16,"CONFIG/FILE TBA"); 
		break;
		}
	}
else
	{
	draw_rectangle_color(0,416,640,480,0,0,0,0,false);
	
	// Constant items that are at the same place no matter which menu is present
	var zoom_x = 534;
	var zoom_y = by+1;
	draw_circle(zoom_x+8,zoom_y+8,8,true);
	draw_line(zoom_x+8,zoom_y+16,zoom_x+8,zoom_y+32);
	
	var tweezer_x = 556;
	var tweezer_y = by+1;
	draw_line(tweezer_x,tweezer_y,tweezer_x+8,tweezer_y+32);
	draw_line(tweezer_x+8,tweezer_y+32,tweezer_x+16,tweezer_y);
		
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
				if i == 9 then i++;
				xx = bx+(16*i);
				draw_sprite(spr_note_ctrl,i-1,xx,by+16);
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
				draw_rectangle_color(bbx,by+33,bbx+62,by+63,c,c,c,c,true);
			
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
				if point_in_rectangle(mx,my,bbx,by+33,bbx+32,by+63) && mb
					{
					if instance_exists(bug[i])
						{
						bug[i].gear -= 1;
						if bug[i].gear < 0 bug[i].gear = 0;
						bug[i].calculate_timer();
						}
					}
				if point_in_rectangle(mx,my,bbx+33,by+33,bbx+64,by+63) && mb
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
			draw_rectangle_color(bbx,by,bbx+63,by+32,c_white,c_white,c_white,c_white,true);
			draw_text(bbx+32,by+16,"STOP!");
			if point_in_rectangle(mx,my,bbx,by,bbx+64,by+32) && mb
				{
				for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = true;
				}
				
			// Rally Bugz to flags
			draw_rectangle_color(bbx,by+33,bbx+63,by+63,c_white,c_white,c_white,c_white,true);
			draw_text(bbx+32,by+48,"RALLY");
			if point_in_rectangle(mx,my,bbx,by+33,bbx+64,by+63) && mb
				{
				rally_bugz_to_flags();
				}
			bbx += 64;
		
			draw_rectangle_color(bbx,by,bbx+63,by+32,c_white,c_white,c_white,c_white,true);
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
				if point_in_rectangle(mx,my,xx,by+33,xx+33,by+63) && mb
					{
					mouse_create(obj_mouse_flag);
					m.flag_id = i;
					}
				}
			
				
			bbx += 64;
			
			draw_rectangle_color(bbx,by,bbx+63,by+32,c_white,c_white,c_white,c_white,true);
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
			draw_rectangle(backdrop_x,backdrop_y,backdrop_x+88,backdrop_y+26,true);
			draw_text(backdrop_x+44,backdrop_y+13,"BACKDROP");
	
			//+90,+34
			var gal_x = 66;
			var gal_y = by+1;
			draw_rectangle(gal_x,gal_y,gal_x+90,gal_y+34,true);
			draw_text(gal_x+45,gal_y+16,"GALLERY");
	
			//+90,+34
			var load_x = 247;
			var load_y = by+1;
			draw_rectangle(load_x,load_y,load_x+90,load_y+34,true);
			draw_text(load_x+45,load_y+16,"LOAD");
		
			var save_x = 338;
			var save_y = by+1;
			draw_rectangle(save_x,save_y,save_x+90,save_y+34,true);
			draw_text(save_x+45,save_y+16,"SAVE");
		
			var quit_x = 429;
			var quit_y = by+1;
			draw_rectangle(quit_x,quit_y,quit_x+90,quit_y+34,true);
			draw_text(quit_x+48,quit_y+16,"QUIT");
			break;
			}
		}
	}