scr_draw_vars(fnt_internal_bold,fa_center,c_white);
draw_set_alpha(1);

draw_rectangle_color(x,y,x+width,y+height,0,0,0,0,false);
draw_rectangle(x,y,x+width,y+height,true);

draw_rectangle_inline_c(x,y,x+(width/2),y+(height/2),c_yellow);
draw_text(x+80,y+60,"LOAD YELLOW");

draw_rectangle_inline_c(x+(width/2)+1,y,x+width,y+(height/2),c_lime);
draw_text(x+240,y+60,"LOAD GREEN");

draw_rectangle_inline_c(x,y+(height/2)+1,x+(width/2),y+height,c_aqua);
draw_text(x+80,y+180,"LOAD BLUE");

draw_rectangle_inline_c(x+(width/2)+1,y+(height/2)+1,x+width,y+height,c_red);
draw_text(x+240,y+180,"LOAD RED");