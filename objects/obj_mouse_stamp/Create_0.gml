// Inherit the parent event
event_inherited();
surf = -1;
grid_note = [];
grid_ctrl = [];
width = 0;
height = 0;
scale = 4;
size = 1;
clear_back = true;
move_mode = false;
loaded = false;

copy_x = -1;
copy_y = -1;
copy_w = 0;
copy_h = 0;

warp_starts = [];
warp_ends = [];
copy_flags = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]];
px = floor(x/16);
py = floor(y/16);

cursor_sprite = -1;