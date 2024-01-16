// Inherit the parent event
event_inherited();
surf = -1;
grid = -1;
width = 0;
height = 0;
scale = 16;

var f = get_open_filename("*.STP","");
if f != "" then load_stamp(f);