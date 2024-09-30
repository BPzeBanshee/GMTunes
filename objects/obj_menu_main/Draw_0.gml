if !enabled exit;
scr_draw_vars(global.fnt_bolditalic,fa_left,c_white);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_text(0,0,"GMTUNES: SIMTUNES-RELATED TOOLS");
draw_set_font(global.fnt_default);
draw_text(0,12,"by BPze\nSpecial thanks:\nlucasvb & Yellow\nSimTunes Community");

if sprite_exists(spr)
	{
	draw_sprite(spr,0,0,0);
	
	// Start Game
	pal_swap_set(surf,1,true);
	draw_sprite_part(spr,0,206,21,227,244,206,21); 
	
	// Gallery
	pal_swap_set(surf2,1,true);
	draw_sprite_part(spr,0,46,270,157,138,46,270);
	
	// Tutorial
	pal_swap_set(surf3,1,true);
	draw_sprite_part(spr,0,427,270,176,138,427,270);
	
	// Exit Game
	pal_swap_set(surf4,1,true);
	draw_sprite_part(spr,0,280,371,77,85,280,371);
	
	pal_swap_reset();
	}

/*draw_rectangle(206,21,206+227,21+244,true);
draw_rectangle(46,270,46+157,270+138,true);
draw_rectangle(427,270,427+176,270+138,true);
draw_rectangle(280,371,280+77,371+85,true);*/

/*draw_set_font(fnt_arial);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_text(8,8,string("K: {0}, C: {1}",keyboard_lastkey,keyboard_lastchar));*/