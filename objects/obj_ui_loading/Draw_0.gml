draw_set_font(global.fnt_bolditalic);
draw_set_color(c_black);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var ww = window_get_width();
var hh = window_get_height();
draw_rectangle(0,0,ww,hh,false);
draw_set_color(c_white);
draw_text(ww/2,hh/2,"LOADING...(RUN CMD FOR LOG INFO)")