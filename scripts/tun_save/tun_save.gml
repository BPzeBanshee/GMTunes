function tun_save(file){
// make sure we *have* a filename
if file == "" then return -2;

// then we gather the data

// Flag data
var myflags;
for (var i=0;i<4;i++)
	{
	if global.flag_list[i,2] != -1
		{
		var flag_dir = global.flag_list[i,2];
		myflags[i] = [round(global.flag_list[i,0]), round(global.flag_list[i,1]), flag_dir];
		}
	else myflags[i] = [-1, -1, -1];
	}
	
// Bugz structs
var mybugz = [bug_yellow,bug_green,bug_blue,bug_red];
var str;
for (var i=0;i<4;i++)
	{
	str[i] = new bug_struct();
	if mybugz[i] != noone
		{
		str[i].filename =	mybugz[i].bugzname;
		str[i].dir =		mybugz[i].direction;
		str[i].pos =		[mybugz[i].x,mybugz[i].y];
		str[i].ctrl =		[mybugz[i].ctrl_x,mybugz[i].ctrl_y];
		str[i].gear =		mybugz[i].gear;
		str[i].paused =		mybugz[i].paused;
		str[i].volume =		mybugz[i].volume;
		}
	}

// Generate the JSON file
var mystruct = {
	version: 1,
	name: playfield_name,
	author: playfield_author,
	desc: playfield_desc,
	preview_image: "",
	background: mybackname,//"",
	
	camera_pos: [round(x),round(y)],
	pixelsize: global.zoom, // SimTunes uses pixelsize 4,8,16, simplify here to 0-2
	warp_list: global.warp_list, //[xfrom,yfrom,xto,yto]
	flag_list: myflags, //[x,y,dir]
	note_list: global.pixel_grid, //[note,x,y]
	ctrl_list: global.ctrl_grid,
	bugz: {
		yellow: str[0],
		green: str[1],
		blue: str[2],
		red: str[3]
		}
	}

// then decide which format script to use
var result = 0;
trace("Saving playfield to "+string(file)+"...");
if string_lower(filename_ext(file)) == ".tun" result = tun_save_tun(mystruct,file);
if string_lower(filename_ext(file)) == ".gmtun" result = tun_save_gmtun(mystruct,file);

// and return the result code
return result;
}

/**
 * Saves the playfield in a JSON-based format.
 * @param {any} mystruct Playfield struct
 * @param {string} file String of the save file location
 * @returns {real} Return code (0: success)
 */
function tun_save_gmtun(mystruct,file){
var json = json_stringify(mystruct,true);
var f = file_text_open_write(file);
file_text_write_string(f,json);
file_text_close(f);
trace(file+" saved!");
return 0;
}

/**
 * Attempts to save the playfield in a SimTunes-compatible format.
 * @param {Struct.playfield_struct} mystruct Playfield struct
 * @param {String} file String of the save file location
 * @returns {Real} Return code (0: success)
 */
function tun_save_tun(mystruct,file)
{
if !is_struct(mystruct) return -1;

// First, some data manipulation due to how SimTunes decided on these things
// Camera
var pixelsize = 4;
switch mystruct.pixelsize
	{
	case 0: break;
	case 1: pixelsize = 8; break;
	case 2: pixelsize = 16; break;
	}
	
// Flag data
for (var i=0;i<4;i++)
	{
	var flag_dir = -1;
	switch mystruct.flag_list[i][2]
		{
		case 90: 
		default:	flag_dir = 0; break;
		case 0:		flag_dir = 1; break;
		case 270:	flag_dir = 2; break;
		case 180:	flag_dir = 3; break;
		}
	mystruct.flag_list[i][2] = flag_dir;
	}
	
// Preview picture data
var colortable = [0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,0x80,0x81,0x82,0x83,0x84,0x20,0x19,0x26,0x2F];
var preview_arr = Array2(160,104);
array_copy(preview_arr,0,mystruct.note_list,0,array_length(mystruct.note_list));
//preview_arr[(160*yy)+xx]
var preview_arr_enc = scr_rle_encode(preview_arr);
for (var i=0;i<array_length(preview_arr_enc);i++)
	{
	var data = preview_arr_enc[i];
	if data[1] > 0 preview_arr_enc[i][1] = colortable[data[1]-1];
	}

var preview_buf = buffer_create(8,buffer_grow,1);
for (var i=0;i<array_length(preview_arr_enc);i++)
	{
	var data = preview_arr_enc[i];
	buffer_write(preview_buf,buffer_u8,data[0]);
	buffer_write(preview_buf,buffer_u8,data[1]);
	// sequence
	/*if is_array(data[1])
		{
		buffer_write(preview_buf,buffer_u8,data[0]);
		for (var j=0;j<array_length(data[1]);j++)
			{
			buffer_write(preview_buf,buffer_u8,data[1][j]);
			}
		}
	// repeat
	else
		{
		buffer_write(preview_buf,buffer_u8,0x7F+data[0]);
		buffer_write(preview_buf,buffer_u8,data[1]);
		}*/
	}
buffer_set_used_size(preview_buf,buffer_tell(preview_buf));

// Note table data
var note_arr = [];
array_copy(note_arr,0,mystruct.note_list,0,array_length(mystruct.note_list));
var note_arr_enc = scr_rle_encode(note_arr);
var note_buf = buffer_create(8,buffer_grow,1);
for (var i=0;i<array_length(note_arr_enc);i++)
	{
	var data = note_arr_enc[i];
	buffer_write(note_buf,buffer_u8,data[0]);
	buffer_write(note_buf,buffer_u8,data[1]);
	}
var note_buf_size = buffer_tell(note_buf);
buffer_set_used_size(note_buf,note_buf_size);

// Control note data
var ctrl_arr = mystruct.ctrl_list;
var ctrl_arr_enc = scr_rle_encode(ctrl_arr);
var ctrl_buf = buffer_create(8,buffer_grow,1);
for (var i=0;i<array_length(ctrl_arr_enc);i++)
	{
	var data = ctrl_arr_enc[i];
	buffer_write(ctrl_buf,buffer_u8,data[0]);
	buffer_write(ctrl_buf,buffer_u8,data[1]);
	}
var ctrl_buf_size = buffer_tell(ctrl_buf);
buffer_set_used_size(ctrl_buf,ctrl_buf_size);

// ========= End data manipulation ============

// create our buffer to write data to
var bu = buffer_create(8,buffer_grow,1);

// write version string
buffer_write(bu,buffer_text,"VER5");

// write project name
var ps = string_length(mystruct.name)+1;
buffer_write(bu,buffer_u32,ps);
buffer_write(bu,buffer_text,mystruct.name);
buffer_write(bu,buffer_u8,0);

// garbage data #1
buffer_write(bu,buffer_u32,0);

// preview picture data
var preview_buf_size = buffer_tell(preview_buf);
trace("preview buf size: {0}",preview_buf_size);

buffer_write(bu,buffer_u32,preview_buf_size);
buffer_copy(preview_buf,0,preview_buf_size,bu,buffer_tell(bu));
buffer_delete(preview_buf);

buffer_seek(bu,buffer_seek_relative,preview_buf_size);
//if frac(buffer_tell(bu)/2)!=0 buffer_write(bu,buffer_u8,0);

// Author string
var author_str = mystruct.author;
var as = string_length(author_str)+1;
buffer_write(bu,buffer_u32,as);
buffer_write(bu,buffer_text,author_str);
buffer_write(bu,buffer_u8,0);

// Description string
var desc_str = mystruct.desc;
var ds = string_length(desc_str)+1;
buffer_write(bu,buffer_u32,ds);
buffer_write(bu,buffer_text,desc_str);
buffer_write(bu,buffer_u8,0);

// garbage data #2
repeat 7 buffer_write(bu,buffer_u32,0);

// background filename (taken from obj_ctrl_playfield background vars)
var back_str = mystruct.background;//"03GP4BT.BAC";
var bss = string_length(back_str)+1;
buffer_write(bu,buffer_u32,bss);
buffer_write(bu,buffer_text,back_str);
buffer_write(bu,buffer_u8,0);

// Camera/zoom positions
buffer_write(bu,buffer_u32,round(x));
buffer_write(bu,buffer_u32,round(y));
buffer_write(bu,buffer_u32,pixelsize);
buffer_write(bu,buffer_u32,mystruct.pixelsize);

// Mystery data
repeat 4 buffer_write(bu,buffer_u32,0);

// teleporter warp list
// SimTunes writes a fixed count of 61 with empty entries written as -1,
// but it DOES correctly read less
var num_warps = array_length(mystruct.warp_list);
buffer_write(bu,buffer_u32,num_warps);
if num_warps > 0 
for (var i=0; i<num_warps;i++)
	{
	// xfrom, yfrom, xto, yto
	// TODO: actually get warp positions from ctrl_grid
	var warp = [-1,-1,-1,-1];
	if i < array_length(mystruct.warp_list) warp = mystruct.warp_list[i];
	for (var j=0;j<4;j++) buffer_write(bu,buffer_s32,warp[j]);
	}
	
// Flag list
for (var i=0;i<4;i++)
	{
	buffer_write(bu,buffer_s32,mystruct.flag_list[i][0]);
	buffer_write(bu,buffer_s32,mystruct.flag_list[i][1]);
	buffer_write(bu,buffer_s32,mystruct.flag_list[i][2]);
	}
	
// Note position data
buffer_write(bu,buffer_u32,note_buf_size);
buffer_copy(note_buf,0,buffer_tell(note_buf),bu,buffer_tell(bu));
buffer_seek(bu,buffer_seek_relative,note_buf_size);
buffer_delete(note_buf);

// Control Note position data
buffer_write(bu,buffer_u32,ctrl_buf_size);
buffer_copy(ctrl_buf,0,buffer_tell(ctrl_buf),bu,buffer_tell(bu));
buffer_seek(bu,buffer_seek_relative,ctrl_buf_size);
buffer_delete(ctrl_buf);

// Global bug scale value
buffer_write(bu,buffer_u32,mystruct.pixelsize);

// mystery numbers + skip
repeat 3 buffer_write(bu,buffer_u32,0);

// Bugz metadata
var bugz = [mystruct.bugz.yellow,
mystruct.bugz.green,
mystruct.bugz.blue,
mystruct.bugz.red];
var bugzname_size = 0;

for (var i=0;i<4;i++)
	{
	bugzname_size = string_length(bugz[i].filename)+1;
	buffer_write(bu,buffer_u32,bugzname_size);
	buffer_write(bu,buffer_text,bugz[i].filename);
	buffer_write(bu,buffer_u8,0);
	
	// Camera scale / Absolute X/Y
	// Kludge this to just extrapolate from note x/y for now
	repeat 2 buffer_write(bu,buffer_u32,mystruct.pixelsize);
	buffer_write(bu,buffer_s32,round(bugz[i].pos[0]));
	buffer_write(bu,buffer_s32,round(bugz[i].pos[1]));
	
	// Note x/y positions
	buffer_write(bu,buffer_u32,round(bugz[i].pos[0]/16));
	buffer_write(bu,buffer_u32,round(bugz[i].pos[1]/16));
	var value = 0;
	switch bugz[i].dir
		{
		case 0: value = 1; break;
		case 270: value = 2; break;
		case 180: value = 3; break;
		default: break;
		}
	buffer_write(bu,buffer_u32,value);
	
	// error code (lets not make this more difficult than it needs to be)
	// TODO: mid-teleport code has stuff here
	repeat 4 buffer_write(bu,buffer_u32,0);
	
	// unknown bugz data #3, possibly tweezer related again?
	repeat 4 buffer_write(bu,buffer_u8,0);
	//buffer_write(bu,buffer_u8,16);
	//buffer_write(bu,buffer_u8,64);
	
	// misc. bugz metadata
	buffer_write(bu,buffer_u32,bugz[i].gear);
	buffer_write(bu,buffer_u32,bugz[i].paused);
	buffer_write(bu,buffer_u32,bugz[i].volume);
	}
	
buffer_write(bu,buffer_u32,0);
buffer_write(bu,buffer_u32,1); // ALIENEXP.GAL has 2 here but stuff in /TUNES is always 1?

// finally, save our buffer to file
buffer_save(bu,file);

// clean up data
buffer_delete(bu);
return 0;
}