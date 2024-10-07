// Feather disable GM2016
draw_set_alpha(1);
scr_draw_vars(global.fnt_bold,fa_left,c_white);
draw_set_valign(fa_middle);
if loading_prompt
	{
	draw_rectangle_color(0,0,640,480,0,0,0,0,false);
	draw_set_halign(fa_center);
	draw_text(320,240,"NOW LOADING (MAY LAG A BIT)");
	return;
	}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var mb = mouse_check_button_pressed(mb_left);
var bx = 64;
var by = 416;
switch menu
	{
	// paint
	case 0:
		{
		draw_sprite(gui.paint,0,0,by); 
		
		// top row
		var mmy = (my >= by && my <= by+15) ? true : false;
		for (var i=1;i<25;i++)
			{
			var xx = bx+(16*i);
			if global.use_int_spr
			draw_sprite(spr_note,i,xx,by)
			else draw_sprite(global.spr_note2[0][i],0,xx,by);
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
		for (var i=1;i<14;i++)
			{
			if i == 9 then i++;
			var xx = bx+(16*i);
			if global.use_int_spr
			draw_sprite(spr_note_ctrl,i,xx,by+16)
			else draw_sprite(global.spr_note2[i][0],0,xx,by+16); //myctrlnote,i
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
	case 1: draw_sprite(gui.stamp,0,0,by); draw_text(bx,by+16,"STAMP TBA"); break;
	
	// *** EXPLORE ***
	case 2: draw_sprite(gui.explore,0,0,by); draw_text(bx,by+16,"FIELD/EXPLORE TBA"); break;
		
	// *** BUGZ ***
	case 3: 
		{
		draw_sprite(gui.bugz,0,0,by);
		var bug = [bug_yellow,bug_green,bug_blue,bug_red];
		
		var choose_x = 66;
		var choose_y = by+1;
		if point_in_rectangle(mx,my,choose_x,choose_y,choose_x+90,choose_y+34)
			{
			if mb
				{
				callmethod = menu_bugz;
				loading_prompt = true;
				alarm[0] = 2;
				}
			}
			
		var stop_x = 174;
		var stop_y = by+1;
		if point_in_rectangle(mx,my,stop_x,stop_y,stop_x+72,stop_y+34)
			{
			if mb for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = true;
			}
			
		// Bug Buttons
		// TODO: STOPGO.BMP implementation, correct offsets
		var bugpic_x = 246;
		var bugpic_y = by+1;
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		for (var i=0;i<4;i++)
			{
			// draw bug sprite
			var bo = bugpic_x+(50*i);
			if instance_exists(bug[i])
			draw_sprite_ext(bug[i].spr_up[2,round(bug[i].spr_subimg)],0,bo+25,by+20,1,1,bug[i].direction-90,c_white,1)
			else draw_text(bo+25,by+20,"N/A");
			
			if point_in_rectangle(mx,my,bo,bugpic_y,bo+50,bugpic_y+34)
				{
				if mb if instance_exists(bug[i]) then bug[i].paused = !bug[i].paused;
				}
			}
			
		var go_x = 446;
		var go_y = by+1;
		if point_in_rectangle(mx,my,go_x,go_y,go_x+72,go_y+34)
			{
			if mb for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = false;
			}
			
		// Restart Flag position
		var restart_x = 400;
		var restart_y = by+38;
		if point_in_rectangle(mx,my,restart_x,restart_y,restart_x+75,restart_y+26)
			{
			if mb rally_bugz_to_flags();
			}
			
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
		if mb load_bkg();
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