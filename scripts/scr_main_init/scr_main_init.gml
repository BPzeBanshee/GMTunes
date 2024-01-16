function scr_main_init(){

#macro trace show_debug_message
#macro msg show_message

// Establishing program directory etc
if GM_build_type=="run"
then global.main_dir = working_directory+"/"
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
var size = 12;
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
//trace(global.fnt_default);

// Controller objects
global.debug = true;
global.zoom = 0;
instance_create_depth(x,y,-9999,obj_debug);

gmlzari_init();
if file_exists(global.main_dir+"TUNERES.DAT")
	{
	var result = extract_dat(global.main_dir+"TUNERES.DAT");
	if result < 0
	then show_message("Failed to extract assets from TUNERES.DAT for some reason.\nGame will use placeholder assets only.");
	}
else show_message("TUNERES.DAT not found.\nGame will use placeholder assets only or whatever is available in "+string(game_save_id+"/TUNERES.DAT_ext"));
// TODO: load string table from SimTunes.dat
globalvar spr_note2,spr_note_ctrl2;
spr_note2 = -1;
spr_note_ctrl2 = -1;

var temp = bmp_load(game_save_id+"/TUNERES.DAT_ext/TILES16.BMP");
spr_note2 = sprite_create_from_surface(temp,0,16,16,16,false,false,0,0);
for (var ii=2;ii<=25;ii++)
	{
	sprite_add_from_surface(spr_note2,temp,0,16*ii,16,16,false,false);
	}
	
spr_note_ctrl2 = sprite_create_from_surface(temp,16,0,16,16,true,false,0,0);
for (var ii=2;ii<15;ii++)
	{
	sprite_add_from_surface(spr_note_ctrl2,temp,16*ii,0,16,16,true,false);
	}
surface_free(temp);

instance_create_depth(x,y,0,obj_intro);
}