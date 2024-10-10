function scr_main_init(){

// Macros
#macro trace show_debug_message
#macro msg show_message

// Function calls
surface_depth_disable(true);
audio_master_gain(0.5);
window_set_caption("GMTunes");
pal_swap_init_system(shd_pal_swapper,shd_pal_html_sprite,shd_pal_html_surface);

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

var config = environment_get_variable("LOCALAPPDATA")+"/VirtualStore/Windows/SimTunes.ini";
var savepath = "";
if file_exists(config)
	{
	ini_open(config);
	savepath = ini_read_string("FILE FOLDERS","mCustomSavePath","");
	trace(string("savepath returned {0}",savepath));
	ini_close();
	}
if savepath != ""
	{
	global.main_dir = string_replace(savepath,@"TUNES\","");
	trace("global.main_dir set to {0}",global.main_dir);
	}


// Font loading
var size = 10; // was 12
var fonts = ["FONTS/AVALONN.TTF","FONTS/AVALONB.TTF","FONTS/AVALONI.TTF","FONTS/AVALONT.TTF"];
var f;
for (var i=0;i<array_length(fonts);i++)
	{
	if file_exists(global.main_dir+fonts[i])
	then f = font_add(global.main_dir+fonts[i],size,false,false,32,127)
	else f = fnt_courier;
	switch i
		{
		case 0: global.fnt_default = f; break;
		case 1: global.fnt_bold = f; break;
		case 2: global.fnt_italic = f; break;
		case 3: global.fnt_bolditalic = f; break;
		}
	}
// TODO: work out the debug/small text fonts SimTunes uses
#macro TUNERES game_save_id+"/TUNERES.DAT_ext/"
if directory_exists(game_save_id+"/TUNERES.DAT_ext")
	{
	trace("Extracted folder already present, avoiding extra work");
	}
else
	{
	gmlzari_init();
	if file_exists(global.main_dir+"TUNERES.DAT")
		{
		var result = extract_dat(global.main_dir+"TUNERES.DAT");
		if result < 0
		then show_message("Failed to extract assets from TUNERES.DAT for some reason.\nGame will use placeholder assets only.");
		}
	else show_message("TUNERES.DAT not found.\nGame will use placeholder assets only or whatever is available in "+string(game_save_id+"/TUNERES.DAT_ext"));
	}
// TODO: load string table from SimTunes.dat

// Load note sprites
// NOTE: sprite_add_from_surface not used due to performance bug
global.use_int_spr = false;
global.spr_note2[0][0] = -1;
global.spr_flag2[0] = -1;

var temp = bmp_load(TUNERES+"TILES16.BMP");
if !surface_exists(temp) 
global.use_int_spr = true
else
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
if !surface_exists(temp2) 
global.use_int_spr = true
else
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
sprite_set_nineslice(global.spr_ui_txt,_nineslice);

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

global.spr_mouse = {copy: -1, cut: -1, magnify: -1,};
//global.spr_mouse.copy 

/*temp = bmp_load(game_save_id+"/TUNERES.DAT_ext/SELECTOR.BMP");
var c = sprite_create_from_surface(temp,0,0,32,32,true,false,0,0);
if sprite_exists(c) 
	{
	cursor_sprite = c;
	window_set_cursor(cr_none);
	surface_free(temp);
	}*/

instance_create_depth(x,y,0,obj_video_intro);
}