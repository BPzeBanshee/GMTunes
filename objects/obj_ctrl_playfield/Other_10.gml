///@desc Event Functions
// Feather disable GM2016

mouse_create = function(obj){
if instance_exists(m)
	{
	m_prev = m.object_index;
	instance_destroy(m);
	}
m = instance_create_depth(mouse_x,mouse_y,depth-1,obj);
m.parent = id;
}

back_to_main = function(){
scr_trans(rm_main);
}
load_bkg = function(){
var f = get_open_filename_ext("Background File|*.BAC","",global.main_dir+"/BACKDROP","Load Background");
if string_length(f)>0
	{
	var s = bac_load(f);
	if sprite_exists(s)
		{
		sprite_delete(myback);
		myback = s;
		if sprite_exists(myback)
			{
			mybackname = filename_name(f);
			var bid = layer_background_get_id("lay_bkg");
			layer_background_blend(bid,c_white);
			layer_background_sprite(bid,myback);
			layer_background_xscale(bid,4);
			layer_background_yscale(bid,4);
			}
		}
	}
}
load_bug = function(bugzid,filename=""){
var mycolor,dir;
switch bugzid
	{
	case 0: mycolor = "Yellow"; dir=0; break;
	case 1: mycolor = "Green"; dir=90; break;
	case 2: mycolor = "Blue"; dir=180; break;
	case 3: mycolor = "Red"; dir=270; break;
	default: return -1;
	}
if filename == ""
filename = get_open_filename_ext("Bugz File|*.BUG","",global.main_dir+"/BUGZ",string("Load {0} Bug",mycolor));
if filename != ""
	{
	var mybug = bug_create(room_width*0.5,room_height*0.5,filename);
	mybug.direction = dir;
	mybug.gear = 3;
	mybug.timer = game_get_speed(gamespeed_fps) / 3;
	mybug.paused = paused;
	return mybug;
	}
return -2;
}

load_yellow = function(filename=""){
var mybug = load_bug(0,filename);
if instance_exists(mybug)
	{
	instance_destroy(bug_yellow);
	bug_yellow = mybug;
	return 0;
	}
}
load_green = function(filename=""){
var mybug = load_bug(1,filename);
if instance_exists(mybug)
	{
	instance_destroy(bug_green);
	bug_green = mybug;
	return 0;
	}
}
load_blue = function(filename=""){
var mybug = load_bug(2,filename);
if instance_exists(mybug)
	{
	instance_destroy(bug_blue);
	bug_blue = mybug;
	return 0;
	}
}
load_red = function(filename=""){
var mybug = load_bug(3,filename);
if instance_exists(mybug)
	{
	instance_destroy(bug_red);
	bug_red = mybug;
	return 0;
	}
}


place_flag = function(flag_id){
if mouse_y >= room_height or device_mouse_y_to_gui(0) > 416 then exit;
var xx = floor(mouse_x/16);
var yy = floor(mouse_y/16);
if xx == global.flag_list[flag_id,0] && yy == global.flag_list[flag_id,1]
	{
	global.flag_list[flag_id,2] += 90;
	if global.flag_list[flag_id,2] >= 360 global.flag_list[flag_id,2] = 0;
	}
else global.flag_list[flag_id,2] = 0;
global.flag_list[flag_id,0] = xx;
global.flag_list[flag_id,1] = yy;
}

rally_bugz_to_flags = function(){
var bugz = [bug_yellow,bug_green,bug_blue,bug_red];
for (var i=0;i<4;i++)
	{
	if global.flag_list[i,2] != -1 && bugz[i]
		{
		bugz[i].grabbed = false;
		bugz[i].warp = false;
		bugz[i].ctrl_x = -1;
		bugz[i].ctrl_y = -1;
		bugz[i].x = global.flag_list[i,0] * 16;
		bugz[i].y = global.flag_list[i,1] * 16;
		bugz[i].direction_p = global.flag_list[i,2];
		bugz[i].direction = global.flag_list[i,2];
		bugz[i].timer = 0;
		bugz[i].calculate_timer();
		}
	}
}

load_tun = function(){
var f = get_open_filename_ext("SimTunes .tun File (.tun)|*.TUN|SimTunes Gallery File (.gal)|*.GAL|GMTunes file (.gmtun)|*.GMTUN","",global.main_dir+"/TUNES","Load Savefile");
if string_length(f)>0
	{
	tun_load(f);
	field.update_surf();
	//field.update_ctrl_surf();
	}
}
load_gal = function(){
var f = get_open_filename_ext("SimTunes Gallery File (.gal)|*.GAL|SimTunes .tun File (.tun)|*.TUN|GMTunes file (.gmtun)|*.GMTUN","",global.main_dir+"/GALLERY","Load Savefile");
if string_length(f)>0
	{
	tun_load(f);
	field.update_surf();
	//field.update_ctrl_surf();
	}
}
save_tun = function(){
var f = get_save_filename_ext("GMTunes file (.gmtun)|*.GMTUN|SimTunes .tun File (.tun)|*.TUN","",global.main_dir+"/TUNES","Save Savefile");
if string_length(f)>0
	{
	trace(f);
	// Feather disable GM1017
	playfield_name = get_string("Playfield name: ",playfield_name);
	playfield_author = get_string("Playfield author: ",playfield_author);
	playfield_desc = get_string("Playfield description: ",playfield_desc);
	window_set_caption("GMTunes: "+string("{1} - {0}",playfield_author,playfield_name));
	tun_save(f);
	}
}

menu_bugz = function(){
instance_create_depth(x,y,depth,obj_menu_bugz);//-1
}

reset_playfield = function(hard=false){
ds_grid_clear(global.pixel_grid,0);
ds_grid_clear(global.ctrl_grid,0);
global.warp_list = [];
global.flag_list = [];

if hard
	{
	with obj_bug instance_destroy();
	var playfield = new default_playfield();
	tun_apply_data(playfield);
	}
else field.update_surf();
}