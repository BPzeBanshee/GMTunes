function bac_load(filehandle){
// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,filehandle,0);

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BACK format.");
    buffer_delete(bu);
	return -3;
    }
    
/// .BAC "BACK"  
var offset = 0;
var name = 0;
var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// Search until "BACK" is found (skip "SHOW" which is preview image)
do offset += 1 until buffer_word(bu,offset) == "BACK" || offset >= s2;

var size = buffer_peek_be32(bu,offset+4); // BACK follows u32 per RIFF specs
var eof = offset + size + 8;
//trace("BACK found, possible size: "+string(eof - offset));

buffer_seek(bu,buffer_seek_start,offset);
var spr = bitmap_load_from_buffer(bu);
buffer_delete(bu);
return spr;
}