/// @desc .BUG/.BAC "SHOW" Decryption
var f = get_open_filename("*.BUG;*.BAC","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_read_word(bu) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    buffer_delete(bu);
    instance_destroy();
	exit;//return -2;
    }
buffer_read(bu,buffer_u32); // FORM size
buffer_read(bu,buffer_u32); // "BUGZ"
while buffer_word(bu,buffer_tell(bu)) != "SHOW" form_skip(bu);
spr = bitmap_load_from_buffer(bu);

// No need to deal with BACK or SORT, finish up here
buffer_delete(bu);