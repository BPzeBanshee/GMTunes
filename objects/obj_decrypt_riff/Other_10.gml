/// @description  .BUG RIFF WAVE file ripping

// Get file to rip sounds from
var f = get_open_filename_ext("*.BUG","",@"C:/SimTunes/SIMTUNES/BUGZ/","Load SimTunes .BUG...");
trace("f: "+string(f));

if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}
dir = filename_name(f);

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    instance_destroy();
	exit;//return -2;
    }
else trace(chr(10));
    
var offset = 0;
var name = 0;
var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// Search until "RIFF" is found
do offset += 1 until buffer_word(bu,offset) == "RIFF" || offset >= s2;
var size,eof;
do
    {
	buffer_seek(bu,buffer_seek_start,offset);
    // Establish size of file
    size = buffer_peek(bu,offset+4,buffer_u32); // size of file - 8, located 4 bytes after 'RIFF'
    eof = offset+4 + size;
    trace("RIFF found, offset: "+string(buffer_tell(bu))+", size: "+string(size)+", eof: "+string(eof));
	
	// rest of metadata confirms suspected format: 8bit 11025hz mono wavs
	// still, code could be useful later (ie modding, does SimTunes support higher quality samples?)
	/*var metadata = {
		wavetag: buffer_word(bu,offset+8) + buffer_word(bu,offset+12), // always gonna be 'WAVEfmt '
		wavetag_length: buffer_peek(bu,offset+16,buffer_u32),			// therefore this will be same
		format: buffer_peek(bu,offset+20,buffer_u16),		// 1: PCM
		channels: buffer_peek(bu,offset+22,buffer_u16),		// number of channels
		samplerate: buffer_peek(bu,offset+24,buffer_u32),	// samples per second (hz)
		samplerate2: buffer_peek(bu,offset+28,buffer_u32),	// (Sample Rate * BitsPerSample * Channels) / 8
		bps2: buffer_peek(bu,offset+32,buffer_u16),			// (BitsPerSample * Channels) / 8 - 1: 8 bit mono, 2:8 bit stereo/16 bit mono, 4: 16 bit stereo
		bps: buffer_peek(bu,offset+34,buffer_u16),			// bits per sample
		datatag: buffer_word(bu,offset+36),					// "data"
		datasize: buffer_peek(bu,offset+40,buffer_u32)		// size of data section
	}
	trace(string(metadata));*/
    
    // Copy binary data to buffer until filesize is reached
    buf[name] = buffer_create(size+8,buffer_fast,1);
    for (var i = 0; i < size; i++) 
		{
		buffer_write(buf[name],buffer_u8,buffer_read(bu,buffer_u8));
		}
    
    // Create buffer sounds from given buffer
    snd[name] = audio_create_buffer_sound(buf[name],buffer_u8,11025,44,size-44,audio_mono);
    name += 1;
    
    // Increment to the next file!
	offset = eof;
	
	// Seems to be some amount of padding 
	if offset < buffer_get_size(bu)
		{
		var oo = offset;
	    do offset += 1 until buffer_word(bu,offset) == "RIFF" || offset == s2;
		//offset += 4;
		trace("offset incremented by "+(string(offset - oo)));
		}
    }
until buffer_tell(bu) >= buffer_get_size(bu) or offset >= s2 || keyboard_check_pressed(vk_escape)==1;

buffer_delete(bu);