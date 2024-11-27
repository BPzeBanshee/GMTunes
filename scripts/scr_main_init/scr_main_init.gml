function scr_main_init(){
// Macros
#macro trace show_debug_message
#macro msg show_message
#macro GAME_VERSION string("2 ({0}-{1}-{2})",date_get_year(GM_build_date),date_get_month(GM_build_date),date_get_day(GM_build_date))
#macro TUNERES game_save_id+"/TUNERES.DAT/"
#macro Web:TUNERES "/TUNERES.DAT/"
#macro vk_capslock 20
#macro vk_oem_minus 189
#macro vk_oem_equals 187
#macro vk_oem_comma 188
trace("GMTunes Build {0}",GAME_VERSION);

// Function calls
surface_depth_disable(true);
window_set_caption("GMTunes");
pal_swap_init_system(shd_pal_swapper,shd_pal_html_sprite,shd_pal_html_surface);

scr_config_load();
audio_master_gain(round(global.music_volume)/100);
gpu_set_texfilter(global.use_texfilter);
game_set_speed(global.target_framerate,gamespeed_fps);
instance_create_depth(x,y,-9999,obj_debug);

// Controller objects and globalvars
global.playfield = {}; // struct
global.note_grid = [];
global.ctrl_grid = [];
global.warp_list = [];
global.flag_list = [];
global.zoom = 0;
global.reverb_hack = false;

// Establishing program directory etc
//if GM_build_type == "run"
global.main_dir = working_directory+"/"
//else global.main_dir = program_directory+"/";
var load_video = false;
if os_type == os_windows
	{
	// Attempt to locate original SimTunes directory
	var success = false;
	var config = environment_get_variable("LOCALAPPDATA")+"/VirtualStore/Windows/SimTunes.ini";
	if file_exists(config)
		{
		ini_open(config);
		var savepath = ini_read_string("FILE FOLDERS","mCustomSavePath","");
		ini_close();
		trace(string("savepath returned {0}",savepath));
	
		if savepath != ""
			{
			global.main_dir = string_replace(savepath,@"TUNES\","");
			success = true;
			trace("global.main_dir set to {0}",global.main_dir);
			}
		}
	
	if !success
		{
		show_message("GMTunes was unable to find your SimTunes directory.\n\nPlease manually locate the SimTunes directory to load asset data, or hit 'Cancel' to operate using internal assets only.");
		var d = get_open_filename_ext("","","C:/","Locate SimTunes directory (pick any file)");
		if string_length(d) > 0 
			{
			global.main_dir = filename_path(d);
			trace("global.main_dir manually set to {0}",global.main_dir);
			}
		else
			{
			global.use_external_assets = false;
			}
		}
		
	if global.use_external_assets
		{
		// Extract TUNERES.DAT assets if possible
		if !directory_exists(TUNERES)
			{
			gmlzari_init();
			if file_exists(global.main_dir+"TUNERES.DAT")
				{
				var result = extract_lzari_dat(global.main_dir+"TUNERES.DAT",game_save_id,true);
				if result < 0 
					{
					show_message("Failed to extract assets from TUNERES.DAT for some reason.\nGame will use placeholder assets only.");
					global.use_external_assets = false;
					}
				else load_video = true;
				}
			else 
				{
				show_message("TUNERES.DAT not found.\nGame will use placeholder assets only.");
				global.use_external_assets = false;
				}
			}
		else 
			{
			trace("Extracted folder already present, avoiding extra work");
			load_video = true;
			}
		}
	}
	
// Font loading
scr_font_init();

// Sound loading
scr_snd_init();

// Load note sprites
scr_spr_init();

// TODO: load string table from SimTunes.dat
//scr_strtbl_init();

// Play intro graphics+video or just go straight to main room
if load_video == true
	{
	// Play intro graphics+video
	instance_create_depth(x,y,0,obj_video_intro);
	}
else 
	{
	//trace("No LZARI support here, defo gonna have to run internal assets only");
	room_goto(rm_main);
	}
}

function scr_config_load(){
ini_open(game_save_id+"/GMTunes.ini");
global.debug = ini_read_real("Core","debug",true);
global.use_external_assets = ini_read_real("Core","use_external_assets",true);
global.music_volume = ini_read_real("Core","music_volume",50);
global.use_texfilter = ini_read_real("Core","use_texture_filtering",false);
global.target_framerate = ini_read_real("Core","target_framerate",60);
//if os_type == os_operagx global.use_external_assets = false;

global.function_tile_clicks = ini_read_real("SimTunes","function_tile_clicks",false);
ini_close();
return 0;
}

function scr_config_save(){
ini_open(game_save_id+"/GMTunes.ini");
ini_write_real("Core","debug",global.debug);
if !ini_key_exists("Core","use_external_assets")
ini_write_real("Core","use_external_assets",global.use_external_assets);
ini_write_real("Core","music_volume",global.music_volume);
ini_write_real("Core","use_texture_filtering",global.use_texfilter);
ini_write_real("Core","target_framerate",global.target_framerate);

ini_write_real("SimTunes","function_tile_clicks",global.function_tile_clicks);
ini_close();
return 0;
}

function scr_font_init(){
// TODO: work out the debug/small text fonts SimTunes uses
global.fnt_default = fnt_internal_default;
global.fnt_italic = fnt_internal_italic;
global.fnt_bold = fnt_internal_bold;
global.fnt_bolditalic = fnt_internal_bolditalic;

if global.use_external_assets
	{
	var size = 10; // was 12
	var fonts = ["FONTS/AVALONN.TTF","FONTS/AVALONB.TTF","FONTS/AVALONI.TTF","FONTS/AVALONT.TTF"];
	for (var i=0;i<array_length(fonts);i++)
		{
		if file_exists(global.main_dir+fonts[i]) 
			{
			var f = font_add(global.main_dir+fonts[i],size,false,false,32,127);
			switch i
				{
				case 0: global.fnt_default = f; break;
				case 1: global.fnt_bold = f; break;
				case 2: global.fnt_italic = f; break;
				case 3: global.fnt_bolditalic = f; break;
				}
			}
		}
	}
}

function scr_snd_init(){
if !global.use_external_assets exit;
global.snd_ui = {};
for (var i=0;i<25;i++)
	{
	var fname = "0"+string_replace_all(string_format(i+1,2,0)," ","0")+".WAV";
	//trace(fname);
	global.snd_ui.beep[i] = wav_load(TUNERES+fname);
	}
global.snd_ui.zap = wav_load(TUNERES+"ZAP.WAV");
global.snd_ui.undo = wav_load(TUNERES+"UNDO.WAV");
global.snd_ui.menu[0] = wav_load(TUNERES+"POPDOWN.WAV");
global.snd_ui.menu[1] = wav_load(TUNERES+"POPUP.WAV");
global.snd_ui.switcher = wav_load(TUNERES+"SWITCHER.WAV");
global.snd_ui.button = wav_load(TUNERES+"BUTTON.WAV");
global.snd_ui.rclick = wav_load(TUNERES+"clk811.wav");
global.snd_ui.bclick = wav_load(TUNERES+"BCLICK.WAV");
global.snd_ui.gclick = wav_load(TUNERES+"GCLICK.WAV");
global.snd_ui.yclick = wav_load(TUNERES+"YCLICK.WAV");
}

function scr_spr_init(){
if !global.use_external_assets exit;

// NOTE: sprite_add_from_surface not used due to performance bug
global.spr_ui = {};
global.spr_note2[0][0] = -1;
global.spr_flag2[0][0][0] = -1;

// Color/Control Note blocks
var temp = bmp_load(TUNERES+"TILES16.BMP");
if surface_exists(temp) 
	{
	// load notes, first x line is non-color control notes
	for (var yy = 0; yy <= 25; yy++)
		{
		for (var xx = 0; xx < 15; xx++)
			{
			global.spr_note2[xx][yy] = sprite_create_from_surface(temp,16*xx,16*yy,16,16,false,false,0,0);
			}
		}
	surface_free(temp);
	}

// Restart Flags
for (var i=0;i<=2;i++)
	{
	var temp2 = bmp_load(TUNERES+"RESTART"+string(i)+".BMP");
	var ww = surface_get_width(temp2) / 4;
	if surface_exists(temp2) 
		{
		for (var j = 0; j < 4; j++)
		for (var k = 0; k < 4; k++)
			{
			global.spr_flag2[i][j][k] = sprite_create_from_surface(temp2,ww*k,ww*j,ww,ww,true,false,ww/2,ww/2);
			}
		surface_free(temp2);
		}
	}
	
// Restart Flags (Cursor edition)
var temp3 = bmp_load(TUNERES+"RESTART.BMP");
for (var yy=0;yy<4;yy++)
for (var xx=0;xx<4;xx++)
	{
	global.spr_ui.flags[yy][xx] = sprite_create_from_surface(temp3,14*xx,14*yy,14,14,true,false,7,7);
	}
surface_free(temp3);

// Loading Bar assets
global.spr_ui.txt = bmp_load_sprite(TUNERES+"edot4mc.bmp");
global.spr_ui.bar = bmp_load_sprite(TUNERES+"status.bmp");
var _nineslice = sprite_nineslice_create();
_nineslice.enabled = true;
_nineslice.left = 2;
_nineslice.right = 2;
_nineslice.top = 2;
_nineslice.bottom = 2;
//_nineslice.tilemode[nineslice_center] = nineslice_hide; 
if sprite_exists(global.spr_ui.txt) sprite_set_nineslice(global.spr_ui.txt,_nineslice);

global.spr_ui.desc = bmp_load_sprite(TUNERES+"Info.bmp",,,,,,,0,0);

// Playfield menu box
for (var i=0;i<5;i++)
	{
	global.spr_ui.menu[i] = bmp_load_sprite(TUNERES+"menu"+string(i+1)+".bmp",,,,,,,0,0);
	}

// UI Bug Boxes
global.spr_ui.bug = [[]];
var ui_bug = bmp_load(TUNERES+"STOPGO.BMP");
if surface_exists(ui_bug)
	{
	for (var i=0;i<4;i++)
		{
		global.spr_ui.bug[i][0] = sprite_create_from_surface(ui_bug,50*i,0,50,34,false,false,0,0);
		global.spr_ui.bug[i][1] = sprite_create_from_surface(ui_bug,50*i,34,50,34,false,false,0,0);
		}
	surface_free(ui_bug);
	}
else
	{
	ui_bug = surface_create(50,34);
	var colors = [c_yellow,c_lime,c_blue,c_red];
	for (var i=0;i<4;i++)
		{
		surface_set_target(ui_bug);
		draw_clear_alpha(colors[i],0.5);
		surface_reset_target();
		global.spr_ui.bug[i][0] = sprite_create_from_surface(ui_bug,0,0,50,34,false,false,0,0);
		global.spr_ui.bug[i][1] = global.spr_ui.bug[i][0];
		}
	surface_free(ui_bug);
	}

// UI Sliders
global.spr_ui.slider = [];
var ui_slider = bmp_load(TUNERES+"4SLIDER.BMP");
if surface_exists(ui_slider)
	{
	for (var i=0;i<4;i++)
		{
		global.spr_ui.slider[i] = sprite_create_from_surface(ui_slider,0,6*i,23,5,false,false,12,2);
		}
	surface_free(ui_slider);
	}
else
	{
	ui_slider = surface_create(23,5);
	var colors = [c_yellow,c_green,c_blue,c_red];
	for (var i=0;i<4;i++)
		{
		surface_set_target(ui_slider);
		draw_clear_alpha(colors[i],1);
		surface_reset_target();
		global.spr_ui.slider[i] = sprite_create_from_surface(ui_slider,0,0,23,5,false,false,12,2);
		}
	surface_free(ui_slider);
	}
	
// UI 'Highlights'
global.spr_ui.playnote = [];
var temp4 = bmp_load(TUNERES+"hilights.bmp");
if surface_exists(temp4)
	{
	for (var i=0;i<5;i++) 
		{
		global.spr_ui.playnote[i] = sprite_create_from_surface(temp4,91+(5*i),202,5,9,false,false,0,0);
		}
		
	global.spr_ui.chooser[0] = sprite_create_from_surface(temp4,90,160,20,20,false,false,0,0);
	global.spr_ui.chooser[1] = sprite_create_from_surface(temp4,90,180,20,20,false,false,0,0);
	
	global.spr_ui.onclick_top = sprite_create_from_surface(temp4,0,0,90,36,true,false,0,0);
	global.spr_ui.onclick_bottom = sprite_create_from_surface(temp4,0,37,90,28,true,false,0,0);
	global.spr_ui.onclick_flagrestart = sprite_create_from_surface(temp4,0,64,73,28,true,false,0,0);
	global.spr_ui.onclick_stopgo = sprite_create_from_surface(temp4,0,92,72,34,true,false,0,0);
	global.spr_ui.onclick_okcancel = sprite_create_from_surface(temp4,0,126,116,34,true,false,0,0);
	global.spr_ui.onclick_slider_left = sprite_create_from_surface(temp4,74,68,28,28,true,false,0,0);
	global.spr_ui.onclick_slider_right = sprite_create_from_surface(temp4,74,96,28,28,true,false,0,0);
	global.spr_ui.onclick_zap = sprite_create_from_surface(temp4,0,190,30,30,true,false,0,0);
	global.spr_ui.onclick_undo = sprite_create_from_surface(temp4,60,190,30,30,true,false,0,0);
	
	global.spr_ui.stamp_clearback[0] = sprite_create_from_surface(temp4,94,245,29,25,false,false,0,0);
	global.spr_ui.stamp_clearback[1] = sprite_create_from_surface(temp4,94,270,29,25,false,false,0,0);
	global.spr_ui.stamp_tilemode[0] = sprite_create_from_surface(temp4,94,295,29,25,false,false,0,0);
	global.spr_ui.stamp_tilemode[1] = sprite_create_from_surface(temp4,94,320,29,25,false,false,0,0);
	global.spr_ui.stamp_up = sprite_create_from_surface(temp4,92,47,16,7,false,false,0,0);
	global.spr_ui.stamp_down = sprite_create_from_surface(temp4,92,54,16,8,false,false,0,0);
	surface_free(temp4);
	}

// Mouse cursors
global.spr_ui.cursor = bmp_load_sprite(TUNERES+"SELECTOR.BMP",,,,,true,,0,0);
global.spr_ui.tweezer[0] = bmp_load_sprite(TUNERES+"TWEEZER0.BMP",,,,,true,,0,0);
global.spr_ui.tweezer[1] = bmp_load_sprite(TUNERES+"TWEEZER1.BMP",,,,,true,,0,0);
global.spr_ui.magnify = bmp_load_sprite(TUNERES+"MAGNIFY.BMP",,,,,true,,8,8);
global.spr_ui.move = bmp_load_sprite(TUNERES+"MOVE.BMP",,,,,true);
global.spr_ui.copy = bmp_load_sprite(TUNERES+"COPY.BMP",,,,,true);
global.spr_ui.tone = bmp_load_sprite(TUNERES+"TONE.BMP",,,,,true,,0,0);
global.spr_ui.gradient = bmp_load_sprite(TUNERES+"GRADIENT.BMP",,,,,true,,0,0);

var ctrl_files = ["Blank.bmp","LEFT.BMP","RIGHT.BMP","UTURN.BMP","EAST.BMP","SOUTH.BMP","WEST.BMP","NORTH.BMP","WARP.BMP","WARPOUT.BMP","RANDOM.BMP","NWEST.BMP","NEAST.BMP","SEAST.BMP","SWEST.BMP"];
for (var i=0;i<array_length(ctrl_files);i++)
	{
	global.spr_ui.ctrl[i] = bmp_load_sprite(TUNERES+ctrl_files[i],,,,,true,,0,0);
	}
window_set_cursor(cr_none);
}

function scr_main_free(){

if global.use_external_assets
	{
	// FREE EXTERNAL FONTS
	var external_fonts = [global.fnt_bold,global.fnt_bolditalic,
	global.fnt_italic,global.fnt_default];

	for (var i=0;i<array_length(external_fonts);i++)
		{
		font_delete(external_fonts[i]);
		}

	// FREE EXTERNAL SPRITES
	var external_sprites = [];
	
	// Add ui struct sprites to list
	var spr_ui_names = struct_get_names(global.spr_ui);
	for (var i=0;i<struct_names_count(global.spr_ui);i++)
		{
		var st = struct_get(global.spr_ui,spr_ui_names[i]);
		if is_array(st)
			{
			// nested array AKA: array of handles within array of handles
			if is_array(st[0])
				{
				for (var j=0;j<array_length(st);j++)
					{
					for (var k=0;k<array_length(st[j]);k++)
						{
						array_push(external_sprites,st[j][k]);
						}
					}
				}
			// just an array of handles
			else for (var j=0;j<array_length(st);j++)
				{
				array_push(external_sprites,st[j]);
				}
			}
		else array_push(external_sprites,st);
		}

	// add the playfield assets and hardcoded ui stuff
	for (var z=0;z<=2;z++)
		{
		for (var c=0;c<4;c++)
		for (var d=0;d<4;d++)
			{
			array_push(external_sprites,global.spr_flag2[z][c][d]);
			}
		}
	for (var yy = 0; yy <= 25; yy++)
		{
		for (var xx = 0; xx < 15; xx++)
			{
			array_push(external_sprites,global.spr_note2[xx][yy]);
			}
		}
		
	// finally, iterate through list and remove the lot
	for (var i=0;i<array_length(external_sprites);i++)
		{
		if sprite_exists(external_sprites[i]) sprite_delete(external_sprites[i]);
		}
	
	// and flag struct gone for garbage collector just in case
	delete global.spr_ui;
	
	// FREE EXTERNAL SOUNDS
	var external_sounds = [global.snd_ui.beep,global.snd_ui.zap,global.snd_ui.undo,global.snd_ui.menu];
	for (var i=0;i<array_length(external_sounds);i++)
		{
		if is_array(external_sounds[i])
			{
			for (var j=0;j<array_length(external_sounds[i]);j++)
				{
				if audio_exists(external_sounds[i][j]) audio_free_buffer_sound(external_sounds[i][j]);
				}
			}
		else 
			{
			if audio_exists(external_sounds[i]) audio_free_buffer_sound(external_sounds[i]);
			}
		}
		
	// and flag struct gone just in case
	delete global.snd_ui;
	
	// FREE EXTENSIONS
	gmlzari_free();
	gmlibsmacker_free();
	}
}