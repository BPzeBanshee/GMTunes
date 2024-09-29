///@desc Event Functions
// Feather disable GM2016

mouse_create = function(obj){
if instance_exists(m)
	{
	m_prev = m.object_index;
	instance_destroy(m);
	}
m = instance_create_depth(mouse_x,mouse_y,50,obj);
m.parent = id;
}

back_to_main = function(){
room_goto(rm_main);
}
load_bkg = function(){
var f = get_open_filename_ext("Background File|*.BAC","",global.main_dir+"/BACKDROP","Load Background");
if f != ""
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
var col = collision_point(mouse_x,mouse_y,flag[flag_id],false,false);
if col
	{
	col.direction += 90;
	col.image_angle = col.direction;
	}
else
	{
	if instance_exists(flag[flag_id]) then instance_destroy(flag[flag_id]);
	
	flag[flag_id] = instance_create_depth(mouse_x,mouse_y,98,obj_flag);
	flag[flag_id].flagtype = flag_id;
	flag[flag_id].image_index = flag_id;
	if !global.use_int_spr then flag[flag_id].sprite_index = global.spr_flag2[flag_id];
	}
}

rally_bugz_to_flags = function(){
var bugz = [bug_yellow,bug_green,bug_blue,bug_red];
for (var i=0;i<4;i++)
	{
	if flag[i] && bugz[i]
		{
		bugz[i].grabbed = false;
		bugz[i].warp = false;
		bugz[i].ctrl_x = -1;
		bugz[i].ctrl_y = -1;
		bugz[i].x = flag[i].x;
		bugz[i].y = flag[i].y;
		bugz[i].direction_p = flag[i].direction;
		bugz[i].direction = flag[i].direction;
		bugz[i].timer = 0;
		bugz[i].calculate_timer();
		}
	}
}

load_tun = function(){
var f = get_open_filename_ext("SimTunes .tun File (.tun)|*.TUN|SimTunes Gallery File (.gal)|*.GAL|GMTunes file (.gmtun)|*.GMTUN","",global.main_dir+"/GALLERY","Load Savefile");
if f != ""
	{
	tun_load(f);
	field.update_surf();
	//field.update_ctrl_surf();
	}
}
save_tun = function(){
var f = get_save_filename_ext("SimTunes .tun File (.tun)|*.TUN|GMTunes file (.gmtun)|*.GMTUN","",global.main_dir+"/TUNES","Save Savefile");
if f != ""
	{
	// Feather disable GM1017
	playfield_name = get_string("Playfield name: ",playfield_name);
	playfield_author = get_string("Playfield author: ",playfield_author);
	playfield_desc = get_string("Playfield description: ",playfield_desc);
	window_set_caption("GMTunes: "+string("{1} - {0}",playfield_author,playfield_name));
	tun_save(f);
	}
}