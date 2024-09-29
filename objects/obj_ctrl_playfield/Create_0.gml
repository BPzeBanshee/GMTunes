playfield_name = "New playfield";
playfield_author = "New author";
playfield_desc = "This is a new playfield.";
window_set_caption("GMTunes: "+string("{1} - {0}",playfield_author,playfield_name));

menu = 0;

global.pixel_grid = ds_grid_create(160,104);
global.ctrl_grid = ds_grid_create(160,104);
global.warp_list = [];

global.zoom = 0;
tele_x = 0;
tele_y = 0;
tele_obj = [];
for (var i=0;i<4;i++) flag[i] = noone;

myback = -1;
paused = false;

// Dialog result
dialog = -1;

// Load Background
mybackname = "";
var bkg = global.main_dir+"BACKDROP/03GP4BT.BAC";
if bkg != "" && file_exists(bkg)
	{
	myback = bac_load(bkg);
	if sprite_exists(myback)
		{
		mybackname = filename_name(bkg);
		var bid = layer_background_get_id("lay_bkg");
		layer_background_blend(bid,c_white);
		layer_background_sprite(bid,myback);
		layer_background_xscale(bid,4);
		layer_background_yscale(bid,4);
		}
	}
field = instance_create_depth(0,0,100,obj_draw_playfield);
field.parent = id;

// Load Bugz
bug_yellow = noone;
bug_green = noone;//bug_create(room_width*0.5,room_height*0.5,global.main_dir+"BUGZ/GREEN04.BUG");
bug_blue = noone;
bug_red = noone;

// Call method functions
event_user(0);

// Create mouse cursor
m = noone;
m_prev = noone;
mouse_create(obj_mouse_colour); 

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