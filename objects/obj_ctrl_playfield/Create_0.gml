// Variable init

// Playfield defaults
playfield_name = "";
playfield_author = "";
playfield_desc = "";

myback = -1;
mybackname = "";

tele_x = 0;
tele_y = 0;
tele_obj = [];
for (var i=0;i<4;i++) 
	{
	flag[i] = noone;
	//buf[i] = buffer_create(1,buffer_grow,1);
	//loadid[i] = -1;
	}
bug_yellow = noone;
bug_green = noone;
bug_blue = noone;
bug_red = noone;

global.pixel_grid = ds_grid_create(160,104);
global.ctrl_grid = ds_grid_create(160,104);
global.warp_list = [];
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