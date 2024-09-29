draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_black);
draw_set_font(fnt_small);

// selection animation
select_a = select_am ? select_a+0.05 : select_a-0.05;
if select_a >= 1 select_am = false;
if select_a <= 0 select_am = true;

// ui background
if sprite_exists(back) draw_sprite(back,0,0,0);

var ax = 7; var ay = 8;
for (var xx = 0; xx < 4;xx++)
	{
	var sx = ax+(160*xx);
	
	// scroll up/down on arrows
	if mouse_check_button_pressed(mb_left)
		{
		var ux = (160 * (xx+1)) - 16;
		if point_in_rectangle(mouse_x,mouse_y,ux,0,ux+16,0+16)
			{
			if bug_pos[xx] > 0
			bug_pos[xx] -= 1;
			}
	
		if point_in_rectangle(mouse_x,mouse_y,ux,386,ux+16,386+16)
			{
			if bug_pos[xx]+3 < array_length(bug[xx])
			bug_pos[xx] += 1;
			}
		}
	
	// select bugz
	for (var yy = 0; yy < 3; yy++)//array_length(lists[xx]); yy++)
		{
		var s = bug[xx][bug_pos[xx]+yy].spr;
		var n = bug[xx][bug_pos[xx]+yy].name;
		var ww = sprite_get_width(s);
		var hh = sprite_get_height(s);
		
		var sy = ay+(134*yy);
		
		if point_in_rectangle(mouse_x,mouse_y,sx,sy,sx+ww,sy+hh)
		&& mouse_check_button_pressed(mb_left)
			{
			bug_index[xx] = bug_pos[xx]+yy;
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
		}
	}