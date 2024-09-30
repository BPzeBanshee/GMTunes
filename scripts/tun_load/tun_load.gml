function tun_load(file){
// File error checking
if !file_exists(file) then return -2;
trace("Loading playfield from "+string(file)+"...");

// Clear playfield first
with obj_bug instance_destroy();
with obj_flag instance_destroy();
ds_grid_clear(global.pixel_grid,0);
ds_grid_clear(global.ctrl_grid,0);

// Load contents from given file
var mystruct;
var fileext = string_lower(filename_ext(file));
var raw_grid_writes = false;

if fileext == ".tun" or fileext == ".gal" 
mystruct = tun_load_tun(file);

if fileext == ".gmtun" 
	{
	mystruct = tun_load_gmtun(file);
	raw_grid_writes = true;
	}

if is_struct(mystruct) 
	{
	tun_apply_data(mystruct,raw_grid_writes);
	return 0;
	}
return 1;
}

function tun_load_tun(file){
// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,file,0);
if buffer_word(bu,0) != "VER5"
&& buffer_word(bu,0) != "VER4"
    {
    msg("File doesn't match SimTunes VER4/5 format.");
    return -3;
    }
var eob = buffer_get_size(bu);

var mystruct = new playfield_struct(); 
    
// Start offsetting, get project name + single space padding indicating end of string
buffer_seek(bu,buffer_seek_start,4);

var s = buffer_read(bu,buffer_u32); // u32 size of project name string
//buffer_seek(bu,buffer_seek_relative,s);
trace("Size of string: "+string(s));

var str_name = "";
for (var i=0; i<s; i++)
    {
    var a = buffer_read(bu,buffer_u8);
    str_name = str_name + chr(a);
    }
//buffer_read(bu,buffer_u8); // skip space at end of string
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
s = buffer_read(bu,buffer_u32);
buffer_seek(bu,buffer_seek_relative,s);
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
	
// Author name string size
var author_size = buffer_read(bu,buffer_u32);
//buffer_seek(bu,buffer_seek_relative,author_size);
trace("Size of author str: "+string(author_size));

// Author name
var str_author = "";
for (var i=0;i<author_size;i++)
    {
    str_author += chr(buffer_read(bu,buffer_u8));
    }
trace("Author string: "+string(str_author));
mystruct.author = str_author;

// Description (big endian but doesn't matter as it's just an offset bit)
var desc_size = buffer_read(bu,buffer_u32);
//buffer_seek(bu,buffer_seek_relative,desc_size);
var str_desc = "";
for (var i=0;i<desc_size;i++)
    {
    str_desc += chr(buffer_read(bu,buffer_u8));
    }
trace("Desc string: "+string(str_desc));
mystruct.desc = str_desc;

// TODO: Mystery data here, seems to be 8 bytes of 00 following a value,
// then another value after 8 bytes, then FF FF FF FF
var unkb = [];
repeat 28 array_push(unkb,buffer_read(bu,buffer_u8));
trace("Unknown BS #2: "+string(unkb));

// Pull background filename as string
var str_size = buffer_read(bu,buffer_u32);
var bkg_file = "";
for (var i=0;i<str_size;i++) bkg_file += chr(buffer_read(bu,buffer_u8));
trace("background filename: "+string(bkg_file));
mystruct.background = bkg_file;
	
// Camera/Zoom positions
var cam_x = buffer_read(bu,buffer_u32);
var cam_y = buffer_read(bu,buffer_u32);
var pixelsize = buffer_read(bu,buffer_u32);
trace(string("cam: [{0},{1}]",cam_x,cam_y));
trace(string("pixelsize: {0}",pixelsize));
mystruct.camera_pos = [cam_x,cam_y];
switch pixelsize
	{
	case 8: mystruct.pixelsize = 1; break;
	case 16: mystruct.pixelsize = 2; break;
	case 4:
	default: mystruct.pixelsize = 0; break;
	}

// Random BS #3
var unkc = [];
repeat 20 array_push(unkc,buffer_read(bu,buffer_u8));
trace("Unknown BS #3: "+string(unkc));

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
	if (warp[0] > 0
	&& warp[1] > 0
	&& warp[2] > 0
	&& warp[3] > 0)
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
	flag_list[i][0] = buffer_read(bu,buffer_u32);
	flag_list[i][1] = buffer_read(bu,buffer_u32);
	flag_list[i][2] = buffer_read(bu,buffer_u32);
	
	// Create flags
	if flag_list[i][0] > -1
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
var note_grid = ds_grid_create(160,104);
var ctrl_grid = ds_grid_create(160,104);


s = buffer_read(bu,buffer_u32);
trace("Size of note table size: "+string(s));
var newbuf = scr_decrypt_chunk(bu,s);
var minibuf = newbuf.buf;
var minibuf_size = newbuf.size_final;
buffer_seek(minibuf,buffer_seek_start,0);
trace("buffer written, size: "+string(minibuf_size)+" ("+string(buffer_get_size(minibuf))+")");

for (var yy = 0; yy < 104; yy++)
	{
	for (var xx = 0; xx < 160; xx++)
		{
		var data = buffer_read(minibuf,buffer_u8);
		ds_grid_add(note_grid,xx,yy,data);
		}
	}
buffer_delete(minibuf);

// ...then the control bit position data
s = buffer_read(bu,buffer_u32);
trace("Size of note table size: "+string(s));
newbuf = scr_decrypt_chunk(bu,s);
minibuf = newbuf.buf;
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
			if data == 34
			then array_push(startpos,[xx,yy])
			else ds_grid_add(ctrl_grid,xx,yy,data);
			}
		}
	}
trace("Starting positions in control bit buffer: "+string(startpos));
buffer_delete(minibuf);

// write grids to string
mystruct.note_list = ds_grid_write(note_grid);
mystruct.ctrl_list = ds_grid_write(ctrl_grid);
ds_grid_destroy(note_grid);
ds_grid_destroy(ctrl_grid);

// Random Bullshit #4
/*
Third value seems to be some kind of timer that changes
from save to save, but is usually a low number.
*/
var unkd = [];
repeat 4 array_push(unkd,buffer_read(bu,buffer_u32));
//repeat 16 array_push(unkd,buffer_read(bu,buffer_u8));
trace("Random Bullshit #4: "+string(unkd));

// Mystery number, metadata version related?
// REVERB.GAL: 0x0D/13, BIRDINTH.GAL: 0x13/19, ALIENEXP.GAL: 0x1F/31
// CITYTALK.GAL: 0x00/0
/*var meta_number = buffer_read(bu,buffer_u32);
trace("Mystery Number: "+string(meta_number));
buffer_read(bu,buffer_u32);*/

// Bugz metadata

var bugz_posdir = [];
var bugz_speed = [];
var bugz_paused = [];
var bugz_volume = [];
var bugz = [mystruct.bugz.yellow,mystruct.bugz.green,mystruct.bugz.blue,mystruct.bugz.red];

// should be 60*4 bytes after the bugz names, the strings make it inconsistent tho
for (var i=0; i<4; i++)
	{
	trace("BUG "+string(i)+" METADATA - file bytes remaining: "+string(eob - buffer_tell(bu)));
	var bugname_size = buffer_read(bu,buffer_u32);
	var bugname_str = "";
	repeat bugname_size bugname_str += chr(buffer_read(bu,buffer_u8));
	trace(bugname_str);
	bugz[i].filename = bugname_str;
	
	if (eob - buffer_tell(bu)) == 87
		{
		trace("WARNING: metadata corruption, deferring read");
		bugz[i] = bugz[i-1];	//copy all stats from previous bug
		bugz[i].filename = bugname_str; //re-apply unique filename
		}
	else
		{
		/*
		First four uint32s here appear to be absolute x/y positions of the Bugz.
		First two values determine mode:
		Mode 2 appears to be absolute position - 8.
		This wraps around if you place the bug at the top/left most parts to uint32 cap - 8.
		(tested with user .tuns)
		
		Mode 0 appears to be position in screen space - 16. It isn't clear how program
		decides this is to be saved to file nor is it clear why it'd ever need this.
		(test case: Reverb)
		*/
		unk = [];
		repeat 4 array_push(unk,buffer_read(bu,buffer_u32));
		trace("Unknown Bugz Metadata #1: "+string(unk));
		//buffer_seek(bu,buffer_seek_relative,16);
	
		// Current positions (Note X, Note Y, DIR)
		bugz[i].pos[0] = buffer_read(bu,buffer_u32) * 16; // X
		bugz[i].pos[1] = buffer_read(bu,buffer_u32) * 16; // Y
		bugz[i].dir = buffer_read(bu,buffer_u32); // Dir
		switch bugz[i].dir
			{
			case 0: bugz[i].dir = 90; break;
			case 1: bugz[i].dir = 0; break;
			case 2: bugz[i].dir = 270; break;
			case 3: bugz[i].dir = 180; break;
			}
		trace("Direction: "+string(bugz[i].dir)+", Position: "+string("{0}",bugz[i].pos));
		
		/*
		The following two uint32s seem to be almost always 0,
		unless there's going to be error codes in the following
		two uint32s in which case some projects have the first
		value of 1.
		*/
		unk = [];
		repeat 2 array_push(unk,buffer_read(bu,buffer_u32));
		trace("Unknown Bugz Metadata #2: "+string(unk));
		//buffer_seek(bu,buffer_seek_relative,8);
		
		// error code presence of some kind
		var error = buffer_read(bu,buffer_u32);
		if error > 0 
			{
			trace("WARNING: error presence code: "+string(error));
			buffer_seek(bu,buffer_seek_relative,4);
			
			var error2 = buffer_read(bu,buffer_u32);
			if error2 > 0 
				{
				trace("WARNING: error2 presence code: "+string(error2));
				var done_offset = false;
				if error2 == 0xF0 or error2 == 0xF1 or error2 == 0xF2 or error2 == 0xF3
					{
					trace("offset command "+string(error2)+" found, skipping 5 bytes");
					buffer_seek(bu,buffer_seek_relative,5);
					done_offset = true;
					}
				/*
				some bullshit in CITYTALK.GAL
				if error2 == 0x4056c000 
				or error2 == 0x4055c000
				or error2 == 0x40280000
				or error2 == 0x40580000
				*/
				/*
				TODO: some values here are shared on 'error2' but correlate to a 44 byte
				skip rather than a 53-byte skip. Zimbabwe has an error2 code but not
				an error code. Mishiko and Clown have error and error2 codes that
				don't correlate. 0x404B is listed at least once for a 44-byte skip.
				
				FUNKBOW.TUN
				error:  0x40550C00
				error2: 0x40504000
				*/
			
				if ((error2 >> 16) == 0x4029 
				or ((error2 >> 16) == 0x4042 && (error >> 16) != 0x404F)
				or ((error2 >> 16) == 0x4044 && (error >> 16) != 0x4052)
				
				// MR_D.GAL/MISHIKO.TUN?
				or ((error2 >> 16) == 0x404B && (error >> 16) != 0x4018 && (error >> 16) != 0x4054)
				or (error2 >> 16) == 0x404E 
				
				// whack shit resaving Reverb
				// FUNKBOW.TUN
				or ((error2 >> 16) == 0x4050 && ((error >> 16) != 0x4055 && (error >> 16) != 0x404C))
				or (error2 >> 16) == 0x4052) && !done_offset
					{
					trace("offset command "+string(error2)+" found, skipping 49 bytes");
					buffer_seek(bu,buffer_seek_relative,49);
					done_offset = true;
					}
				if (error2 >> 24) >= 0x40 && !done_offset
					{
					// 0x401c is in zimbabwe but has no garbage code
					// MISHIKO.TUN has only 0x40
					trace("offset command "+string(error2)+" found, skipping 40 bytes");
					buffer_seek(bu,buffer_seek_relative,40);
					done_offset = true;
					}
				}
			}
		else
			{
			buffer_seek(bu,buffer_seek_relative,4);
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
		//buffer_seek(bu,buffer_seek_relative,4);
	
		bugz[i].gear = buffer_read(bu,buffer_u32); //0-8
		bugz[i].paused = buffer_read(bu,buffer_u32); //0:paused, 1: playing, flip this later
		bugz[i].volume = buffer_read(bu,buffer_u32); //0-128 in increments of 16
		
		trace(string("bug {0} speed: {1}, paused: {2}, volume: {3}",i,bugz[i].gear,bugz[i].paused,bugz[i].volume));
		if string_upper(filename_ext(file))==".GAL" then bugz[i].paused = false;
		bugz[i].volume = clamp(bugz[i].volume,0,128);
		}
	}

// clear buffer
buffer_delete(bu);
return mystruct;
}

function tun_load_gmtun(tun_filename="") {
if tun_filename == "" exit;
var f = buffer_load(tun_filename);
var mystruct = json_parse(buffer_read(f,buffer_text));
buffer_delete(f);
trace(tun_filename+" loaded!");
trace(mystruct);
return mystruct;
}

function tun_apply_data(tun_struct,raw_grids=true) {
// Metadata
playfield_name = tun_struct.name;
playfield_author = tun_struct.author;
playfield_desc = tun_struct.desc;
if playfield_name != ""
	{
	window_set_caption(string("GMTunes: {0} - {1}",playfield_author,playfield_name));
	}

// Background
if sprite_exists(myback) then sprite_delete(myback);
var dir = global.main_dir+"BACKDROP/"+tun_struct.background;
myback = bac_load(dir);
//trace(dir+" resulted in code "+string(myback));
if sprite_exists(myback)
	{
	var bid = layer_background_get_id("lay_bkg");
	layer_background_blend(bid,c_white);
	layer_background_sprite(bid,myback);
	layer_background_xscale(bid,4);
	layer_background_yscale(bid,4);
	mybackname = tun_struct.background;
	}
	
// Camera settings
x = clamp(tun_struct.camera_pos[0],0,1920);
y = clamp(tun_struct.camera_pos[1],0,1856);
global.zoom = tun_struct.pixelsize;
var ww = 640*4;
var hh = 480*4;
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
var flag_list = tun_struct.flag_list;
for (var i=0;i<4;i++)
	{
	// Create flags
	if flag_list[i][0] > -1
		{
		flag[i] = instance_create_depth(flag_list[i][0]*16,flag_list[i][1]*16,99,obj_flag);
		flag[i].flagtype = i;
		flag[i].image_index = i;
		flag[i].direction = flag_list[i][2];
		flag[i].image_angle = flag_list[i][2];
		if !global.use_int_spr then flag[i].sprite_index = global.spr_flag2[i];
		}
	}

// Pixel/Control grids
if raw_grids // if loaded as raw ds_grid_writes
	{
	if tun_struct.note_list != "" ds_grid_read(global.pixel_grid,tun_struct.note_list);
	if tun_struct.ctrl_list != "" ds_grid_read(global.ctrl_grid,tun_struct.ctrl_list);
	}
global.warp_list = tun_struct.warp_list;

// finally, actually create the bugz
var bugz = [tun_struct.bugz.yellow,tun_struct.bugz.green,tun_struct.bugz.blue,tun_struct.bugz.red];
for (var i=0;i<4;i++)
	{
	if bugz[i].filename != ""
		{
		var bug = bug_create(bugz[i].pos[0],bugz[i].pos[1],global.main_dir+"/BUGZ/"+bugz[i].filename);
		bug.gear = bugz[i].gear;
		bug.paused = bugz[i].paused;
		bug.volume = bugz[i].volume;
		bug.direction = bugz[i].dir;
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