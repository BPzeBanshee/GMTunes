/// @desc .BUG/.BAC "SHOW" Decryption
var f = get_open_filename("*.BUG;*.BAC","");
if f == ""
	{
	instance_destroy();
	exit;//return -1;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    buffer_delete(bu);
    instance_destroy();
	exit;//return -2;
    }

var offset = 0;
//var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// Search until "SHOW" is found
do offset += 1 until buffer_word(bu,offset) == "SHOW" || offset >= s2;
buffer_seek(bu,buffer_seek_start,offset);
spr = bitmap_load_from_buffer(bu);
buffer_delete(bu);