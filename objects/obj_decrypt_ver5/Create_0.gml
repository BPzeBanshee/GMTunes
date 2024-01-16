event_inherited();
str_name = "";
str_author = "";
str_desc = "";
bkg_file = "";

surf = -1;
surf2 = -1;
newchunk = -1;
surf_scale = 1;

event_user(1);
image_xscale = string_width(str_desc)/2;
image_yscale = (string_height(str_desc) + (string_height(str_author)*2))/2;