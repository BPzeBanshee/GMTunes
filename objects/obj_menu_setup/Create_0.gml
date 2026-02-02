

// External background
if global.use_external_assets
myback = bmp_load_sprite(TUNERES+"Setup.bmp",,,,,,,0,0);
	
// Misc stuff
draw_flash = 0;
ready = false;
exiting = false;

// Cursor stuff
mouse_old = noone;
if instance_exists(obj_ctrl_playfield) mouse_old = obj_ctrl_playfield.m;

// Fade in/out
loading_obj = instance_create_depth(0,0,depth-1,obj_loading);
alarm[1] = 1;

// Functions
#region function_calls
prep = function(){
// some dicking around here to make ui work in playfield
var cam = view_camera[0];
cam_pos = [camera_get_view_x(cam),camera_get_view_y(cam)];
cam_siz = [camera_get_view_width(cam),camera_get_view_height(cam)];
camera_set_view_pos(cam,0,0);
camera_set_view_size(cam,640,480);
	
with obj_button_dgui enabled = false;
with obj_button enabled = false;

instance_deactivate_object(mouse_old);
mymouse = instance_create_depth(0,0,depth-1,obj_mouse_parent);
instance_deactivate_object(obj_ctrl_playfield);
instance_deactivate_object(obj_bug);
instance_deactivate_object(obj_draw_playfield);
			
if instance_exists(obj_menu_main) audio_stop_sound(obj_menu_main.snd_menu);
}

flash = function(num){
draw_flash = num;
alarm[0] = 2;
}

exit_setup = function(){
exiting = true;
loading_obj = instance_create_depth(0,0,depth-1,obj_loading);
alarm[1] = 1;
}
#endregion