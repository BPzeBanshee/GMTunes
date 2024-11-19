/// @desc Opens a SimTunes LZARI container file, splits it out into it's file contents and decompresses them.
/// @param {string} filehandle File location
/// @param {bool} [remove_lzdir]=false Delete the LZARI file contents after decompression is done
/// @returns {real} Description
function extract_dat(filehandle,remove_lzdir=false){
// Get file
if !file_exists(filehandle) then return -1;

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,filehandle,0);

// There's no obvious formatting here because of compression/encryption
// so just prep some variables instead
var eob = buffer_get_size(bu);
var offset = 0;
var offset2 = 0;
    
// Offset for metadata table is at end of file, to be treated as a negative offset
buffer_seek(bu,buffer_seek_end,4);
var metadata_start = buffer_read(bu,buffer_u32);
//trace(string("metadata_start: {0}",metadata_start));
buffer_seek(bu,buffer_seek_end,metadata_start-4);

// Generate filename/offset table
var filenames = [];
var sizes = [];
var offsets = [];
while buffer_tell(bu) < eob-8
	{
	var str_size = buffer_read(bu,buffer_u32);
	var str = "";
	for (var i=0;i<str_size;i++) str += chr(buffer_read(bu,buffer_u8));
	array_push(filenames,str);
	array_push(sizes,buffer_read(bu,buffer_u32));
	array_push(offsets,buffer_read(bu,buffer_u32));
	}

/*trace("filenames: "+string(filenames));
trace("sizes: "+string(sizes));
trace("offsets: "+string(offsets));*/

var sandbox = game_save_id;//environment_get_variable("LOCALAPPDATA")+"/GMTunes/";
var infile = sandbox+"/"+filename_name(filehandle)+"_lz/";
var outfile = sandbox+"/"+filename_name(filehandle)+"_ext/";

if !directory_exists(infile) then directory_create(infile);
if !directory_exists(outfile) then directory_create(outfile);

var k;
for (var i=0;i<array_length(filenames);i++)
	{
	// Spit LZARI blobs to files...
	if i == array_length(filenames)-1 then k = metadata_start else k = offsets[i+1];
	buffer_save_ext(bu,infile+filenames[i]+".LZ",offsets[i],k-offsets[i]);
	
	// then convert them to their original formats using GMLZARI.DLL
	var result = gmlzari_decode_file(infile+filenames[i]+".LZ",outfile+filenames[i]);
	//trace("gmlzari_decode returned "+string(result));
	}

// clear buffer
buffer_delete(bu);
if remove_lzdir directory_destroy(infile);
return 0;
}


// This is for the SimTunes.dat that's inside TUNERES.dat, work that out later!
/*var num_strings = buffer_read(bu,buffer_u32) - 1;
trace("num_strings: "+string(num_strings));

buffer_read(bu,buffer_u32); // 2^16 = 65536, probably separator
buffer_read(bu,buffer_u16); // 0, probably separator too

var string_header = [];
for (var i=0;i<num_strings;i++)
	{
	string_header[i,0] = buffer_read(bu,buffer_u16); // 0
	string_header[i,1] = buffer_read(bu,buffer_u16); // string id
	string_header[i,2] = buffer_read(bu,buffer_u16); // string length
	string_header[i,3] = buffer_read(bu,buffer_u16); // offset
	}
trace(string_header);

var offset = buffer_tell(bu);

for (var i=0;i<array_length(string_header);i++)
	{
	buffer_seek(bu,buffer_seek_start,offset+string_header[i,2]);
	var sstr = buffer_read(bu,buffer_text);
	trace(sstr);
	}
}*/