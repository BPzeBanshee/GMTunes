// Inherit the parent event
event_inherited();

// Stamp struct vars
width = 0;
height = 0;
note_array = [];
ctrl_array = [];

// Handling of special control notes
warp_starts = [];
warp_ends = [];
copy_flags = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]];

// Mouse tool state/misc.
surf = -1;
scale = 4;
size = 1;
clear_back = true;
move_mode = false;
loaded = false;
copy_x = -1;
copy_y = -1;
copy_w = 0;
copy_h = 0;
px = floor(x/16);
py = floor(y/16);

// call event user 0 for binding methods
event_user(0);