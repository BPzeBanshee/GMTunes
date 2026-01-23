// This is for the SimTunes.dat that's inside TUNERES.dat, work that out later!
function scr_strtbl_init(dat_file){
// Get file
if !file_exists(dat_file) then return -1;

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,dat_file,0);

// number of strings (u32/16 debatable)
var num_strings = buffer_read(bu,buffer_u32) - 1;
trace("num_strings: "+string(num_strings));

// some kind of initial data/default first entry/separator?
// not needed anyway, 2^16 = 65536
repeat 2 buffer_read(bu,buffer_u32); 

// Load string table data
var string_table = [];
for (var i=0;i<num_strings;i++)
	{
	string_table[i,0] = buffer_read(bu,buffer_u16); // string id
	string_table[i,1] = buffer_read(bu,buffer_u16); // string length
	string_table[i,2] = buffer_read(bu,buffer_u16); // offset
	buffer_read(bu,buffer_u16); // 00 padding
	}
//trace("String table data: "+string(string_table));

// Use string offset and length to read string table
var offset = buffer_tell(bu);
for (var i=0;i<num_strings;i++)
	{
	var sstr = "";
	buffer_seek(bu,buffer_seek_start,offset+string_table[i,2]);
	repeat string_table[i,1] sstr += chr(buffer_read(bu,buffer_u8));
	string_table[i,3] = sstr;
	}
	
// Now that we have everything, clean up our buffer work
buffer_delete(bu);
	
//trace("Final string info: "+string(string_table));
return string_table;
}