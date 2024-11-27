function stamp_struct() constructor {
	name = "";
	author = "";
	desc = "";
	width = 0;
	height = 0;
	note_array = [];
	ctrl_array = [];
}

///@desc Loads a SimTunes stamp file into a struct
///@param {String} file
///@returns {Struct.stamp_struct, Real} result
function stamp_load(file){
// File error checking
if !file_exists(file) or file == "" then return -2;
trace("Loading stamp from "+string(file)+"...");

// Load file using given routines based on file extension
var e = filename_ext(file);
var mystruct;
if string_lower(e) == ".stp" mystruct = stamp_load_stp(file);
if string_lower(e) == ".jstp" mystruct = stamp_load_jstp(file);

// Result error checking
if is_struct(mystruct) return mystruct;
return -1;
}

function stamp_load_jstp(file){
var f = buffer_load(file);
var mystruct = json_parse(buffer_read(f,buffer_text));
buffer_delete(f);
//trace(file+" loaded!");
// Result error checking
if is_struct(mystruct) return mystruct;
return -1;
}

function stamp_load_stp(file){
// Load file into buffer
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,file,0);

// More error checking
var form = buffer_read_word(bu);
if form != "STP2"
    {
    msg("File doesn't match SimTunes STP2 format.");
    return -3;
    }
	
// Width/Height values
var height = buffer_read(bu,buffer_u32);
var width = buffer_read(bu,buffer_u32);
//trace("Stamp dimensions: "+string(width)+" x "+string(height));

// Name
var name = "";
var name_length = buffer_read(bu,buffer_u8);
if name_length > 0 repeat name_length name += chr(buffer_read(bu,buffer_u8));

// Author
var author = "";
var author_size = buffer_read(bu,buffer_u8);
if author_size > 0 repeat author_size author += chr(buffer_read(bu,buffer_u8));

// Description
var desc = "";
var desc_size = buffer_read(bu,buffer_u8);
if desc_size > 0 repeat desc_size desc += chr(buffer_read(bu,buffer_u8));

// Note data
var note_array = Array2(width,height);
var ctrl_array = Array2(width,height);
for (var yy = 0; yy < height; yy++)
for (var xx = 0; xx < width; xx++)
	{
	note_array[xx][yy] = buffer_read(bu,buffer_u8);
	}
for (var yy = 0; yy < height; yy++)
for (var xx = 0; xx < width; xx++)
	{
	ctrl_array[xx][yy] = buffer_read(bu,buffer_u8);
	}
buffer_delete(bu);

var mystruct = new stamp_struct();
mystruct.name = name;
mystruct.author = author;
mystruct.desc = desc;
mystruct.width = width;
mystruct.height = height;
mystruct.note_array = note_array;
mystruct.ctrl_array = ctrl_array;
return mystruct;
}