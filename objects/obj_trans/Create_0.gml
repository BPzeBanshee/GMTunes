alpha = 0;
mode = 0;
nextroom = -1;

tasks = 0;
max_tasks = 0;
txt = "Loading Aeuhh....";

spr_txt = sprite_exists(global.spr_ui_txt) ? global.spr_ui_txt : -1;
spr_bar = sprite_exists(global.spr_ui_bar) ? global.spr_ui_bar : -1;
bar_color = make_color_rgb(4,58,228);