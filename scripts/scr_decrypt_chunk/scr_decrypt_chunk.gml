///@desc Decrypts a SimTunes 'chunk', used in .tun files for preview image data and compression of note positions
function scr_decrypt_chunk(buffer,size){
var buffer_new = buffer_create(1,buffer_grow,1);
var offset = buffer_tell(buffer);
var size_final = 0;
while buffer_tell(buffer) < offset+size
	{
	var command = buffer_read(buffer,buffer_u8);
	
	// error mode
	if command < 1 then return -1;//buffer_read(buffer,buffer_u8); // invalid command, skip
	
	// repeat mode: reads data once, writes same data repeatedly
	if command > 0x7F //127
		{
		command = command & 0x7F;
		var data = buffer_read(buffer,buffer_u8);
		repeat command buffer_write(buffer_new,buffer_u8,data);
		}
		
	// standard mode: writes consecutive reads to the count of the first read
	else repeat command buffer_write(buffer_new,buffer_u8,buffer_read(buffer,buffer_u8));
	size_final += command;
	}
//trace("buffer written, size: "+string(buffer_get_size(minibuf)));
return {buffer_new,size_final};
}