// Inherit the parent event
// Feather disable GM2016
event_inherited();

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
with obj_bug update_sprite();
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
with obj_bug update_sprite();
}