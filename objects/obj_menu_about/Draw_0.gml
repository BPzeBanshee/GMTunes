scr_draw_vars(global.fnt_bold,fa_center,c_black);
draw_rectangle(0,0,640,480,false);
draw_set_color(c_white);
txt_y -= 1;
draw_text(room_width/2,txt_y,txt_credits);
draw_sprite_part(myspr,0,0,0,640,160,0,0);
draw_sprite_part(myspr,0,0,380,640,100,0,380);