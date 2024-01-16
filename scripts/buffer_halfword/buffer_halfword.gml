/// @desc (written by BPze) returns the following two char8s from the buffer
/// @param {id.Buffer} buffer The buffer to peek
/// @param {real} position The position to peek at
/// @returns {string|real} the two char8s or error code -1
function buffer_halfword(buffer,position) {
	if position+1 > buffer_get_size(buffer) then return -1;
	var a = buffer_peek(buffer,position,buffer_u8);
	var b = buffer_peek(buffer,position+1,buffer_u8);
	return chr(a)+chr(b);
}