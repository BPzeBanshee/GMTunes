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
		myflags[i] = [round(global.flag_list[i,0]/16), round(global.flag_list[i,1]/16), flag_dir];
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
var myzoom = 4;
switch global.zoom
	{
	case 0: break;
	case 1: myzoom = 8; break;
	case 2: myzoom = 16; break;
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
	
// TODO: obvs we can't just write arrays and expect SimTunes to know it,
// we gotta do the hard yards and reverse the command block BS

// TODO: same thing for preview picture

// End data manipulation

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
buffer_write(bu,buffer_u32,0xFFFFFFFF);

// preview picture data
var colortable = [0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,0x80,0x81,0x82,0x83,0x84,0x20,0x19,0x26,0x2F];
var preview_buf = buffer_create(160*104,buffer_fixed,1);
for (var xx=0;xx<160;xx++)
	{
	for (var yy=0;yy<104;yy++)
		{
		var data = global.pixel_grid[xx][yy] > 0 ? colortable[global.pixel_grid[xx][yy]-1] : 0;
		buffer_write(preview_buf,buffer_u8,data);
		}
	}
var preview_buf_enc = scr_encrypt_chunk(preview_buf);
var preview_buf_size = buffer_get_size(preview_buf_enc);
trace("preview buf size: {0}",preview_buf_size);
buffer_write(bu,buffer_u32,preview_buf_size-4);
var t = buffer_tell(bu);
trace("tell: {0}",t);
//buffer_save(preview_buf_enc,"preview_buf.dat");
buffer_copy(preview_buf_enc,0,preview_buf_size,bu,t);
buffer_seek(bu,buffer_seek_relative,preview_buf_size);
buffer_delete(preview_buf);
buffer_delete(preview_buf_enc);

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
var bss = string_length(back_str);
buffer_write(bu,buffer_text,back_str);
buffer_write(bu,buffer_u8,0);

// Camera/zoom positions
buffer_write(bu,buffer_u32,round(x));
buffer_write(bu,buffer_u32,round(y));
buffer_write(bu,buffer_u32,myzoom);

// garbage data #3
repeat 5 buffer_write(bu,buffer_u32,0);

// teleporter warp list
var num_warps = 61; // TODO: actually get warp count
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
var note_buf = buffer_create(160*104,buffer_grow,1);
for (var xx=0;xx<160;xx++)
	{
	for (var yy=0;yy<104;yy++)
		{
		var data = global.pixel_grid[xx][yy];
		buffer_write(note_buf,buffer_u8,data);
		}
	}
var note_buf_enc = scr_encrypt_chunk(note_buf);
var note_buf_size = buffer_get_size(note_buf_enc);
buffer_write(bu,buffer_u32,note_buf_size-4);
buffer_copy(note_buf_enc,0,note_buf_size,bu,buffer_tell(bu));
buffer_seek(bu,buffer_seek_relative,note_buf_size);
buffer_delete(note_buf);
buffer_delete(note_buf_enc);

// Control Note position data
var ctrl_buf = buffer_create(160*104,buffer_grow,1);
for (var xx=0;xx<160;xx++)
	{
	for (var yy=0;yy<104;yy++)
		{
		var data = global.ctrl_grid[xx][yy];
		buffer_write(ctrl_buf,buffer_u8,data);
		}
	}
var ctrl_buf_enc = scr_encrypt_chunk(ctrl_buf);
var ctrl_buf_size = buffer_get_size(ctrl_buf_enc);
buffer_write(bu,buffer_u32,ctrl_buf_size-4);
buffer_copy(ctrl_buf_enc,0,ctrl_buf_size,bu,buffer_tell(bu));
buffer_seek(bu,buffer_seek_relative,ctrl_buf_size);
buffer_delete(ctrl_buf);
buffer_delete(ctrl_buf_enc);

// garbage data #4
repeat 2 buffer_write(bu,buffer_u32,0);

// mystery number + skip
repeat 2 buffer_write(bu,buffer_u32,0);

// Bugz metadata
var bugz = [mystruct.bugz.yellow,
mystruct.bugz.green,
mystruct.bugz.blue,
mystruct.bugz.red];
var bugzname_size = 0;

for (var i=0;i<4;i++)
	{
	bugzname_size = string_length(bugz[i].filename);
	buffer_write(bu,buffer_u32,bugzname_size);
	buffer_write(bu,buffer_text,bugz[i].filename);
	buffer_write(bu,buffer_u8,0);
	
	// Camera scale / Absolute X/Y
	// Kludge this to just extrapolate from note x/y for now
	repeat 2 buffer_write(bu,buffer_u32,global.zoom);
	buffer_write(bu,buffer_u32,round(bugz[i].pos[0]*16));
	buffer_write(bu,buffer_u32,round(bugz[i].pos[1]*16));
	
	// Note x/y positions
	buffer_write(bu,buffer_u32,round(bugz[i].pos[0]));
	buffer_write(bu,buffer_u32,round(bugz[i].pos[1]));
	var value = 0;
	switch bugz[i].dir
		{
		case 0: value = 1; break;
		case 270: value = 2; break;
		case 180: value = 3; break;
		default: break;
		}
	buffer_write(bu,buffer_u32,value);
	
	// unknown bugz data #2
	repeat 2 buffer_write(bu,buffer_u32,0);
	
	// error code (lets not make this more difficult than it needs to be)
	// TODO: mid-teleport code has stuff here
	buffer_write(bu,buffer_u32,0);
	buffer_write(bu,buffer_u32,0);
	
	// unknown bugz data #3, possibly tweezer related again?
	repeat 4 buffer_write(bu,buffer_u8,0);
	//buffer_write(bu,buffer_u8,16);
	//buffer_write(bu,buffer_u8,64);
	
	// misc. bugz metadata
	buffer_write(bu,buffer_u32,bugz[i].gear);
	buffer_write(bu,buffer_u32,bugz[i].paused);
	buffer_write(bu,buffer_u32,bugz[i].volume);
	}

// finally, save our buffer to file
buffer_save(bu,file);

// clean up data
buffer_delete(bu);
return 0;
}