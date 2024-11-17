function bac_load(filehandle,loadall=false){
// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,filehandle,0);

if buffer_read_word(bu) != "FORM"
    {
    msg("File doesn't match SimTunes BACK format.");
    buffer_delete(bu);
	return -3;
    }
buffer_read(bu,buffer_u32); // skip filesize
buffer_read(bu,buffer_u32); // "BUGZ"

if loadall
	{
	// "TEXT"
	buffer_read(bu,buffer_u32); // skip form code
	var len = buffer_read_be32(bu);
	var name = "";
	repeat len name += chr(buffer_read(bu,buffer_u8));
	if frac(buffer_tell(bu)/2)!= 0 buffer_read(bu,buffer_u8);

	// "INFO"
	buffer_read(bu,buffer_u32); // skip form code
	len = buffer_read_be32(bu);
	var desc = "";
	repeat len desc += chr(buffer_read(bu,buffer_u8));
	if frac(buffer_tell(bu)/2)!= 0 buffer_read(bu,buffer_u8);

	// "SHOW"
	var show = bitmap_load_from_buffer(bu);
	
	// "BACK"
	var back = bitmap_load_from_buffer(bu);
	
	buffer_read(bu,buffer_u32); // "SORT"
	var sortnum = buffer_read_be16(bu);
	trace("SORT value: {0}",sortnum);
	
	buffer_delete(bu);
	return {name,desc,show,back,sortnum};
	}
else
	{
	while buffer_word(bu,buffer_tell(bu)) != "BACK" form_skip(bu);
	var spr = bitmap_load_from_buffer(bu);
	buffer_delete(bu);
	return spr;
	}
}