///@desc Loads a SimTunes stamp file into a struct
function stamp_load(file){
// File error checking
if !file_exists(file) then return -2;
trace("Loading stamp from "+string(file)+"...");

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
var hh = buffer_read(bu,buffer_u32);
var ww = buffer_read(bu,buffer_u32);
trace("Stamp dimensions: "+string(ww)+" x "+string(hh));

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
var note_array = Array2(ww,hh);
var ctrl_array = Array2(ww,hh);
for (var yy = 0; yy < hh; yy++)
for (var xx = 0; xx < ww; xx++)
	{
	note_array[xx][yy] = buffer_read(bu,buffer_u8);
	}
for (var yy = 0; yy < hh; yy++)
for (var xx = 0; xx < ww; xx++)
	{
	ctrl_array[xx][yy] = buffer_read(bu,buffer_u8);
	}
buffer_delete(bu);

// Generate Surface Image
var surf = surface_create(ww,hh);
surface_set_target(surf);
draw_clear_alpha(c_black,0);

// Draw 'stamp'
for (var yy = 0; yy < hh; yy++)
    {
    for (var xx = 0; xx < ww; xx++)
        {
		var data = note_array[xx][yy];
		if data > 0 draw_sprite_part(spr_note,data-1,0,0,1,1,xx,yy);
        }
    }
surface_reset_target();

return {name,author,desc,note_array,ctrl_array,surf};
}