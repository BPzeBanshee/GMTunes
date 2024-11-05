event_inherited();
str_name = "";
str_author = "";
str_desc = "";
bkg_file = "";

surf = -1;
surf2 = -1;
oldchunk = buffer_create(1,buffer_grow,1);
newchunk = buffer_create(1,buffer_grow,1);
newchunk_enc = -1;
surf_scale = 1;

global.pixel_grid = [];
global.ctrl_grid = [];

event_user(0);
image_xscale = string_width(str_desc)/2;
image_yscale = (string_height(str_desc) + (string_height(str_author)*2))/2;