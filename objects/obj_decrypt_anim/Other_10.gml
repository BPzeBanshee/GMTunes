///@desc .bug ANIM load
var f = get_open_filename(".BUG","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}
var name = filename_name(f);

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_read_word(bu) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
	buffer_delete(bu);
	instance_destroy();
	exit;
    }
buffer_read(bu,buffer_u32);
	
// "BUGZTYPE___x"
buffer_read(bu,buffer_u64);
buffer_read(bu,buffer_u32);
var bugztype = buffer_read(bu,buffer_u16); // Get bugz type (0: yellow, 1: green, 2: blue, 3: red)

// skip TEXT, INFO, SHOW, DRUM and CODE
while buffer_word(bu,buffer_tell(bu)) != "ANIM"
	{
	form_skip(bu);
	}

// ANIM (bug sprite)
trace("bug_create({0}): loading ANIM...",name);
spr = bug_load_anim(bu);

// STYL + LITE (note hit sprite)
trace("bug_create({0}): loading STYL...",name);
var styl = bug_load_styl(bu);
trace(styl);