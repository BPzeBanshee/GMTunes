draw_set_alpha(alpha);
if alpha > 0
	{
	draw_set_color(c_black);
	draw_rectangle(-8,0,640,480,false);
	}
	
if mode == 1
	{
	// text box vars
	var tx = 320;
	var ty = 240;
	var tw = 169;
	var th = 40;

	// load bar vars
	var bx = tx;
	var by = 360;

	draw_set_alpha(1);
	//pal_swap_set(spr_shd_ui,1,false);
	if sprite_exists(spr_txt) draw_sprite_stretched(spr_txt,0,tx-(tw/2),ty-(th/2),tw,th);
	if sprite_exists(spr_bar) draw_sprite(spr_bar,0,bx,by);
	//pal_swap_reset();
	scr_draw_vars(global.fnt_bold,fa_center,c_white);
	draw_set_valign(fa_middle);
	draw_text(tx,ty,txt);

	var z = 3;
	draw_healthbar(z,by-22+z,640-z,by+21-z,(tasks/max_tasks)*100,c_black,bar_color,bar_color,0,false,false);
	}