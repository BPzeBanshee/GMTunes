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
	note_list: ds_grid_write(global.pixel_grid), //[note,x,y]
	ctrl_list: ds_grid_write(global.ctrl_grid),
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
	
// TODO: obvs we can't just write ds_grids and expect SimTunes to know it,
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
// TODO: actually generate project preview picture
buffer_write(bu,buffer_u32,0);
/*var ppd_raw = buffer_create(8,buffer_grow,1);
repeat 160*104 
	{
	repeat 2 buffer_write(ppd_raw,buffer_u8,1);
	//buffer_write(ppd_raw,buffer_u8,1);
	}
var ppd_size = buffer_get_size(ppd_raw);
buffer_write(bu,buffer_u32,ppd_size-4);
buffer_copy(ppd_raw,0,ppd_size,bu,buffer_tell(bu));
buffer_delete(ppd_raw);*/

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
var num_warps = 0; // TODO: actually get warp count
if num_warps > 0 then 
for (var i=0; i<num_warps;i++)
	{
	// xfrom, yfrom, xto, yto
	// TODO: actually get warp positions from ctrl_grid
	var warp = [0,0,0,0];
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
// TODO: actually get note data
var npd_size = 160*104;
buffer_write(bu,buffer_u32,npd_size);
repeat npd_size buffer_write(bu,buffer_u8,0);

// Control Note position data
// TODO: actually get note data
var cnpd_size = 160*104;
buffer_write(bu,buffer_u32,cnpd_size);
repeat cnpd_size buffer_write(bu,buffer_u8,0);

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