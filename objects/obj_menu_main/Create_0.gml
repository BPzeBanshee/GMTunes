///@desc Create buttons/array list
#region methods
start_game = function(){
global.playfield = new default_playfield();
scr_trans(rm_playfield);
enabled = false;
}

start_gallery = function(){
//var f = global.main_dir+"GALLERY/ALIENEXP.GAL";
var f = get_open_filename_ext("SimTunes .GAL file|*.GAL","",global.main_dir+"GALLERY/","Open Gallery File...");
if string_length(f) > 0 && file_exists(f) 
	{
	global.playfield = tun_load_tun(f);
	if is_struct(global.playfield)
		{
		//global.playfield = tun_load_tun(global.main_dir+"GALLERY/WATCHING.GAL");
		scr_trans(rm_playfield);
		enabled = false;
		}
	}
}

start_debug = function(){
scr_trans(rm_debug_tools);
enabled = false;
}

exit_game = function(){
game_end();
}

init_surfpal = function(spr,arr){
	var hh = sprite_get_height(spr);
	var surf = surface_create(sprite_get_width(spr),hh);
	surface_set_target(surf);
	draw_sprite(spr,0,0,0);
	surface_reset_target();

	for (var yy=0;yy<hh;yy++)
		{
		var data = surface_getpixel(surf,1,yy);
		arr[yy] = color_get_hue(data);
		}

	return surf;
	}
cycle_surfpal = function(surf,arr){
var g = game_get_speed(gamespeed_fps);
var inc = round(240 / g);
if surface_exists(surf)
	{
	surface_set_target(surf);
	for (var yy=0; yy<surface_get_height(surf); yy++)
		{
		draw_point_color(1,yy,make_color_hsv(arr[yy],255,255));
		arr[yy] += inc; if arr[yy] > 255 arr[yy] -= 255;
		}
	surface_reset_target();
	}
}
#endregion
instance_create_depth(0,0,depth-1,obj_mouse_parent);
enabled = true;
over = false;
spr = -1;
if global.use_external_assets
	{
	h[0] = 0; h2[0] = 0; h3[0] = 0; h4[0] = 0;
	surf = init_surfpal(spr_shd_menu1,h);
	surf2 = init_surfpal(spr_shd_menu2,h2);
	surf3 = init_surfpal(spr_shd_menu3,h3);
	surf4 = init_surfpal(spr_shd_menu4,h4);

	// Load sounds & background
	b = -1;
	snd_play = -1;
	snd_gal = -1;
	snd_tut = -1;
	snd_exit = -1;
	snd_quit = -1;
	var f1 = TUNERES+"startup.WAV";
	if file_exists(f1)
		{
		spr = bmp_load_sprite(TUNERES+"Startup2.bmp");
		b = wav_load(f1,true);
		snd_play = wav_load(TUNERES+"play.wav",true);
		snd_gal = wav_load(TUNERES+"gallery.wav",true);
		snd_tut = wav_load(TUNERES+"tutorial.wav",true);
		snd_exit = wav_load(TUNERES+"exit.wav",true);
		snd_quit = wav_load(TUNERES+"quit.wav",true);
		audio_play_sound(b,0,true);
		}
	}
else
	{
	// Create buttons
	button[0] = instance_create_depth(640*0.5,		480*0.25,	-1, obj_button);
	button[1] = instance_create_depth(640*0.25,		480*0.5,	-1, obj_button);
	button[2] = instance_create_depth(640*0.75,		480*0.5,	-1, obj_button);
	button[3] = instance_create_depth(640*0.5,		480*0.75,	-1, obj_button);
	button[0].txt = "START GAME";
	button[1].txt = "GALLERY";
	button[2].txt = "UTILITIES";
	button[3].txt = "EXIT";
	}