///@func buffer_peek_be32(buffer,position)
///@desc Returns a real value read from a big-endian 32-bit buffer 
///@param {Id.Buffer} buffer
///@param {Real} position
///@returns {Real}
function buffer_peek_be32(buffer,position) {
	// Cheers to Mike Daily for having a ready made solution for big-endian bullshit
	// (https://forum.yoyogames.com/index.php?threads/request-allow-changing-endianness-of-buffers.39535/)
	var value = buffer_peek(buffer,position,buffer_u8) << 24;
	value |= buffer_peek(buffer,position+1,buffer_u8) << 16;
	value |= buffer_peek(buffer,position+2,buffer_u8) << 8;
	value |= buffer_peek(buffer,position+3,buffer_u8);
	return value;
}

function buffer_read_be32(buffer){
	var value = buffer_read(buffer,buffer_u8) << 24;
	value |= buffer_read(buffer,buffer_u8) << 16;
	value |= buffer_read(buffer,buffer_u8) << 8;
	value |= buffer_read(buffer,buffer_u8);
	return value;
}

function buffer_peek_be16(buffer,position) {
	var value = buffer_peek(buffer,position,buffer_u8) << 8;
	value |= buffer_peek(buffer,position+1,buffer_u8);
	return value;
}

function buffer_read_be16(buffer) {
	var value = buffer_read(buffer,buffer_u8) << 8;
	value |= buffer_read(buffer,buffer_u8);
	return value;
}