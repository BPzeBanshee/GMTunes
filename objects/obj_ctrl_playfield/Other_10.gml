///@desc Event Functions
// Feather disable GM2016
button_click = function(){
if global.use_external_assets
audio_play_sound(global.snd_ui.button,0,false);
return 0;
}

///@desc Creates a mouse object
///@param {Asset.GMObject, Id.Instance} obj
mouse_create = function(obj){
if instance_exists(m)
	{
	m_prev = m.object_index;
	instance_destroy(m);
	}
m = instance_create_depth(mouse_x,mouse_y,depth-1,obj);
m.parent = id;
}
pick_note_color = function(i){
if !instance_exists(obj_mouse_colour)
	{
	instance_destroy(m);
	mouse_create(obj_mouse_colour); 
	}
m.note = i;
					
if global.use_external_assets
	{
	var snd = global.snd_ui.beep[i-1];
	switch play_index
		{
		case 1: if instance_exists(bug_yellow) snd = bug_yellow.snd_struct.snd[i-1]; break;
		case 2: if instance_exists(bug_green) snd = bug_green.snd_struct.snd[i-1]; break;
		case 3: if instance_exists(bug_blue) snd = bug_blue.snd_struct.snd[i-1]; break;
		case 4: if instance_exists(bug_red) snd = bug_red.snd_struct.snd[i-1]; break;
		default: break;
		}
	if audio_exists(play_handle) audio_stop_sound(play_handle);
	play_handle = audio_play_sound(snd,0,false);
	}
}
pick_note_ctrl = function(i){
button_click();
if !instance_exists(obj_mouse_ctrl)
	{
	instance_destroy(m);
	mouse_create(obj_mouse_ctrl); 
	}
m.note = i;
}
load_scale = function(){
global.key_scale++;
if global.key_scale > 10 global.key_scale = 0;
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
		if sprite_exists(myback) sprite_delete(myback);
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
if string_length(filename)>0
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
if directory_exists(global.main_dir+"/BUGZ")
instance_create_depth(x,y,depth,obj_menu_bugz)
else 
	{
	var b = instance_create_depth(x,y,depth,obj_menu_bugz_alt);
	b.parent = id;
	}
}
reset_playfield = function(hard=false){
record();
array_clear(global.note_grid,0,0,160,104,0);
array_clear(global.ctrl_grid,0,0,160,104,0);
global.warp_list = [];
global.flag_list = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]];

if hard
	{
	with obj_bug instance_destroy();
	var playfield = new default_playfield();
	tun_apply_data(playfield);
	}
field.update_surf();
if global.use_external_assets audio_play_sound(global.snd_ui.zap,0,false);
}
flash = function(value){
draw_flash = value;
alarm[1] = 2;
}
undo = function(){
note_grid_prev2 = variable_clone(global.note_grid);
ctrl_grid_prev2 = variable_clone(global.ctrl_grid);
global.note_grid = variable_clone(note_grid_prev1);
global.ctrl_grid = variable_clone(ctrl_grid_prev1);
note_grid_prev1	= variable_clone(note_grid_prev2);
ctrl_grid_prev1	= variable_clone(ctrl_grid_prev2);
field.update_surf();
//trace("Undo button pressed");
if global.use_external_assets audio_play_sound(global.snd_ui.undo,0,false);
}
record = function(){
note_grid_prev1 = variable_clone(global.note_grid);
ctrl_grid_prev1 = variable_clone(global.ctrl_grid);
note_grid_prev2	= variable_clone(note_grid_prev1);
ctrl_grid_prev2	= variable_clone(ctrl_grid_prev1);
}
zoom_in = function(){
if global.zoom > 1 then exit;
var cam = view_camera[0];
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);
var cx = camera_get_view_x(cam) - (cam_w/4);//x - (cam_w/4);
var cy = camera_get_view_y(cam) - (cam_h/4);//y - (cam_h/4);
camera_set_view_size(cam,cam_w/2,cam_h/2);
camera_set_view_pos(cam,cx,cy);
global.zoom += 1;
update_camera();
}
zoom_out = function(){
if global.zoom < 1 exit;
var cam = view_camera[0];
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);
var cx = camera_get_view_x(cam) - cam_w;//x - (cam_w);
var cy = camera_get_view_y(cam) - cam_h;//y - (cam_h);
camera_set_view_size(cam,cam_w*2,cam_h*2);
camera_set_view_pos(cam,cx,cy);
global.zoom -= 1;
update_camera();
}
start_watch_mode = function(){
if !watch_mode
	{
	watch_mode = true;
	repeat global.zoom zoom_out();
	m_prev = m.object_index;
	instance_destroy(m);
	alarm[2] = 60*5;
	}
return 0;
}
update_camera = function(){
var cam = view_camera[0];
var xform = room_width - camera_get_view_width(cam);
var yform = 0;
switch global.zoom
	{
	case 2: yform = 1664 - 416; break;
	case 1: yform = 1664 - (416*2); break;
	case 0: break;
	}
	
var cx,cy;
if instance_exists(watch_target)
&& global.zoom > 0
	{
	var xx = watch_target.x+8;
	var yy = watch_target.y+8;
	if !watch_target.paused
		{
		var dx = watch_target.x+8+lengthdir_x(16,watch_target.direction);
		var dy = watch_target.y+8+lengthdir_y(16,watch_target.direction);
		if watch_target.warp
			{
			dx = watch_target.ctrl_x+8;
			dy = watch_target.ctrl_y+8;
			}
		var t = max(0,watch_target.timer/watch_target.timer_max);
		xx = lerp(watch_target.x+8,dx,1-t);
		yy = lerp(watch_target.y+8,dy,1-t);
		}
	cx = xx - camera_get_view_width(cam)/2;
	cy = yy - camera_get_view_height(cam)/2;
	}
else
	{
	var xo = 0;
	var yo = 0;
	if keyboard_check(vk_left) or keyboard_check(ord("A")) then xo = -global.zoom*4;
	if keyboard_check(vk_right) or keyboard_check(ord("D")) then xo = global.zoom*4;
	if keyboard_check(vk_up) or keyboard_check(ord("W")) then yo = -global.zoom*4;
	if keyboard_check(vk_down) or keyboard_check(ord("S")) then yo = global.zoom*4;
	cx = camera_get_view_x(cam) + xo;
	cy = camera_get_view_y(cam) + yo;
	}
camera_set_view_pos(cam,clamp(cx,0,xform),clamp(cy,0,yform));
}