draw_self();
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(global.fnt_bold);
draw_text(x,y,string(txt));
//draw_set_valign(fa_top);