///@desc Decrypts a SimTunes 'chunk', used in .tun files for preview image data and compression of note positions
function scr_decrypt_chunk(buffer,size){

var buf = buffer_create(1,buffer_grow,1);
var offset = buffer_tell(buffer);
var size_final = 0;
while buffer_tell(buffer) < offset+size
	{
	var command = buffer_read(buffer,buffer_u8);
	
	// error mode
	if command == 0 then return -1;//buffer_read(buffer,buffer_u8); // invalid command, skip
	
	// repeat mode
	if command > 0x7F
		{
		var rep = command & 0x7F; // MSB to 0 (I hope)
		var data_to_repeat = buffer_read(buffer,buffer_u8);
		//trace("repeating "+string(data_to_repeat)+" "+string(rep)+" times");
		repeat rep buffer_write(buf,buffer_u8,data_to_repeat);
		size_final += rep;
		}
		
	// verbatim mode
	if command > 0 && command <= 0x7f
		{
		//trace("writing "+string(command)+" bytes");
		repeat command buffer_write(buf,buffer_u8,buffer_read(buffer,buffer_u8));
		size_final += command;
		}
	}
//trace("buffer written, size: "+string(buffer_get_size(minibuf)));
return {buf,size_final};
}

// TODO: reinvestigate this and make it actually work
function scr_encrypt_chunk(buffer){
var size = buffer_get_size(buffer);
var t = buffer_tell(buffer);
buffer_seek(buffer,buffer_seek_start,0);

var buf = buffer_create(1,buffer_grow,1);
var data_last = -1;
var count = 0;
while buffer_tell(buffer) < size
	{
	var data = buffer_read(buffer,buffer_u8);
	if data == data_last
		{
		count++;
		}
	else
		{
		if count > 0x7F//128
			{
			buffer_write(buf,buffer_u8,count & 0x7F);
			buffer_write(buf,buffer_u8,data);
			count -= 0x7F;
			}
		else if count > 0
			{
			buffer_write(buf,buffer_u8,count);
			buffer_write(buf,buffer_u8,data);
			count = 0;
			}
		else
			{
			buffer_write(buf,buffer_u8,data_last);
			buffer_write(buf,buffer_u8,data);
			}
		
		}
	data_last = data;
	}
	
buffer_seek(buffer,buffer_seek_start,t);
return buf;
}