// ==== Structs for playfield/.tuns ====
function bug_data_struct() constructor {
	filename = "";
	bugztype = 0; // Not used in .tun file except in error codes. used in .bug
	dir = 0; //0-3, 0: up, 1: right, etc
	gear = 4;
	pos = [0,0]; //[x,y,dir]
	ctrl = [-1,-1];
	paused = false; //true/false
	volume = 128; //0-128 in increments of 16
	}
	
function playfield_struct() constructor {
	version = 1;
	name = "";
	author = "";
	desc = "";
	preview_image = "";
	background = "";
	camera_pos = [0,0];
	pixelsize = 4; // SimTunes uses pixelsize 4,8,16
	camera_zoom = 0; // SimTunes uses 0-2
	warp_list = []; //[xfrom,yfrom,xto,yto] //[-1,-1,-1,-1]
	flag_list = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]]; //[x,y,dir]
	note_list = Array2(160,104);//[note,x,y]
	ctrl_list = Array2(160,104);
	bugz = {
		yellow: new bug_data_struct(),
		green: new bug_data_struct(),
		blue: new bug_data_struct(),
		red: new bug_data_struct()
		}
	}
	
function default_playfield() : playfield_struct() constructor {
	version = 1;
	name = "New user";
	author = "New author";
	desc = "This is a new playfield.";
	background = "BACK01.BAC"; // I personally like 03GP4BT.BAC but SimTunes defaults to this
	bugz.yellow.filename = "YELLOW00.BUG";
	bugz.yellow.pos = [576,1280];
	bugz.yellow.dir = 0;
	bugz.green.filename = "GREEN00.BUG";
	bugz.green.pos = [1920,384];
	bugz.green.dir = 180;
	bugz.blue.filename = "BLUE00.BUG";
	bugz.blue.pos = [1920,1280];
	bugz.blue.dir = 90;
	bugz.red.filename = "RED00.BUG";
	bugz.red.pos = [576,384];
	bugz.red.dir = 270;
	}

// ==== Main functions ====

///@desc Loads a .tun or .gmtun file depending on given extension, then applies
///@desc that data to the global struct.
///@param {String} file
///@returns {Real} error code
function tun_load(file){
// File error checking
if !file_exists(file) then return -2;
trace("Loading playfield from "+string(file)+"...");

// Clear playfield first
with obj_bug instance_destroy();
global.note_grid = Array2(160,104);
global.ctrl_grid = Array2(160,104);
global.warp_list = [];
global.flag_list = [];

// Load contents from given file
var mystruct;
var fileext = string_lower(filename_ext(file));

if fileext == ".tun" 
or fileext == ".gal" 
mystruct = tun_load_tun(file);

if fileext == ".gmtun" 
mystruct = tun_load_gmtun(file);

if is_struct(mystruct) 
	{
	tun_apply_data(mystruct);
	return 0;
	}
return 1;
}

///@desc Loads a .tun file and returns a struct
///@param {String} file
///@returns {Real,Struct}
function tun_load_tun(file){
// Load file into buffer
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,file,0);

// do some error checking
var form = buffer_read_word(bu);
if form != "VER5" && form != "VER4"
    {
    msg("File doesn't match SimTunes VER4/5 format.");
    return -3;
    }
	
// Prep playfield struct and vars
var eob = buffer_get_size(bu);
var mystruct = new playfield_struct(); 

// Project name
var name_size = buffer_read(bu,buffer_u32);
var str_name = "";
repeat name_size str_name += chr(buffer_read(bu,buffer_u8));
trace("Project Name: '"+str_name+"'");
mystruct.name = str_name;

// At this point, existing included projects have 4 sets of FF padding,
// but user made projects get some weird garbage instead.
// I think it's safe to skip this.

// Unknown value
var unk = [];
repeat 4 array_push(unk,buffer_read(bu,buffer_u8));
trace("Unknown BS #1: "+string(unk));

// Get binary size of next blob minus size bit (assuming preview picture)
var skip = buffer_read(bu,buffer_u32);
buffer_seek(bu,buffer_seek_relative,skip);
trace("Size of preview picture chunk: {0} bytes",skip);
/*trace("Size of preview picture in bytes: "+string(s));
var newbuf = scr_decrypt_chunk(bu,s);
var minibuf = newbuf.buf;
var minibuf_size = newbuf.size_final;
buffer_seek(minibuf,buffer_seek_start,0);
trace("buffer written, size: "+string(minibuf_size)+" ("+string(buffer_get_size(minibuf))+")");

surf = surface_create(160,104);//(142,100);//(71,50);(120,106);
surface_set_target(surf);
draw_clear_alpha(c_black,1);*/
/*
Known Gallery files with bad color entries:
Color entry 0x1D/29, fixed to 0x20/32:
Abblah
AhoCalypso
AlienExp
Ariwool
Ballad
Birthday
Chinese
Circular
Cityscape
DenDenRappa
DogInTen
DongDong
GuleGule
Hoedown
MaxTheCo
Mr_D
Okinawa
PairOfTunes
RainFish
RainSong
ScaleBox (3542 erroneous notes!)
SimPark
SoundStu
ThisWay
TinyTones
Travelin
TrickorTreat
Walkinn
Washingt
WaterPic
Zimbabwe

Color entry 0xF6/246, fixed to 0x2F/47:
BugzLabo
CityTalk
CountyFair
Dinosaur
SassySix
SurfinUSSR

Known Gallery files with no issues:
Bird in the Dark
Drummer
Heartstrings
Loopy Loop
Random Funk
Reverb
SOULGUMBO
Ups and Downs
Watching The World Go By
Wireless Mouse
World Music


Uneven bits was considered but ruled out as they do not
correlate from the zero-issue to the large issue .tuns
*/
/*var colortable = [0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,0x80,0x81,0x82,0x83,0x84,0x20,0x19,0x26,0x2F];
// Draw preview picture using decompressed chunk data (invalid colors), possibly wrong res?
var count = 0;
for (var yy = 0; yy < surface_get_height(surf); yy++)
    {
    for (var xx = 0; xx < surface_get_width(surf); xx++)
        {
		if buffer_tell(minibuf) == minibuf_size then exit;
		var data = buffer_read(minibuf,buffer_u8);
		var color = array_get_index(colortable,data);
		if data > 0
			{
			if color == -1
				{
				count++;
				if data == 0x1D then color = 22 // 29: Abblah, Ariwool, Ballad
				else if data == 0xF6 then color = 25 // 246: BugzLabo
				else color = 0;
				trace("data "+string(data)+" not found in color table, kludging to "+string(color));
				}
			draw_sprite_part(spr_note,color,0,0,1,1,xx,yy);
			}
        }
    }
surface_reset_target();
buffer_delete(minibuf);
if count > 0 then trace(string(count)+" erroneous color value entries found in preview image");*/
/*var f2 = get_save_filename(".dat","");
if f2 != ""
	{
	buffer_save(minibuf,f2);
	}*/

// Author name
var author_size = buffer_read(bu,buffer_u32);
var str_author = "";
repeat author_size str_author += chr(buffer_read(bu,buffer_u8));
trace("Author string: "+string(str_author));
mystruct.author = str_author;

// Description (big endian but doesn't matter as it's just an offset bit)
var desc_size = buffer_read(bu,buffer_u32);
var str_desc = "";
repeat desc_size str_desc += chr(buffer_read(bu,buffer_u8));
trace("Desc string: "+string(str_desc));
mystruct.desc = str_desc;

// TODO: Mystery data here, seems to be 8 bytes of 00 following a value,
// then another value after 8 bytes, then FF FF FF FF
unk = [];
repeat 7 array_push(unk,buffer_read(bu,buffer_s32));
//repeat 28 array_push(unk,buffer_read(bu,buffer_u8));
trace("Unknown BS #2: {0}",unk);

// Pull background filename as string
var str_size = buffer_read(bu,buffer_u32);
var bkg_file = "";
repeat str_size bkg_file += chr(buffer_read(bu,buffer_u8));
trace("background filename: {0}",bkg_file);
mystruct.background = bkg_file;
	
// Camera/Zoom positions
var cam_x = buffer_read(bu,buffer_u32);
var cam_y = buffer_read(bu,buffer_u32);
var pixelsize = buffer_read(bu,buffer_u32); // 4,8, or 16
var camera_zoom = buffer_read(bu,buffer_u32); // 0, 1 or 2
trace("cam: [{0},{1}]",cam_x,cam_y);
trace("pixelsize: {0}",pixelsize);
mystruct.camera_pos = [cam_x,cam_y];
mystruct.pixelsize = pixelsize;
mystruct.camera_zoom = camera_zoom;

// Random BS #3
unk = [];
repeat 4 array_push(unk,buffer_read(bu,buffer_s32));
//repeat 20 array_push(unk,buffer_read(bu,buffer_u8));
trace("Unknown BS #3: {0}",unk);

// Teleporter warp list
// Count is apparently always hardlocked at 61
var num_warps = buffer_read(bu,buffer_u32);

var warp_list = [];
var count = 0;
var warp = [];
for (var i=0;i<num_warps;i++)
	{
	// xfrom, yfrom, xto, yto
	warp[0] = buffer_read(bu,buffer_s32);
	warp[1] = buffer_read(bu,buffer_s32);
	warp[2] = buffer_read(bu,buffer_s32);
	warp[3] = buffer_read(bu,buffer_s32);
	//trace("raw warp values: {0},{1},{2},{3}",warp[0],warp[1],warp[2],warp[3]);
	if (warp[0] > -1
	&& warp[1] > -1
	&& warp[2] > -1
	&& warp[3] > -1)
		{
		warp_list[count][0] = warp[0];
		warp_list[count][1] = warp[1];
		warp_list[count][2] = warp[2];
		warp_list[count][3] = warp[3];
		count++;
		}
	
	}
//array_resize(warp_list,count);
mystruct.warp_list = warp_list;
trace("Warp list: "+string(warp_list));

var flag_list = [];
for (var i=0;i<4;i++)
	{
	// x,y,direction (0-3, 0: up, rotates clockwise 90)
	flag_list[i][0] = buffer_read(bu,buffer_s32);
	flag_list[i][1] = buffer_read(bu,buffer_s32);
	flag_list[i][2] = buffer_read(bu,buffer_s32);
	
	// Create flags
	if flag_list[i][2] > -1
		{
		switch flag_list[i][2]
			{
			case 0: flag_list[i][2] = 90; break;
			case 1: flag_list[i][2] = 0; break;
			case 2: flag_list[i][2] = 270; break;
			case 3: flag_list[i][2] = 180; break;
			}
		}
	}
trace("Flag list: "+string(flag_list));	
mystruct.flag_list = flag_list;

// finally, the actual note position data
var note_grid = Array2(160,104);
var ctrl_grid = Array2(160,104);

var chunk_size = buffer_read(bu,buffer_u32);
trace("Size of music note table size: {0}",chunk_size);
//buffer_save_ext(bu,"chunk_og.dat",buffer_tell(bu),chunk_size);

var newbuf = scr_decrypt_chunk(bu,chunk_size);
var minibuf = newbuf.buffer_new;
var minibuf_size = newbuf.size_final;
buffer_seek(minibuf,buffer_seek_start,0);
trace("buffer decoded, size: {0} ({1})",minibuf_size,buffer_get_size(minibuf));

for (var yy = 0; yy < 104; yy++)
	{
	for (var xx = 0; xx < 160; xx++)
		{
		var data = buffer_read(minibuf,buffer_u8);
		note_grid[xx][yy] = data;
		}
	}
buffer_delete(minibuf);

// ...then the control bit position data
chunk_size = buffer_read(bu,buffer_u32);
trace("Size of control note table size: "+string(chunk_size));
newbuf = scr_decrypt_chunk(bu,chunk_size);
minibuf = newbuf.buffer_new;
minibuf_size = newbuf.size_final;
buffer_seek(minibuf,buffer_seek_start,0);
trace("buffer written, size: "+string(minibuf_size)+" ("+string(buffer_get_size(minibuf))+")");

var startpos = [];
for (var yy = 0; yy < 104; yy++)
	{
	for (var xx = 0; xx < 160; xx++)
		{
		var data = buffer_read(minibuf,buffer_u8);
		if data > 0
			{
			if data == 34 array_push(startpos,[xx,yy])
			else if data > 14
				{
				trace("control pos ({0},{1}) returned erroneous value {2}",xx,yy,data);
				}
			else ctrl_grid[xx][yy] = data;
			}
		}
	}
trace("Starting positions in control bit buffer: "+string(startpos));
buffer_delete(minibuf);

// write grids to string
mystruct.note_list = note_grid;
mystruct.ctrl_list = ctrl_grid;

// Bugz scale value
/*
Recent successes in creating SimTunes-loadable .tuns revealed
that the first u32 after the grid data is a scale value that
decides which sprite sets the Bugz use. This should always
match the camera zoom value, but SimTunes will accept non-matching
values and set the Bugz sizes on load, which lasts until you use
the zoom tool to change zoom levels.
*/
var bugz_scale = buffer_read(bu,buffer_u32);
if bugz_scale != camera_zoom
trace("WARNING: Camera zoom and Bugz scale value don't match!");

// Random Bullshit #4
/*
Second value seems to be some kind of timer that changes
from save to save, but is usually a low number.

Could it be metadata versioning, or something else?
REVERB.GAL: 0x0D/13, BIRDINTH.GAL: 0x13/19, ALIENEXP.GAL: 0x1F/31
CITYTALK.GAL: 0x00/0
*/
unk = [];
repeat 3 array_push(unk,buffer_read(bu,buffer_u32));
//repeat 12 array_push(unkd,buffer_read(bu,buffer_u8));
trace("Random Bullshit #4: {0}",unk);

// Bugz metadata
var bugz_posdir = [];
var bugz_speed = [];
var bugz_paused = [];
var bugz_volume = [];
var bugz = [mystruct.bugz.yellow,mystruct.bugz.green,mystruct.bugz.blue,mystruct.bugz.red];

// total field size should be 60*4 bytes after the bugz names
// the strings and error codes make it inconsistent tho
trace("File bytes remaining: {0}",eob - buffer_tell(bu));

for (var i=0; i<4; i++)
	{
	trace("=== BUG {0} METADATA ===",i);
	
	var bugname_size = buffer_read(bu,buffer_u32);
	var bugname_str = "";
	repeat bugname_size bugname_str += chr(buffer_read(bu,buffer_u8));
	trace(bugname_str);
	bugz[i].filename = bugname_str;
	
	/*
	First four values are the zoom levels, followed by x/y positions of the Bugz
	offset by a value depending on aforementioned zoom level (2: -8, 1: -12, 0: -14).
	Placing a Bug at 0,0 using a start flag proves these are meant to be read as s32s.
	Presumably interpreted as relative to drawing of sprite.
	TODO: are these hardcoded or affected by sprite size? not all bugz are the same
	but they're close!
	*/
	unk = [];
	repeat 4 array_push(unk,buffer_read(bu,buffer_s32));
	trace("Scale/X/Y data relative to camera: {0}",unk);
	
	// Note X/Y positions (X, Y, DIR)
	// NOTE: Multiply positions by 16 to get absolute x/y for now
	var note_x = buffer_read(bu,buffer_u32); // X
	var note_y = buffer_read(bu,buffer_u32); // Y
	bugz[i].pos[0] = note_x * 16;
	bugz[i].pos[1] = note_y * 16; 
	trace("Note XY Values: {0},{1}",note_x,note_y);
	
	bugz[i].dir = buffer_read(bu,buffer_u32); // Dir
	var corrected_dir = 0;
	switch bugz[i].dir
		{
		case 0: corrected_dir = 90; break;
		case 1: corrected_dir = 0; break;
		case 2: corrected_dir = 270; break;
		case 3: corrected_dir = 180; break;
		}
	trace("Direction: "+string(bugz[i].dir)+" ("+string(corrected_dir)+")");
	bugz[i].dir = corrected_dir;	
	/*
	The following two uint32s are some kind of command code pair.
	If either are non-zero it's implied there's some extra metadata
	in the Bugz data that needs to be parsed.
	
	Known functions from testing:
	8,0 : Teleport control block
	1,0 : Arrow control block
	34,0 : Obsolete start position data (not seen in user-made .tuns)
	0,1 : Undetermined (cfr. CITYTALK.GAL (Yellow))
	*/
	var error1 = buffer_read(bu,buffer_u32);
	var error2 = buffer_read(bu,buffer_u32);
	var tele = [-1,-1];
	
	if error1 == 0 && error2 == 0
		{
		buffer_seek(bu,buffer_seek_relative,8);
		}
	else
		{
		trace("WARNING: Bugz Codes: {0},{1}",error1,error2);
		
		if (error1 == 0 && error2 == 1) // WATCHING.GAL GREEN02.BUG, CITYTALK.GAL YELLOW
		tun_read_bugz_code_01(bu)
		
		else if (error1 == 1 && error2 == 0) // RAINSONG.GAL YELLOW02.BUG, yellow test.tun
		tele = tun_read_bugz_code_10(bu)
		
		else if (error1 == 8 && error2 == 0) // WATCHING.GAL YELLOW02.BUG, user projects mid-teleport
		tele = tun_read_bugz_code_80(bu)
			
		else if (error1 == 34 && error2 == 0) // RANDOMFU.GAL all Bugz
		tun_read_bugz_code_34(bu);
		}
	
	/*
	There's a set of 4 uint8s here which are suspected to be some kind
	of remainder coordinates set by the tweezer objects upon picking up
	Bugz. On a fresh project these default to 0, when picked up by a
	Tweezer tool the second pair is usually defaulted to 16,64.
	I've never seen the first pair as anything but 0.
	*/
	unk = [];
	repeat 4 array_push(unk,buffer_read(bu,buffer_u8));
	trace("Suspected 'Tweezer' values: "+string(unk));
	
	bugz[i].ctrl = tele;
	bugz[i].gear = buffer_read(bu,buffer_u32); //0-8
	bugz[i].paused = buffer_read(bu,buffer_u32); //0:paused, 1: playing, flip this later
	bugz[i].volume = buffer_read(bu,buffer_u32); //0-128 in increments of 16
		
	trace(string("bug {0} speed: {1}, paused: {2}, volume: {3}",i,bugz[i].gear,bugz[i].paused,bugz[i].volume));
	if string_upper(filename_ext(file))==".GAL" then bugz[i].paused = false;
	bugz[i].volume = clamp(bugz[i].volume,0,128);
	}

// clear buffer
buffer_delete(bu);
return mystruct;
}

function tun_read_bugz_code_01(bu){
var pair1 = [];
var count = 1;
repeat 4
	{
	array_push(pair1,buffer_read(bu,buffer_u32));
	trace("* Value #{0}: {1} (Hex: {2})",count,pair1,hex_array(pair1));
	pair1 = []; count++;
	}
buffer_read(bu,buffer_u8);
return 0;
}

function tun_read_bugz_code_10(bu){
/*
Current testing suggests this operates similar to code 80,
but is used when saved mid-transit for arrow control blocks.

Even pairs almost always have nothing.
Odd pairs contain at least one set usually in 0,x,x,40 (64)
and a set with either 0,0,F0,3F (240,63) or 0,0,F0,BF (240,191)

On an up-left arrow save, 
pair 1 had a 04 set, pair 3 was 0,0,0,0, pair 5 and 7 had 0,0,F0,BF
On a left arrow save, 
pair 1 had a 04 set, pair 3 had 0,0,F0,3F but pair 5 had 0,0,F0,BF
On a down-left arrow save, 
pair 1 and 3 had a 04 set, pair 5 had 0,0,F0,BF but pair 7 had 0,0,F0,3F
On a right arrow save, 
pair 1 had a 04 set, pair 3 and 5 had 0,0,F0,3F
On down-right arrow save, 
pair 1 and 3 had a 04 set, pair 5 and 7 had 0,0,F0,3F 

On an up-left arrow save specifically pointed to -1,-1, 
pair 1 and 3 had 0,0,0,40 (64), pair 5 and 7 had 0,0,F0,BF.
Same test pointed to 0,0 saved at different moments,
pair 1 and 3 had 0,0,1c,40 on first save, 8,40 on second save
*/
var count = 1;
var pair1 = [];
var pair2 = [];
repeat 4
	{
	array_push(pair1,buffer_read(bu,buffer_f32));
	buffer_read(bu,buffer_u32);
	//repeat 4 array_push(pair1,buffer_read(bu,buffer_u8));
	//repeat 4 array_push(pair2,buffer_read(bu,buffer_u8));
	//trace("tun_error_code_10() - pair #{0}: {1} (Hex: {2})",count,pair1,hex_array(pair1)); count++;
	//trace("tun_error_code_10() - pair #{0}: {1} (Hex: {2})",count,pair2,hex_array(pair2)); count++;
	//pair1 = [];
	//pair2 = [];
	}
trace("Suspected floating point values: {0}",pair1);

// Saving a left arrow jump that goes past the border yields wrapped values
// proving this should be signed, not unsigned
var ctrl_x = buffer_read(bu,buffer_s32);
var ctrl_y = buffer_read(bu,buffer_s32);
trace("Teleport destination values found: {0},{1}",ctrl_x,ctrl_y);

var ex = buffer_read(bu,buffer_u32);
if ex > 0
	{
	// read out exit code
	var arr = [ex];
	repeat 3 array_push(arr,buffer_read(bu,buffer_u32));
	trace("WARNING: Exit code: {0} (Hex: {1})",arr,hex_array(arr));

	// research shows an additional byte is always slapped on at the end
	// before the Tweezer values
	buffer_read(bu,buffer_u32);
	buffer_read(bu,buffer_u8);
	}
else buffer_seek(bu,buffer_seek_relative,8);//buffer_read(bu,buffer_u32);
return [ctrl_x * 16,ctrl_y * 16];
}

function tun_read_bugz_code_34(bu){
/*
Research and testing with other codes, and the inability
to be able to get this thing to appear on user-generated
.tuns suggest it's an indev-only flag for starting
positions.
*/
var pair1 = [];
var pair2 = [];
var count = 1;//0
repeat 4
	{
	/*array_push(pair1,buffer_read(bu,buffer_f32)); count++;
	if count == 4
		{
		repeat 4 array_push(pair2,buffer_read(bu,buffer_u8));
		trace("End of values stamp: {0}",pair2);
		}
	else buffer_read(bu,buffer_u32);*/
	repeat 4 array_push(pair1,buffer_read(bu,buffer_u8));
	repeat 4 array_push(pair2,buffer_read(bu,buffer_u8));
	trace("* Pair #{0}: {1} (Hex: {2})",count,pair1,hex_array(pair1)); count++;
	trace("* Pair #{0}: {1} (Hex: {2})",count,pair2,hex_array(pair2)); count++;
	pair1 = [];
	pair2 = [];
	}
//trace("Suspected floating point values: {0}",pair1);
	
// These values appear to be note x/y positions,
// but can be off by one. Maybe intended as direction
// indicator to extrapolate off?
var ctrl_x = buffer_read(bu,buffer_s32);
var ctrl_y = buffer_read(bu,buffer_s32);
trace("* Starting position values found: {0},{1}",ctrl_x,ctrl_y);
	
// Exit code
var ex = buffer_read(bu,buffer_u32);
if ex > 0
	{
	// read out exit code
	var arr = [ex];
	repeat 3 array_push(arr,buffer_read(bu,buffer_u32));
	trace("* Exit(?) code: {0} (Hex: {1})",arr,hex_array(arr));

	// research shows an additional byte is always slapped on at the end
	// before the Tweezer values
	buffer_read(bu,buffer_u32);
	buffer_read(bu,buffer_u8);
	}
else buffer_seek(bu,buffer_seek_relative,8);

return [ctrl_x*16,ctrl_y*16];
}

function tun_read_bugz_code_80(bu){
// Deal with the 0x40__ lines and their gaps first
var pair1 = [];
var pair2 = [];
var count = 1;
repeat 4
	{
	repeat 4 array_push(pair1,buffer_read(bu,buffer_u8));
	repeat 4 array_push(pair2,buffer_read(bu,buffer_u8));
	trace("* Pair #{0}: {1} (Hex: {2})",count,pair1,hex_array(pair1)); count++;
	trace("* Pair #{0}: {1} (Hex: {2})",count,pair2,hex_array(pair2)); count++;
	pair1 = [];
	pair2 = [];
	}
	
// Spray Test 8 shows these are teleport note destination points
var ctrl_x = buffer_read(bu,buffer_s32);
var ctrl_y = buffer_read(bu,buffer_s32);
trace("* Teleport destination values found: {0},{1}",ctrl_x,ctrl_y);

// Process exit code
/*
Known example codes:
WATCHING.GAL
[1,2,0,0xF0]: YELLOW02.BUG
[1,2,0,0xF1]: GREEN02.BUG
[1,2,0,0xF2]: BLUE02.BUG
[1,2,0,0xF3]: RED02.BUG
*/
var arr = [];
repeat 4 array_push(arr,buffer_read(bu,buffer_u32));
trace("* Mystery Exit(?) code: {0} (Hex: {1})",arr,hex_array(arr));

// research shows an additional 5 bytes is always slapped 
// on at the end before the Tweezer values
buffer_read(bu,buffer_u32);
buffer_read(bu,buffer_u8);

return [ctrl_x * 16,ctrl_y * 16];
}

///@desc Loads a .gmtun file and returns a struct
///@param {String} file
function tun_load_gmtun(file) {
var f = buffer_load(file);
var mystruct = json_parse(buffer_read(f,buffer_text));
buffer_delete(f);
trace(file+" loaded!");
return mystruct;
}

///@desc Applies data from the given struct onto the global playfield struct
///@param {Struct} tun_struct
function tun_apply_data(tun_struct) {
// Metadata
playfield_name = tun_struct.name;
playfield_author = tun_struct.author;
playfield_desc = tun_struct.desc;
if playfield_name != "" window_set_caption(string("GMTunes: {0} - {1}",playfield_author,playfield_name));

// Background
if sprite_exists(myback) then sprite_delete(myback);
if global.use_external_assets
	{
	var dir = global.main_dir+"BACKDROP/"+tun_struct.background;
	myback = bac_load(dir);
	}
//trace(dir+" resulted in code "+string(myback));
if sprite_exists(myback)
	{
	var bid = layer_background_get_id("lay_bkg");
	layer_background_blend(bid,c_white);
	layer_background_sprite(bid,myback);
	layer_background_xscale(bid,4);
	layer_background_yscale(bid,4);
	layer_background_vtiled(bid,false);
	layer_background_htiled(bid,false);
	mybackname = tun_struct.background;
	}
else
	{
	trace("sprite_exists(myback) failed, loading internal bkg...");
	var bid = layer_background_get_id("lay_bkg");
	layer_background_blend(bid,c_white);
	layer_background_sprite(bid,spr_playfield_bkg);
	layer_background_xscale(bid,4);
	layer_background_yscale(bid,4);
	layer_background_vtiled(bid,true);
	layer_background_htiled(bid,true);
	mybackname = "";
	}
	
// Camera settings
global.zoom = tun_struct.camera_zoom;
var ww = 640*4; // 1920
var hh = 480*4; // 1856
x = clamp(tun_struct.camera_pos[0],0,ww);
y = clamp(tun_struct.camera_pos[1],0,hh);
switch global.zoom
	{
	case 1: ww /= 2; hh /= 2; break;
	case 2: ww /= 4; hh /= 4; break;
	default: break;
	}
var cam = view_get_camera(0);
camera_set_view_size(cam,ww,hh);
camera_set_view_pos(cam,x,y);

// Flags
global.flag_list = tun_struct.flag_list;

// Pixel/Control grids
global.note_grid = tun_struct.note_list;
global.ctrl_grid = tun_struct.ctrl_list;
global.warp_list = tun_struct.warp_list;
trace("warp_list: {0}",global.warp_list);

// finally, actually create the bugz
var bugz = [tun_struct.bugz.yellow,tun_struct.bugz.green,tun_struct.bugz.blue,tun_struct.bugz.red];
for (var i=0;i<4;i++)
	{
	if bugz[i].filename != ""
	if file_exists(global.main_dir+"/BUGZ/"+bugz[i].filename)
		{
		//var bug = bug_create(bugz[i].pos[0]*16,bugz[i].pos[1]*16,global.main_dir+"/BUGZ/"+bugz[i].filename);
		var bug = bug_create(bugz[i].pos[0],bugz[i].pos[1],global.main_dir+"/BUGZ/"+bugz[i].filename);
		bug.gear = bugz[i].gear;
		bug.paused = bugz[i].paused;
		bug.volume = bugz[i].volume;
		bug.direction = bugz[i].dir;
		bug.ctrl_x = bugz[i].ctrl[0];
		bug.ctrl_y = bugz[i].ctrl[1];
		if bug.ctrl_x > -1 || bug.ctrl_y > -1 bug.warp = true;
		bug.calculate_timer();
	
		// apply the bugz to obj_ctrl_playfield's local bug tracking
		switch i
			{
			case 0: bug_yellow = bug; break;
			case 1: bug_green = bug; break;
			case 2: bug_blue = bug; break;
			case 3: bug_red = bug; break;
			}
		}
	}
}

