/**
 * Reads a FourCC/"FORM" tag and it's big-endian length from a given buffer, then skips it
 * @param {Id.Buffer} buffer The buffer being parsed
 */
function form_skip(buffer){
var form = buffer_word(buffer,buffer_tell(buffer));
buffer_read(buffer,buffer_u32);
var skip = buffer_read_be32(buffer);
buffer_seek(buffer,buffer_seek_relative,skip);
if frac(buffer_tell(buffer)/2) != 0 then buffer_read(buffer,buffer_u8);
//trace("Skip form: {0}, length: {1}",form,skip);
return 0;
}