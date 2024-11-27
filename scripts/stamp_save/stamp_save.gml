///@desc Saves a SimTunes stamp struct to a file, picking format depending on given file extension.
///@param {Struct} mystruct
///@param {String} file
///@returns {Real} result
function stamp_save(mystruct,file){
// make sure we *have* a filename and data
if file == "" then return -2;
if !is_struct(mystruct) then return -1;

// then decide which format script to use
var result = 0;
trace("Saving stamp to "+string(file)+"...");
if string_lower(filename_ext(file)) == ".stp" result = stamp_save_stp(mystruct,file);
if string_lower(filename_ext(file)) == ".jstp" result = stamp_save_jstp(mystruct,file);

// and return the result code
return result;
}

function stamp_save_jstp(mystruct,file){
var myjson = json_stringify(mystruct,true);
var f = file_text_open_write(file);
file_text_write_string(f,myjson);
file_text_close(f);
return 0;
}

function stamp_save_stp(mystruct,file){
var buf_data = buffer_create(64,buffer_grow,1);

// write fourcc
buffer_write(buf_data,buffer_text,"STP2");

// write height, then width
buffer_write(buf_data,buffer_u32,mystruct.height);
buffer_write(buf_data,buffer_u32,mystruct.width);

// metadata
buffer_write(buf_data,buffer_u8,string_byte_length(mystruct.name));
buffer_write(buf_data,buffer_text,mystruct.name);
buffer_write(buf_data,buffer_u8,string_byte_length(mystruct.author));
buffer_write(buf_data,buffer_text,mystruct.author);
buffer_write(buf_data,buffer_u8,string_byte_length(mystruct.desc));
buffer_write(buf_data,buffer_text,mystruct.desc);

// Save pixel data
for (var yy = 0; yy < mystruct.height; yy++)
    {
    for (var xx = 0; xx < mystruct.width; xx++)
        {
		var data = mystruct.note_array[xx][yy];
		buffer_write(buf_data,buffer_u8,data);
        }
    }
	
// Save control data
for (var yy = 0; yy < mystruct.height; yy++)
    {
    for (var xx = 0; xx < mystruct.width; xx++)
        {
		var data = mystruct.ctrl_array[xx][yy];
		
		// (Flags in Stamps not supported by SimTunes)
		/*if data == 34
			{
			for (var i=0;i<4;i++)
				{
				if copy_flags[i][0] == xx
				&& copy_flags[i][1] == yy
				data = 252+i;
				}
			}*/
			
		buffer_write(buf_data,buffer_u8,data);
        }
    }
	
// bonus 4 bytes of nothing at the end
buffer_write(buf_data,buffer_u32,0);

// finally, save to file, then cleanup
buffer_save(buf_data,file);
buffer_delete(buf_data);
return 0;
}