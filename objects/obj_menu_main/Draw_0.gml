if sprite_exists(spr)
	{
	draw_sprite(spr,0,320,240);
	
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
else
	{
	draw_sprite(spr_logo,0,320,sprite_get_yoffset(spr_logo));
	}
	
scr_draw_vars(global.fnt_bold,fa_left,c_white);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_text(0,0,"GMTunes Build "+string(GAME_VERSION));
draw_set_font(global.fnt_bolditalic);
draw_text(0,12,"Special thanks:");
draw_set_font(global.fnt_default);
draw_text(0,24,"lucasvb & Yellow\nSimTunes Community");

/*draw_rectangle(206,21,206+227,21+244,true);
draw_rectangle(46,270,46+157,270+138,true);
draw_rectangle(427,270,427+176,270+138,true);
draw_rectangle(280,371,280+77,371+85,true);*/