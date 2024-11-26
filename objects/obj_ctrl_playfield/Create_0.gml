// Variable init
use_classic_gui = false;
if global.use_external_assets use_classic_gui = true;
clear_back = true;
draw_flash = false;
loading_prompt = false;
watch_mode = false;
watch_count = 0;
watch_target = noone;
callmethod = function(){};
paused = false;
show_menu = true;
menu = 0;
menu_y = 28;
dialog = -1; // Async Dialog result

play_index = 0;
play_handle = -1;

playfield_name = "";
playfield_author = "";
playfield_desc = "";

myback = -1;
mybackname = "";

tele_x = 0;
tele_y = 0;
tele_obj = [];

bug_yellow = noone;
bug_green = noone;
bug_blue = noone;
bug_red = noone;

global.note_grid = Array2(160,104);
global.ctrl_grid = Array2(160,104);
note_grid_prev1 = Array2(160,104);
ctrl_grid_prev1 = Array2(160,104);
note_grid_prev2 = [];
ctrl_grid_prev2 = [];

tun_apply_data(global.playfield);

field = instance_create_layer(0,0,"lay_playfield",obj_draw_playfield);
field.parent = id;

// Call method functions
event_user(0);

// Create mouse cursor
m = noone; m_prev = m; 
mouse_create(obj_mouse_parent); 

// Load preset stamps
pstamp = [];
pstamp_page = 0;
for (var i=0;i<100;i++)
	{
	pstamp[i] = stamp_load(global.main_dir+"PSTAMPS/PREST"+string(i+1)+".STP");
	
	/*var ww = surface_get_width(pstamp[i].surf);
	var hh = surface_get_height(pstamp[i].surf);
	var surf = pstamp[i].surf;
	pstamp[i].surf = sprite_create_from_surface(surf,0,0,ww,hh,false,false,0,0);
	surface_free(surf);*/
	}

// Load GUI images
if use_classic_gui
	{
	gui = {paint: -1,stamp: -1,explore: -1,bugz: -1,file: -1};
	gui.paint = bmp_load_sprite(TUNERES+"Paint.bmp",,,,,,,0,0);
	gui.stamp = bmp_load_sprite(TUNERES+"Stamp.bmp",,,,,,,0,0);
	gui.explore = bmp_load_sprite(TUNERES+"Auto.bmp",,,,,,,0,0);
	gui.bugz = bmp_load_sprite(TUNERES+"Bugz.bmp",,,,,,,0,0);
	gui.file = bmp_load_sprite(TUNERES+"File.bmp",,,,,,,0,0);
	}