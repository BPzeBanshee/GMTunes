///@desc Create buttons/array list
loading = false;
over = false;

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
if surface_exists(surf)
	{
	surface_set_target(surf);
	for (var yy=0; yy<surface_get_height(surf); yy++)
		{
		draw_point_color(1,yy,make_color_hsv(arr[yy],255,255));
		arr[yy] += 4; if arr[yy] > 255 arr[yy] -= 255;
		}
	surface_reset_target();
	}
}
	
h[0] = 0; h2[0] = 0; h3[0] = 0; h4[0] = 0;
surf = init_surfpal(spr_shd_menu1,h);
surf2 = init_surfpal(spr_shd_menu2,h2);
surf3 = init_surfpal(spr_shd_menu3,h3);
surf4 = init_surfpal(spr_shd_menu4,h4);

start_game = function(){
loading = true;
alarm[0] = 1;
}

start_debug = function(){
room_goto(rm_debug_tools);
instance_destroy();
}

exit_game = function(){
game_end();
}

// Load sounds
var f1 = game_save_id+"TUNERES.DAT_ext/startup.WAV";

b = -1;
snd_play = -1;
snd_gal = -1;
snd_tut = -1;
snd_exit = -1;
snd_quit = -1;
if file_exists(f1)
	{
	trace(f1);
	b = wav_load(f1,true);
	snd_play = wav_load(game_save_id+"TUNERES.DAT_ext/play.wav",true);
	snd_gal = wav_load(game_save_id+"TUNERES.DAT_ext/gallery.wav",true);
	snd_tut = wav_load(game_save_id+"TUNERES.DAT_ext/tutorial.wav",true);
	snd_exit = wav_load(game_save_id+"TUNERES.DAT_ext/exit.wav",true);
	snd_quit = wav_load(game_save_id+"TUNERES.DAT_ext/quit.wav",true);
	audio_play_sound(b,0,true);
	}
	
// Load background
var f2 = game_save_id+"TUNERES.DAT_ext/Startup2.bmp";
if file_exists(f2)
	{
	bmp = bmp_load(f2);
	spr = sprite_create_from_surface(bmp,0,0,640,480,false,false,0,0);
	surface_free(bmp);
	}