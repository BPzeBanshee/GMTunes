function scr_main_init(){

// Macros
#macro trace show_debug_message
#macro msg show_message
#macro TUNERES game_save_id+"/TUNERES.DAT_ext/"
#macro Web:TUNERES "/TUNERES.DAT_ext/"

// Function calls
surface_depth_disable(true);
audio_master_gain(0.5);
window_set_caption("GMTunes");
pal_swap_init_system(shd_pal_swapper,shd_pal_html_sprite,shd_pal_html_surface);
global.use_external_assets = true;
//if os_type == os_operagx global.use_external_assets = false;


// Controller objects and globalvars
global.playfield = -1;
global.debug = true;
global.zoom = 0;
global.pixel_grid = -1;
global.ctrl_grid = -1;
instance_create_depth(x,y,-9999,obj_debug);

// Establishing program directory etc
if GM_build_type == "run"
global.main_dir = working_directory+"/"
else global.main_dir = program_directory+"/";

if os_type == os_windows
	{
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
			trace("global.main_dir set to {0}",global.main_dir);
			}
		}
	}
	
// Font loading
scr_font_init();

// Load note sprites
scr_spr_init();

if os_type == os_windows && global.use_external_assets 
	{
	// Extract TUNERES.DAT assets if possible
	if !directory_exists(TUNERES)
		{
		gmlzari_init();
		if file_exists(global.main_dir+"TUNERES.DAT")
			{
			var result = extract_dat(global.main_dir+"TUNERES.DAT");
			if result < 0
			then show_message("Failed to extract assets from TUNERES.DAT for some reason.\nGame will use placeholder assets only.");
			}
		else show_message("TUNERES.DAT not found.\nGame will use placeholder assets only or whatever is available in "+string(TUNERES));
		}
	else trace("Extracted folder already present, avoiding extra work");	
	
	// TODO: load string table from SimTunes.dat

	// Play intro graphics+video
	instance_create_depth(x,y,0,obj_video_intro);
	}
else 
	{
	//trace("No LZARI support here, defo gonna have to run internal assets only");
	room_goto(rm_main);
	}
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

function scr_spr_init(){
// NOTE: sprite_add_from_surface not used due to performance bug
global.spr_note2[0][0] = -1;
global.spr_flag2[0] = -1;

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

var temp2 = bmp_load(TUNERES+"RESTART2.BMP");
if surface_exists(temp2) 
	{
	for (var c = 0;c < 4; c++)
		{
		global.spr_flag2[c] = sprite_create_from_surface(temp2,48,48*c,48,48,true,false,24,24);
		}
	surface_free(temp2);
	}

// Loading Bar assets
global.spr_ui_txt = bmp_load_sprite(TUNERES+"edot4mc.bmp");
global.spr_ui_bar = bmp_load_sprite(TUNERES+"status.bmp");
var _nineslice = sprite_nineslice_create();
_nineslice.enabled = true;
_nineslice.left = 2;
_nineslice.right = 2;
_nineslice.top = 2;
_nineslice.bottom = 2;
//_nineslice.tilemode[nineslice_center] = nineslice_hide; 
if sprite_exists(global.spr_ui_txt) sprite_set_nineslice(global.spr_ui_txt,_nineslice);

global.spr_ui_desc = bmp_load_sprite(TUNERES+"Info.bmp",,,,,,,0,0);

// UI Bug Boxes
global.spr_ui_bug = [[]];
var ui_bug = bmp_load(TUNERES+"STOPGO.BMP");
if surface_exists(ui_bug)
	{
	for (var i=0;i<4;i++)
		{
		global.spr_ui_bug[i][0] = sprite_create_from_surface(ui_bug,50*i,0,50,34,false,false,0,0);
		global.spr_ui_bug[i][1] = sprite_create_from_surface(ui_bug,50*i,34,50,34,false,false,0,0);
		}
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
		global.spr_ui_bug[i][0] = sprite_create_from_surface(ui_bug,0,0,50,34,false,false,0,0);
		global.spr_ui_bug[i][1] = global.spr_ui_bug[i][0];
		}
	surface_free(ui_bug);
	}

// UI Sliders
global.spr_ui_slider = [];
var ui_slider = bmp_load(TUNERES+"4SLIDER.BMP");
if surface_exists(ui_slider)
	{
	for (var i=0;i<4;i++)
		{
		global.spr_ui_slider[i] = sprite_create_from_surface(ui_slider,0,6*i,23,5,false,false,12,2);
		}
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
		global.spr_ui_slider[i] = sprite_create_from_surface(ui_slider,0,0,23,5,false,false,12,2);
		}
	}

global.spr_ui = {};
global.spr_ui.cursor = bmp_load_sprite(TUNERES+"SELECTOR.BMP",,,,,true,,0,0);
global.spr_ui.tweezer = bmp_load_sprite(TUNERES+"TWEEZER0.BMP",,,,,true,,0,0);
global.spr_ui.tweezer2 = bmp_load_sprite(TUNERES+"TWEEZER1.BMP",,,,,true,,0,0);
global.spr_ui.magnify = bmp_load_sprite(TUNERES+"MAGNIFY.BMP",,,,,true,,8,8);
global.spr_ui.move = bmp_load_sprite(TUNERES+"MOVE.BMP",,,,,true);
global.spr_ui.copy = bmp_load_sprite(TUNERES+"COPY.BMP",,,,,true);
global.spr_ui.tone = bmp_load_sprite(TUNERES+"TONE.BMP",,,,,true,,0,0);
global.spr_ui.gradient = bmp_load_sprite(TUNERES+"GRADIENT.BMP",,,,,true,,0,0);

cursor_sprite = global.spr_ui.cursor;
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
		array_push(external_sprites,struct_get(global.spr_ui,spr_ui_names[i]));
		}

	// add the playfield assets and hardcoded ui stuff
	for (var a=0;a<4;a++)
		{
		array_push(external_sprites,global.spr_flag2[a]);
		array_push(external_sprites,global.spr_ui_bug[a][0]);
		array_push(external_sprites,global.spr_ui_bug[a][1]);
		array_push(external_sprites,global.spr_ui_slider[a]);
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
	var external_sounds = [];
	for (var i=0;i<array_length(external_sounds);i++)
		{
		if audio_exists(external_sounds[i]) 
			{
			audio_free_buffer_sound(external_sounds[i]);//.snd);
			//buffer_delete(external_sprites[i].buf);
			}
		}
	
	// FREE EXTENSIONS
	gmlzari_free();
	gmlibsmacker_free();
	}
}