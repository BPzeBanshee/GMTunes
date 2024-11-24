alpha = 0;
mode = 0;
nextroom = -1;

tasks = 0;
max_tasks = 0;
txt = "Loading Aeuhh....";

spr_txt = global.use_external_assets ? global.spr_ui.txt : -1;
spr_bar = global.use_external_assets ? global.spr_ui.bar : -1;
bar_color = make_color_rgb(4,58,228);

var g = game_get_speed(gamespeed_fps);
increment_speed = 3 / g; //0.05;