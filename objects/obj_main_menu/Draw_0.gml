draw_set_font(global.fnt_bolditalic);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_center);

//if surface_exists(bmp) then draw_surface(bmp,0,0);
if sprite_exists(spr) then draw_sprite(spr,0,0,0);

if loading 
then 
	{
	draw_rectangle_color(0,0,window_get_width(),window_get_height(),c_black,c_black,c_black,c_black,false);
	draw_text(x,y-96-2,"LOADING...(RUN CMD FOR LOG INFO)")
	}
else
	{
	draw_text(x,y-96-2,"GMTUNES: SIMTUNES-RELATED TOOLS");
	draw_set_font(global.fnt_default);
	draw_text(x,y-64,"by BPze\nSpecial thanks to lucasvb & Yellow");
	}