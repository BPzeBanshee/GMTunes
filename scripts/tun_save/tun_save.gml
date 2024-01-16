function tun_save(file){
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

// background filename
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