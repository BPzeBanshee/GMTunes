// Feather disable GM2016
/*draw_set_alpha(1);
if global.zoom > 0
	{
	draw_set_color(c_black);
	draw_rectangle(0,416,640,480,false);
	}
scr_draw_vars(global.fnt_bold,fa_left,c_white);
draw_set_valign(fa_middle);

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var bx = 64;
var by = 416;
switch menu
	{
	// paint
	case 0:
		{
		// top row
		var mmy = (my >= by && my <= by+15) ? true : false;
		for (var i=1;i<25;i++)
			{
			var xx = bx+(16*i);
			if global.use_int_spr
			draw_sprite(spr_note,i,xx,by)
			else draw_sprite(global.spr_note2[0][i],0,xx,by);
			if (mx >= xx && mx <= xx+16 && mmy) && mouse_check_button_pressed(mb_left)
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
			if (mx >= xx && mx <= xx+16 && mmy) && mouse_check_button_pressed(mb_left)
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
			if (mmx && mmy) && mouse_check_button_pressed(mb_left)
				{
				if instance_exists(bug[i]) then bug[i].paused = !bug[i].paused;
				}
				
			bbx += 64;
			}
			
		draw_rectangle_color(bbx,by,bbx+63,by+32,c_white,c_white,c_white,c_white,true);
		draw_text(bbx+32,by+16,"STOP!");
		mmx = (mx >= bbx && mx <= bbx+64) ? true : false;
		if (mmx && mmy) && mouse_check_button_pressed(mb_left)
			{
			for (var i=0;i<4;i++) if instance_exists(bug[i]) then bug[i].paused = true;
			}
		bbx += 64;
		
		draw_rectangle_color(bbx,by,bbx+63,by+32,c_white,c_white,c_white,c_white,true);
		draw_text(bbx+32,by+16,"GO!");
		mmx = (mx >= bbx && mx <= bbx+64) ? true : false;
		if (mmx && mmy) && mouse_check_button_pressed(mb_left)
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
	}*/