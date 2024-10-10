// Get file
var f = get_open_filename(".BUG","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}

// Load into buffer
var bu = buffer_create(1024,buffer_grow,1);
buffer_load_ext(bu,f,0);

// FORM
var test = "";
repeat 4 test += chr(buffer_read(bu,buffer_u8));
if test != "FORM"
	{
	msg("File doesn't match SimTunes BUGZ format.");
    return -2;
	}
buffer_read(bu,buffer_u32);
	
// "BUGZTYPE___x"
buffer_read(bu,buffer_u64);
buffer_read(bu,buffer_u32);
var bugztype = buffer_read_be16(bu); // Get bugz type (0: yellow, 1: green, 2: blue, 3: red)
trace("BUGZTYPE: {0}",bugztype);

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
repeat 3 form_skip(bu);

// STYL
form_skip(bu);

// LITE
trace("bug_create({0}): loading LITE...",filename_name(f));
var anim = bug_load_lite(bu);
spr_notehit_tl = anim.spr_notehit_tl;
spr_notehit_tr = anim.spr_notehit_tr;
spr_notehit_br = anim.spr_notehit_br;
spr_notehit_bl = anim.spr_notehit_bl;
mode = 1;
//spr_notehit_sheet = sprite_create_from_surface(anim,0,0,surface_get_width(anim),surface_get_height(anim),false,false,0,0);
//surface_free(anim);

// Prepare window
sw = sprite_get_width(spr_notehit_tl[0]) * 2;
sh = sprite_get_height(spr_notehit_tl[0]) * 2;
image_xscale = sw;
image_yscale = sh;
