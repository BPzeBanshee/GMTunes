if !ready exit;
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_set_font(fnt_internal_bold);

// selection animation
select_a = select_am ? select_a+0.033 : select_a-0.033;
if select_a >= 1 select_am = false;
if select_a <= 0 select_am = true;

// ui background
if sprite_exists(back) 
draw_sprite(back,0,320,240)
else draw_rectangle_color(0,0,640,480,c_grey,c_grey,c_grey,c_grey,false);
var mx = mouse_x;
var my = mouse_y;

if !global.use_external_assets
	{
	draw_set_color(c_black);
	draw_rectangle(227,448,336,480,true);
	draw_rectangle(343,448,454,480,true);
	draw_rectangle(462,448,572,480,true);
	var ty = 448+8;
	draw_text(227+54,ty,"OK");
	draw_text(343+54,ty,"CANCEL");
	draw_text(462+54,ty,"RESET");
	}
else
	{
	if draw_flash == 1 draw_sprite(global.spr_ui.onclick_okcancel,0,227-1,448);
	if draw_flash == 2 draw_sprite(global.spr_ui.onclick_okcancel,0,343-1,448);
	if draw_flash == 3 draw_sprite(global.spr_ui.onclick_okcancel,0,462-1,448);
	}

var ax = 7; var ay = 8;
var show_desc = false;
var show_x = 0;
var show_y = 0;
for (var xx = 0; xx < 4;xx++)
	{
	var sx = ax+(160*xx);
	
	// scroll up/down on arrows
	var ux = (160 * (xx+1)) - 16;
	if !global.use_external_assets
		{
		draw_rectangle(ux,0,ux+16,16,true);
		draw_rectangle(ux,386,ux+16,386+16,true);
		draw_text(ux+8,0,@"/\");
		draw_text(ux+8,386,@"\/");
		}
	if mouse_check_button_pressed(mb_left)
		{
		if point_in_rectangle(mx,my,ux,0,ux+16,0+16)
			{
			if bug_pos[xx] > 0
			bug_pos[xx] -= 1;
			}
		if point_in_rectangle(mx,my,ux,386,ux+16,386+16)
			{
			if bug_pos[xx]+3 < array_length(bug[xx])
			bug_pos[xx] += 1;
			}
		}
	
	// select bugz
	for (var yy = 0; yy < 3; yy++)
		{
		var s = bug[xx][bug_pos[xx]+yy].show;
		var n = bug[xx][bug_pos[xx]+yy].name;
		var ww = sprite_get_width(s);
		var hh = sprite_get_height(s);
		
		var sy = ay+(134*yy);
		
		// Music play
		var ssx = 121+(160*xx);
		var ssy = 112+(135*yy);
		if !global.use_external_assets
			{
			draw_set_color(c_black);
			draw_rectangle(ssx,ssy,ssx+16,ssy+16,true);
			draw_text(ssx+8,ssy,"#");
			}
		
		if mouse_check_button_pressed(mb_left)
			{
			if point_in_rectangle(mx,my,sx,sy,sx+ww,sy+hh)
				{
				bug_index[xx] = bug_pos[xx]+yy;
				}
				
			
			if point_in_rectangle(mx,my,ssx,ssy,ssx+16,ssy+16)
				{
				snd_index_x = xx;
				snd_index_y = bug_pos[xx]+yy;
				snd_count = 0;
				alarm[2] = 1;
				}
			}
			
		draw_set_color(c_black);
		if bug_pos[xx]+yy == bug_index[xx]
			{
			//draw_set_alpha(select_a);
			var cc = 0; 
			switch xx
				{
				case 0: cc = 60/360; break;
				case 1: cc = 120/360; break;
				case 2: cc = 240/360; break;
				case 3: cc = 0; break;
				}
			var pc = (select_a * 255);
			draw_set_color(make_color_hsv(255 * cc,255 - pc,pc));
			draw_rectangle(sx-4, sy-4, sx+ww+2, sy+hh+3, false);
			draw_set_color(c_black);
			//draw_set_alpha(1);
			}
		draw_sprite(s,0,sx,sy);
		draw_text(sx+40,sy+106,n);
		
		var dx = 102 + (160*xx);
		var dy = 112 + (135*yy);
		if !global.use_external_assets
			{
			draw_set_color(c_black);
			draw_rectangle(dx,dy,dx+16,dy+16,true);
			draw_text(dx+8,dy,"?");
			}
		if mouse_check_button(mb_left)
			{
			if point_in_rectangle(mx,my,dx,dy,dx+16,dy+16)
				{
				show_desc = true;
				show_x = xx;
				show_y = bug_pos[xx]+yy;
				}
			}
		}
		
	// Preview bug sprite
	var ix = 75+(160*xx);
	var iy = 424;
	draw_sprite_ext(bug[xx][bug_index[xx]].spr[1][anim_index],0,ix,iy,1,1,-90,c_white,1);
	}
	
if show_desc
	{
	var dw = 480;
	var dh = string_height(bug[show_x][show_y].desc);
	var anchor_x = round(320-(dw/2));
	var anchor_y = round(192-(dh/2));
	if global.use_external_assets
		{
		pal_swap_set(spr_shd_ui,1,false);
		draw_sprite_stretched(global.spr_ui.txt,0,anchor_x,anchor_y,dw,dh*4);
		pal_swap_reset();
		draw_sprite(global.spr_ui.desc,0,anchor_x+5,anchor_y+3);
		}
	else
		{
		draw_set_color(c_black);
		draw_set_alpha(0.75);
		draw_rectangle(anchor_x,anchor_y,anchor_x+dw,anchor_y+dh*2,false);
		draw_set_alpha(1);
		}
	scr_draw_vars(global.fnt_bold,fa_left,c_white);
	draw_text(anchor_x+56,anchor_y+8,bug[show_x][show_y].name);
	draw_set_halign(fa_center);
	draw_text(320,anchor_y+(dh*2),bug[show_x][show_y].desc);
	}