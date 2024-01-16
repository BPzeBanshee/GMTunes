// TODO: better off handled via globalvar? game limited one bug per colour
bugztype = 0; //0-3 YELLOW/GREEN/BLUE/RED
bugzname = "";
bugzid = 0; //0-x
volume = 8;

paused = false;
grabbed = false;
muted = false;

gear = 3;
timer = 0;
timer_max = timer;
speed_p = 0;
direction_p = 0;
speed = 0;
direction = 0;
image_speed = 0;
hit_last = noone;
hit_lastx = -1;
hit_lasty = -1;
hit_last_ctrl = noone;
anim_index = 0;
anim_playing = false;

// sprite bank (cardinal directions + 3 zoom levels)
spr_up = [];
//spr_down = [];
//spr_left = [];
//spr_right = [];
spr_notehit_tl = -1;
spr_notehit_tr = -1;
spr_notehit_bl = -1;
spr_notehit_br = -1;

ltxy_data = [];
ltxy_mode = 0; 
ltxy_frame = 0;
ltxy_x = 0;
ltxy_y = 0;

ltcc_data = [];
ltcc_blend = c_white;

ctrl_x = -1;
ctrl_y = -1;
ctrl_spd = -1;
warp = false;

// sounds
snd_struct = {buf:[],snd:[]};
snd_last = -1;
note = 1;

// Movement
mask_index = spr_bug_mask;
if !place_snapped(16,16) then move_snap(16,16);

// Method functions
event_user(0);