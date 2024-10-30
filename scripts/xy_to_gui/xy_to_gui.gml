///@desc Converts given x/y coordinates to Draw GUI-friendly 'gx,gy' struct 
///@param {Real} xx x co-ordinate
///@param {Real} yy y co-ordinate
///@returns {Struct} gx,gy
function xy_to_gui(xx,yy){
/*
credit to IndianaBones from GMC
https://forum.gamemaker.io/index.php?threads/convert-normal-x-and-y-to-gui-x-and-y.35386/
*/
// get xy values removed from camera view
var off_x = xx - camera_get_view_x(view_camera[0]); // x is the normal x position
var off_y = yy - camera_get_view_y(view_camera[0]); // y is the normal y position
       
// convert to percentage of camera size
var off_x_percent = off_x / camera_get_view_width(view_camera[0]);
var off_y_percent = off_y / camera_get_view_height(view_camera[0]);
      
// multiply by gui w/h and presto!
var gx = off_x_percent * display_get_gui_width();
var gy = off_y_percent * display_get_gui_height();
return {gx,gy};
}