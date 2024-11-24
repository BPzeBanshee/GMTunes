// TODO: better off handled via globalvar? game limited one bug per colour
bugztype = 0; //0-3 YELLOW/GREEN/BLUE/RED
bugzname = "";
bugzid = 0; //0-x
volume = 64;

paused = false;
grabbed = false;
muted = false;

warp_alt = false;

gear = 3;
timer = 0;
timer_max = timer;
speed_p = 0;
direction_p = 0;
speed = 0;
direction = 0;
image_speed = 0;
hit_last = noone;
var xx = floor((x+8)/16);
var yy = floor((y+8)/16);
hit_lastx = xx;
hit_lasty = yy;
hit_last_ctrl = noone;
anim_index = 0;
anim_playing = false;

// sprite bank (cardinal directions + 3 zoom levels)
spr_up = [[],[]];
//spr_down = [];
//spr_left = [];
//spr_right = [];
spr_notehit_tl[0] = -1;
spr_notehit_tr[0] = -1;
spr_notehit_bl[0] = -1;
spr_notehit_br[0] = -1;
spr_subimg = 0;

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
warp_1fc = false;

// sounds
snd_struct = {buf:[],snd:[]};
snd_last = -1;
note = 1;

// Movement
mask_index = spr_bug_mask;
if !place_snapped(16,16) then move_snap(16,16);

// Method functions
event_user(0);