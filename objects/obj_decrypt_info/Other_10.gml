// Get file
var f = get_open_filename(".BUG","");
if f == ""
	{
	instance_destroy();
	return 0;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    instance_destroy();
    }
    
var offset = 0;
var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// "TEXT", container for name
if buffer_word(bu,offset) != "TEXT"
then do offset += 1 until buffer_word(bu,offset) == "TEXT" || offset >= s2;

var size,eof;
size = buffer_peek_be32(bu,offset+4);// 4 bytes after RIFF for filesize
eof = offset + size + 8;
trace("\\n");
trace("TEXT found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));

for (var i=offset+8;i<eof;i++) str_name += chr(buffer_peek(bu,i,buffer_u8));
trace(str_name);

// "INFO" (animation on note hit sprite)
if buffer_word(bu,offset) != "INFO"
then do offset += 1 until buffer_word(bu,offset) == "INFO" || offset >= s2;
    
// Establish size of file
size = buffer_peek_be32(bu,offset+4); // 4 bytes after RIFF for filesize
eof = offset + size + 8;
trace("INFO found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));

// Get description
for (var i=offset+8;i<eof;i++) str_desc += chr(buffer_peek(bu,i,buffer_u8));
trace(str_desc);
str_desc = string_wordwrap_width(str_desc,256,chr(10),false);

// Free buffer
buffer_delete(bu);