/// @desc Draws a rectangle with the 'outline' corrected to be within given coordinates.
/// @param {Real} x1 Top-left x
/// @param {Real} y1 Top-left y
/// @param {Real} x2 Bottom-left x
/// @param {Real} y2 Bottom-right y
function draw_rectangle_inline(x1,y1,x2,y2){
draw_rectangle(x1+1,y1+1,x2-1,y2-1,true);
return 0;
}

/// @desc Draws a rectangle with the 'outline' corrected to be within given coordinates. Also macro for color calls.
/// @param {Real} x1 Top-left x
/// @param {Real} y1 Top-left y
/// @param {Real} x2 Bottom-left x
/// @param {Real} y2 Bottom-right y
/// @param {Constant.Color} [color] Given color to use
function draw_rectangle_inline_c(x1,y1,x2,y2,color=c_white){
var c = draw_get_color();
draw_set_color(color);
draw_rectangle_inline(x1,y1,x2,y2);
draw_set_color(c);
return 0;
}