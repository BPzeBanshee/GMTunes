// ref: https://www.foreui.com/articles/Key_Code_Table.htm
// corsair
/*
Corsair headset/keyboard:
volume up: 175
volume down: 174
mute: 173
stop: 178
prev track: 177
play/pause: 179
next track: 176
*/

///@desc Returns a value with a check against special keycode ranges (ie. volume up on custom keyboards)
///@param {Constant.VirtualKey|real} value
function keyboard_check_pressed_sane(value){
return (keyboard_check_pressed(value) && !in_range(keyboard_lastkey,150,187));
}
/// @param {real} value
/// @param {real} _min
/// @param {real} _max
function in_range(value,_min,_max){
return (value >= _min && value <= _max) ? true : false;
}