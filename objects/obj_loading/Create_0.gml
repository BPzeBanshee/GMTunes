alpha = 0;
mode = 0;

g = game_get_speed(gamespeed_fps);
inc = 3 / g;

tasks = 0;
max_tasks = 1;
txt = "Loading Aeuhh....";

spr_txt = global.use_external_assets ? global.spr_ui.txt : -1;
spr_bar = global.use_external_assets ? global.spr_ui.bar : -1;
bar_color = make_color_rgb(4,58,228);