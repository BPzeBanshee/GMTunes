var f = get_open_filename(".BUG","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
	instance_destroy();
	exit;
    }
	
// FORM
var test = "";
repeat 4 test += chr(buffer_read(bu,buffer_u8));
if test != "FORM"
	{
	msg("File doesn't match SimTunes BUGZ format.");
    return -2;
	}
	
// "BUGZTYPE___x"
buffer_read(bu,buffer_u64);
buffer_read(bu,buffer_u32);
var bugztype = buffer_read(bu,buffer_u16); // Get bugz type (0: yellow, 1: green, 2: blue, 3: red)

// TEXT
form_skip(bu);

// INFO
form_skip(bu);

// SHOW
form_skip(bu);

// DRUM
form_skip(bu);

// CODE
form_skip(bu);

// ANIM (bug sprite)
trace("bug_create({0}): loading ANIM...",name);
spr = bug_load_anim(bu);

// STYL + LITE (note hit sprite)
trace("bug_create({0}): loading STYL...",name);
var styl = bug_load_styl(bu);
trace(styl);