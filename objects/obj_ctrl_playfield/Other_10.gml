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
else field.update_surf();
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
	var	lx = lerp(watch_target.x+8,watch_target.x+8+lengthdir_x(16,watch_target.direction),1-(watch_target.timer/watch_target.timer_max));
	var	ly = lerp(watch_target.y+8,watch_target.y+8+lengthdir_y(16,watch_target.direction),1-(watch_target.timer/watch_target.timer_max));
	cx = lx - camera_get_view_width(cam)/2;
	cy = ly - camera_get_view_height(cam)/2;
	}
else
	{
	var xo = 0;
	var yo = 0;
	if keyboard_check(vk_left) or keyboard_check(ord("A")) then xo = -global.zoom*4;
	if keyboard_check(vk_right) or keyboard_check(ord("D")) then xo = global.zoom*4;
	if keyboard_check(vk_up) or keyboard_check(ord("W")) then yo = -global.zoom*4;
	if keyboard_check(vk_down) or keyboard_check(ord("S")) then yo = global.zoom*4;
	var cx = camera_get_view_x(cam) + xo;
	var cy = camera_get_view_y(cam) + yo;
	}
camera_set_view_pos(cam,clamp(cx,0,xform),clamp(cy,0,yform));
}