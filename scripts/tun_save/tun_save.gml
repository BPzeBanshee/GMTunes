function tun_save(file)
// Feather disable GM1041
{
// make sure we have a filename
if file == "" then return -2;

// create our buffer to write data to
var bu = buffer_create(8,buffer_grow,1);

// write version string
buffer_write(bu,buffer_text,"VER5");

// write project name
// TODO: actually load/store project name
var project_str = "GMTUNES TEST";
var ps = string_length(project_str)+1;
buffer_write(bu,buffer_u32,ps);
buffer_write(bu,buffer_text,project_str);
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
var author_str = "BPZE";
var as = string_length(author_str)+1;
buffer_write(bu,buffer_u32,as);
buffer_write(bu,buffer_text,author_str);
buffer_write(bu,buffer_u8,0);

// Description string
var desc_str = "The quick brown fox jumped over the lazy dog!";
var ds = string_length(desc_str)+1;
buffer_write(bu,buffer_u32,ds);
buffer_write(bu,buffer_text,desc_str);
buffer_write(bu,buffer_u8,0);

// garbage data #2
repeat 28 buffer_write(bu,buffer_u8,0);

// background filename (taken from obj_ctrl_playfield background vars)
var back_str = mybackname;//"03GP4BT.BAC";
var bss = string_length(back_str);
buffer_write(bu,buffer_text,back_str);
buffer_write(bu,buffer_u8,0);

// Camera/zoom positions
buffer_write(bu,buffer_u32,round(x));
buffer_write(bu,buffer_u32,round(y));
buffer_write(bu,buffer_u32,global.zoom);

// garbage data #3
repeat 20 buffer_write(bu,buffer_u8,0);

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
// TODO: actually get flag positions
for (var i=0;i<4;i++)
	{
	buffer_write(bu,buffer_u32,-1);
	buffer_write(bu,buffer_u32,-1);
	buffer_write(bu,buffer_u32,0);
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
var bugz = [obj_ctrl_playfield.bug_yellow,
obj_ctrl_playfield.bug_green,
obj_ctrl_playfield.bug_blue,
obj_ctrl_playfield.bug_red];
var bugzname_size = 0;

for (var i=0;i<4;i++)
	{
	bugzname_size = string_length(bugz[i].bugzname);
	buffer_write(bu,buffer_u32,bugzname_size);
	buffer_write(bu,buffer_text,bugz[i].bugzname);
	buffer_write(bu,buffer_u8,0);
	
	// unknown data, tweezer info?
	buffer_write(bu,buffer_u32,0);
	buffer_write(bu,buffer_u32,2);
	repeat 2 buffer_write(bu,buffer_u32,0);
	
	// positions
	buffer_write(bu,buffer_u32,round(bugz[i].x));
	buffer_write(bu,buffer_u32,round(bugz[i].y));
	var value = 0;
	switch bugz[i].direction
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
	buffer_write(bu,buffer_u32,0);
	buffer_write(bu,buffer_u32,0);
	
	// unknown bugz data #3, possibly tweezer related again?
	repeat 2 buffer_write(bu,buffer_u8,0);
	buffer_write(bu,buffer_u8,16);
	buffer_write(bu,buffer_u8,64);
	
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

function bug_struct() constructor {
filename = "";
dir = 0; //0-3, 0: up, 1: right, etc
gear = 4;
pos = [0,0]; //[x,y]
paused = false; //true/false
volume = 128; //0-128 in increments of 16
}

function tun_save_gmtun(tun_filename=global.main_dir+"/save.gmtun"){
// Prepare metadata

// Camera
var myzoom = 4;
switch global.zoom
	{
	case 0: break;
	case 1: myzoom = 8; break;
	case 2: myzoom = 16; break;
	}

// Flag data
var myflags;
for (var i=0;i<4;i++)
	{
	if flag[i] != noone
		{
		var flag_dir = flag[i].direction;
		/*switch flag[i].direction
			{
			case 90:	flag_dir = 0; break;
			case 0:		flag_dir = 1; break;
			case 270:	flag_dir = 2; break;
			case 180:	flag_dir = 3; break;
			}*/
		myflags[i] = [round(flag[i].x/16), round(flag[i].y/16), flag_dir];
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
		str[i].gear =		mybugz[i].gear;
		str[i].pos =		[mybugz[i].x,mybugz[i].y];
		str[i].paused =		mybugz[i].paused;
		str[i].volume =		mybugz[i].volume;
		}
	}

// Generate the JSON file
var mystruct = {
	version: 1,
	name: "",
	author: "",
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
	
var json = json_stringify(mystruct,true);
var f = file_text_open_write(tun_filename);
file_text_write_string(f,json);
file_text_close(f);

trace(tun_filename+" saved!");
}

function tun_load_gmtun(tun_filename="") {
if tun_filename == "" exit;
var f = buffer_load(tun_filename);
var mystruct = json_parse(buffer_read(f,buffer_text));
trace(mystruct);
buffer_delete(f);

x = mystruct.camera_pos[0];
y = mystruct.camera_pos[1];
global.zoom = mystruct.pixelsize;
ds_grid_read(global.pixel_grid,mystruct.note_list);
ds_grid_read(global.ctrl_grid,mystruct.ctrl_list);

trace(tun_filename+" loaded!");
}