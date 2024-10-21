// Variable init
use_classic_gui = false;
if global.use_external_assets use_classic_gui = true;
loading_prompt = false;
callmethod = function(){};

// Playfield defaults
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

global.pixel_grid = ds_grid_create(160,104);
global.ctrl_grid = ds_grid_create(160,104);
global.warp_list = [];
global.flag_list = [];
global.zoom = 0;

menu = 0;
paused = false;
dialog = -1; // Async Dialog result

tun_apply_data(global.playfield);

field = instance_create_depth(0,0,100,obj_draw_playfield);
field.parent = id;

// Call method functions
event_user(0);

// Create mouse cursor
m = noone;
m_prev = noone;
mouse_create(obj_mouse_colour); 

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
else
	{
	// First, array list
	txta = []; evt = [];
	array_push(txta,"BUG Y");		array_push(evt,load_yellow);
	array_push(txta,"BUG G");		array_push(evt,load_green);
	array_push(txta,"BUG B");		array_push(evt,load_blue);
	array_push(txta,"BUG R");		array_push(evt,load_red);
	array_push(txta,".TUN");		array_push(evt,load_tun);
	array_push(txta,".BKG");		array_push(evt,load_bkg);
	array_push(txta,".STP");		array_push(evt,function(){mouse_create(obj_mouse_stamp);});
	array_push(txta,"GRAB");		array_push(evt,function(){mouse_create(obj_mouse_grab);});
	array_push(txta,"CTRL");		array_push(evt,function(){mouse_create(obj_mouse_ctrl);});
	array_push(txta,"CLR");			array_push(evt,function(){mouse_create(obj_mouse_colour);});
	array_push(txta,"RBW");			array_push(evt,function(){mouse_create(obj_mouse_rainbow);});
	array_push(txta,"Z");			array_push(evt,function(){mouse_create(obj_mouse_zoom);});
	array_push(txta,"X");			array_push(evt,back_to_main);

	// Create buttons
	for (var i=0; i<array_length(txta); i++)
	    {
	    button[i] = instance_create_depth(16+(i*48),480-16,-1,obj_button_dgui);
	    button[i].txt = txta[i];
	    }
	}