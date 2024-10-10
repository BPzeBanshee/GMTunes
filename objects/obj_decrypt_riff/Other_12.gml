///@desc ev0, take 2

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

// FORM
var test = "";
repeat 4 test += chr(buffer_read(bu,buffer_u8));
if test != "FORM"
	{
	msg("File doesn't match SimTunes BUGZ format.");
    instance_destroy();
	exit;//return -2;
	}
buffer_read(bu,buffer_u32);
	
// "BUGZTYPE___x"
buffer_read(bu,buffer_u64);
buffer_read(bu,buffer_u32);
var bugztype = buffer_read_be16(bu); // Get bugz type (0: yellow, 1: green, 2: blue, 3: red)
trace("BUGZTYPE: {0}",bugztype);

while buffer_word(bu,buffer_tell(bu)) != "WAVE"
	{
	form_skip(bu);
	}
	
var snd_struct = bug_load_wave(bu);
snd = snd_struct.snd;
buf = snd_struct.buf;