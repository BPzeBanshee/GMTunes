// Inherit the parent event
event_inherited();
zooming_in = true;
if global.zoom == 2 zooming_in = false;
if global.use_external_assets sprite_index = global.spr_ui.magnify;

// === Camera functions ===
zoom_in = function(){
if global.zoom > 1 then exit;
var cam = view_camera[0];
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);
var cx = x - (cam_w/4);
var cy = y - (cam_h/4);
camera_set_view_size(cam,cam_w/2,cam_h/2);
camera_set_view_pos(cam,cx,cy);
global.zoom += 1;
parent.update_camera();
}
zoom_out = function(){
if global.zoom < 1 exit;
var cam = view_camera[0];
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);
var cx = x - (cam_w);
var cy = y - (cam_h);
camera_set_view_size(cam,cam_w*2,cam_h*2);
camera_set_view_pos(cam,cx,cy);
global.zoom -= 1;
parent.update_camera();
}