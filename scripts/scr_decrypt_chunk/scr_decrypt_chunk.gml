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

function scr_encrypt_chunk_zlib(buffer){
var newbuf = buffer_compress(buffer,0,buffer_get_size(buffer));
if buffer_exists(newbuf) return newbuf;
return -1;
}

// TODO: reinvestigate this and make it actually work
/*function scr_encrypt_chunk(buffer,size){
if size == 0 return;
trace("scr_encrypt_chunk: size - {0}",size);
//var size = buffer_get_size(buffer);
var t = buffer_tell(buffer);
buffer_seek(buffer,buffer_seek_start,0);

var newbuf = buffer_create(size,buffer_fast,1);
var count = 1;
var stack = [];
for (var i=0;i<size;i++)
	{
	var data = buffer_peek(buffer,i,buffer_u8);
	var data_next = buffer_peek(buffer,i+1,buffer_u8);
	if (data_next == data)
		{
		if array_length(stack) > 0
			{
			buffer_write(newbuf,buffer_u8,array_length(stack));
			for (var j=0;j<array_length(stack);j++) buffer_write(newbuf,buffer_u8,stack[j]);
			stack = [];
			}
		count++;
		if count > 0x7F
			{
			buffer_write(newbuf,buffer_u8,0x7F+count);
			buffer_write(newbuf,buffer_u8,data);
			count = 1;
			}
		}
	else
		{
		if count > 1
			{
			buffer_write(newbuf,buffer_u8,0x7F+count+1);
			buffer_write(newbuf,buffer_u8,data);
			count = 1;
			}
		else array_push(stack,data);
		}
	}
buffer_seek(buffer,buffer_seek_start,t);
return newbuf;
}*/

function scr_encrypt_chunk(input_buffer) {
    buffer_seek(input_buffer,buffer_seek_start,0);

    var buffer_new = buffer_create(1, buffer_grow, 1);  // New buffer for the encoded data
    var offset = buffer_tell(input_buffer);  // Get the starting point in the input buffer
    var current_value = buffer_read(input_buffer, buffer_u8);  // Read the first byte
    var count = 1;
	
	var verbatim_numbers = [];
	var verbatim_count = 0;

    // Loop through the buffer, starting from the second byte
    while (buffer_tell(input_buffer) < buffer_get_size(input_buffer)) {
        var value = buffer_read(input_buffer, buffer_u8);  // Read the next byte

        // Check if the count exceeds 127 before incrementing it
        if (count > 127) {
            // Encode the current run with Repeat Mode (command > 127) before continuing
            var command = count + 0x7F;  // Set the high bit to indicate repeat mode
            buffer_write(buffer_new, buffer_u8, command);
            buffer_write(buffer_new, buffer_u8, current_value);  // Write the repeated value
            count = 1;  // Reset count after encoding the run
        }

        // If the current value is the same as the previous, increment the count
        if (value == current_value) {
            count += 1;
        } else {
            // Encode the current run of values (if count <= 127, use standard mode)
            if (count >= 3) {
                var command = count + 0x80;  // Set the high bit for repeat mode (for runs >= 3)
                buffer_write(buffer_new, buffer_u8, command);
                buffer_write(buffer_new, buffer_u8, current_value);
            } else {
                // For short sequences (less than 3), we just write the count and the value
                for (var i = 0; i < count; i++) {
                    buffer_write(buffer_new, buffer_u8, 1);  // Write count 1
                    buffer_write(buffer_new, buffer_u8, current_value);  // Write the value
                }
            }

            // Reset for the next run of values
            current_value = value;
            count = 1;
        }
    }

    // Handle the last accumulated run of values
    if (count >= 3) {
        var command = count + 0x80;  // Set the high bit for repeat mode (for runs >= 3)
        buffer_write(buffer_new, buffer_u8, command);
        buffer_write(buffer_new, buffer_u8, current_value);
    } else {
        for (var i = 0; i < count; i++) {
            buffer_write(buffer_new, buffer_u8, 1);  // Write count 1 for each non-repeating value
            buffer_write(buffer_new, buffer_u8, current_value);
        }
    }

    buffer_seek(input_buffer, buffer_seek_start, offset);
    return buffer_new;
}