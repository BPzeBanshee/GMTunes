if !ready exit;
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_set_font(fnt_internal_bold);

// selection animation
select_a = select_am ? select_a+0.05 : select_a-0.05;
if select_a >= 1 select_am = false;
if select_a <= 0 select_am = true;

// ui background
if sprite_exists(back) draw_sprite(back,0,320,240);
var mx = mouse_x;
var my = mouse_y;

var ax = 7; var ay = 8;
var show_desc = false;
var show_x = 0;
var show_y = 0;
for (var xx = 0; xx < 4;xx++)
	{
	var sx = ax+(160*xx);
	
	// scroll up/down on arrows
	if mouse_check_button_pressed(mb_left)
		{
		var ux = (160 * (xx+1)) - 16;
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
		
		if mouse_check_button_pressed(mb_left)
			{
			if point_in_rectangle(mx,my,sx,sy,sx+ww,sy+hh)
				{
				bug_index[xx] = bug_pos[xx]+yy;
				}
				
			var ssx = 121+(160*xx);
			var ssy = 112+(135*yy);
			if point_in_rectangle(mx,my,ssx,ssy,ssx+16,ssy+16)
				{
				snd_index_x = xx;
				snd_index_y = bug_pos[xx]+yy;
				snd_count = 0;
				alarm[2] = 1;
				}
			}
		
		if bug_pos[xx]+yy == bug_index[xx]
			{
			draw_set_alpha(select_a);
			var cc = c_white;
			switch xx
				{
				case 0: cc = c_yellow; break;
				case 1: cc = c_green; break;
				case 2: cc = c_blue; break;
				case 3: cc = c_red; break;
				}
			draw_set_color(cc);
			draw_rectangle(sx-4, sy-4, sx+ww+4, sy+hh+4, false);
			draw_set_color(c_black);
			draw_set_alpha(1);
			}
		draw_sprite(s,0,sx,sy);
		draw_text(sx+40,sy+106,n);
		
		if mouse_check_button(mb_left)
			{
			var dx = 102 + (160*xx);
			var dy = 112 + (135*yy);
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
	var anchor_x = 320-(dw/2);
	var anchor_y = 240-(dh/2);
	pal_swap_set(spr_shd_ui,1,false);
	draw_sprite_stretched(global.spr_ui.txt,0,anchor_x,anchor_y,dw,dh*2);
	pal_swap_reset();
	draw_sprite(global.spr_ui.desc,0,anchor_x+4,anchor_y+2);
	scr_draw_vars(global.fnt_bold,fa_left,c_white);
	draw_text(anchor_x+56,anchor_y+8,bug[show_x][show_y].name);
	draw_set_halign(fa_center);
	draw_text(320,240+(dh/2),bug[show_x][show_y].desc);
	}