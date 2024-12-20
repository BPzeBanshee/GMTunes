/// @desc (Written by BPze) Returns a set of 4 characters from the given buffer's position
/// @param {id.Buffer} buffer the buffer
/// @param {real} position position to peek into buffer
/// @returns {string|real} the two char8s or error code -1
function buffer_word(buffer,position) {
	var size = buffer_get_size(buffer);
	if position+3 > size then return -1;
	if position+2 > size then return -1;
	if position+1 > size then return -1;
	if position > size then return -1;
	
	var a = position < size ? buffer_peek(buffer,position,buffer_u8) : 0;
	var b = position+1 < size ? buffer_peek(buffer,position+1,buffer_u8) : 0;
	var c = position+2 < size ? buffer_peek(buffer,position+2,buffer_u8) : 0;
	var d = position+3 < size ? buffer_peek(buffer,position+3,buffer_u8) : 0;

	return chr(a)+chr(b)+chr(c)+chr(d);
}

function buffer_word2(buffer,position){
	var size = buffer_get_size(buffer);
	var pos = buffer_tell(buffer);
	if pos+3 > size return -1;
	var str = "";
	repeat 4 str += chr(buffer_read(buffer,buffer_u8));
	buffer_seek(buffer,buffer_seek_relative,-4);
	return str;
}

function buffer_read_word(buffer){
	var size = buffer_get_size(buffer);
	var pos = buffer_tell(buffer);
	if pos+3 > size return -1;
	var str = "";
	repeat 4 str += chr(buffer_read(buffer,buffer_u8));
	//buffer_seek(buffer,buffer_seek_relative,-4);
	return str;
}