// method list
prep = function(){
// some dicking around here to make ui work in playfield
var cam = view_camera[0];
cam_pos = [camera_get_view_x(cam),camera_get_view_y(cam)];
cam_siz = [camera_get_view_width(cam),camera_get_view_height(cam)];
camera_set_view_pos(cam,0,0);
camera_set_view_size(cam,640,480);

var o = obj_ctrl_playfield;
var bug_list = [o.bug_yellow,o.bug_green,o.bug_blue,o.bug_red];
for (var i=0;i<4;i++) 
	{
	// menu functions
	bug_index[i] = 0;
	bug_pos[i] = 0;
	
	// reinstate bug metadata
	bug_x[i] = -1;
	bug_y[i] = -1;
	bug_dir[i] = 0;
	bug_paused[i] = 0;
	bug_gear[i] = 0;
	bug_volume[i] = 0;
	
	if instance_exists(bug_list[i]) 
		{
		if bug_list[i].bugzid > 0 bug_index[i] = bug_list[i].bugzid - 1;
		bug_x[i] = bug_list[i].x;
		bug_y[i] = bug_list[i].y;
		bug_dir[i] = bug_list[i].direction;
		bug_paused[i] = bug_list[i].paused;
		bug_gear[i] = bug_list[i].gear;
		bug_volume[i] = bug_list[i].volume;
		//trace("bug index "+string(i)+" set to "+string(bug_index[i]));
		}
	}

with obj_button_dgui enabled = false;	

instance_deactivate_object(mouse_old);
instance_deactivate_object(o);
instance_deactivate_object(obj_bug);
instance_deactivate_object(obj_draw_playfield);
}

populate_list = function(list,filename){
var result = file_find_first(filename,fa_none);
while (result != "")
	{
    array_push(list, result);
	result = file_find_next();
	}
}

load_bug_metadata = function(filename){
// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,filename,0);

// FORM
// Faster than a buffer_word script check by *only* 5 cycles, but oh well
var test = "";
repeat 4 test += chr(buffer_read(bu,buffer_u8));
if test != "FORM"
	{
	msg("File doesn't match SimTunes BUGZ format.");
    return -2;
	}
buffer_read(bu,buffer_u32);
	
// "BUGZTYPE___x"
buffer_read(bu,buffer_u64);
buffer_read(bu,buffer_u32);
var bugztype = buffer_read_be16(bu); // Get bugz type (0: yellow, 1: green, 2: blue, 3: red)
//trace("BUGZTYPE: {0}",bugztype);

// "TEXT", container for name
var name = bug_load_text(bu);

// "INFO" (animation on note hit sprite)
var desc = bug_load_desc(bu);
desc = string_wordwrap_width(desc,400);

// SHOW
var show = bug_load_show(bu);

// DRUM
form_skip(bu);

// CODE
form_skip(bu);

// ANIM
var spr = bug_load_anim(bu);

while buffer_word(bu,buffer_tell(bu)) != "WAVE" form_skip(bu);

var sounds = bug_load_wave(bu,13);

// Free buffer
buffer_delete(bu);

return {name,desc,show,spr,sounds};
}

// variable init
done = false;
ready = false;
anim_index = 0; 
snd_index_x = 0;
snd_index_y = 0;
snd_count = 0;
back = -1;
select_a = 1;
select_am = 1;
dir = global.main_dir+"/BUGZ/";
mouse_old = obj_ctrl_playfield.m;
bug_index = [];
bug_pos = [];
list_yellow = [];
list_green = [];
list_blue = [];
list_red = [];
bug = [[]];
xx = 0; yy = 0;
loading_obj = instance_create_depth(0,0,depth-1,obj_loading);
loading_obj.txt = "Loading Bugz...";
alarm[0] = 1;