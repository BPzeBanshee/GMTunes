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
	trace("raw warp values: {0},{1},{2},{3}",warp[0],warp[1],warp[2],warp[3]);
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
			if data == 34 array_push(startpos,[xx,yy])
			else if data > 14
				{
				trace("control pos ({0},{1}) returned erroneous value {2}",xx,yy,data);
				}
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
	trace("Suspected actual x/y data (s32): {0}",unk); unk = [];
	/*var x_offset = 14;
	switch buffer_read(bu,buffer_s32)
		{
		case 0: break;
		case 1: x_offset = 12; break;
		case 2: x_offset = 8; break;
		}
	var y_offset = 14;
	switch buffer_read(bu,buffer_s32)
		{
		case 0: break;
		case 1: y_offset = 12; break;
		case 2: y_offset = 8; break;
		}
	bugz[i].pos[0] = 4 * room_width * ((buffer_read(bu,buffer_s32)+x_offset) / 640); // X
	bugz[i].pos[1] = 4 * room_height * ((buffer_read(bu,buffer_s32)+y_offset) / 480); // Y
	trace("XY Values: {0}",bugz[i].pos);*/
	//bugz[i].pos[1] = buffer_read(bu,buffer_u32); // Y
	
	// Current positions (Note X, Note Y, DIR)
	//buffer_seek(bu,buffer_seek_relative,8);
	var note_x = buffer_read(bu,buffer_u32); // X
	var note_y = buffer_read(bu,buffer_u32); // Y
	bugz[i].pos[0] = note_x;
	bugz[i].pos[1] = note_y; 
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
	trace("Direction: "+string(bugz[i].dir)+" ("+string(corrected_dir)+")");//, Position: "+string("{0}",bugz[i].pos));
	bugz[i].dir = corrected_dir;	
	/*
	The following two uint32s seem to be almost always 0,
	unless there's going to be error codes in the following
	two uint32s in which case some projects have the first
	value of 1.
	
	8,0 : user test 8
	0,1 : citytalk.gal (yellow)
	34,0 : funkbow.tun. citytalk.gal (green/blue/red)
	*/
	//unk = [];
	//repeat 2 array_push(unk,buffer_read(bu,buffer_u32));
	//trace("Suspected Teleport State Codes: "+string(unk));
	//buffer_seek(bu,buffer_seek_relative,8);
	var error1 = buffer_read(bu,buffer_u32);
	var error2 = buffer_read(bu,buffer_u32);
	trace("Mystery Error Codes: {0},{1}",error1,error2);
	if error1 == 0 && error2 == 0
		{
		buffer_seek(bu,buffer_seek_relative,8);
		}
	else
		{
		tun_error_code_old(bu);
		/*var pos = buffer_tell(bu);
		var offset = 16;
		if (error1 == 34 && error2 == 0) offset = 48;//repeat_value = 6;
		
		while buffer_tell(bu) < pos+offset
			{
			unk = [];
			repeat 4 array_push(unk,buffer_read(bu,buffer_u8));
			trace("Mystery values: {0} (hex: {1})",unk,hex_array(unk));
			
			var e = buffer_read(bu,buffer_u32);
			if e > 0 trace("u32 read between values: {0}",e);
			}
			
		// trim if irregular position
		if frac(buffer_tell(bu)/2) != 0 && frac(pos/2)!=0
			{
			buffer_read(bu,buffer_u8);
			trace("u8 trim");
			}
		else buffer_read(bu,buffer_u32);*/
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
	if string_upper(filename_ext(file))==".GAL" then bugz[i].paused = true;
	bugz[i].volume = clamp(bugz[i].volume,0,128);
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
global.zoom = tun_struct.pixelsize;
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
var flag_list = tun_struct.flag_list;
for (var i=0;i<4;i++)
	{
	// Create flags
	if flag_list[i][2] > -1
		{
		flag[i] = instance_create_depth(flag_list[i][0]*16,flag_list[i][1]*16,99,obj_flag);
		flag[i].flagtype = i;
		flag[i].image_index = i;
		flag[i].direction = flag_list[i][2];
		flag[i].image_angle = flag_list[i][2];
		if global.use_external_assets then flag[i].sprite_index = global.spr_flag2[i];
		}
	}

// Pixel/Control grids
if tun_struct.note_list != "" ds_grid_read(global.pixel_grid,tun_struct.note_list);
if tun_struct.ctrl_list != "" ds_grid_read(global.ctrl_grid,tun_struct.ctrl_list);
global.warp_list = tun_struct.warp_list;

// finally, actually create the bugz
var bugz = [tun_struct.bugz.yellow,tun_struct.bugz.green,tun_struct.bugz.blue,tun_struct.bugz.red];
for (var i=0;i<4;i++)
	{
	if bugz[i].filename != ""
		{
		var bug = bug_create(bugz[i].pos[0]*16,bugz[i].pos[1]*16,global.main_dir+"/BUGZ/"+bugz[i].filename);
		//var bug = bug_create(bugz[i].pos[0],bugz[i].pos[1],global.main_dir+"/BUGZ/"+bugz[i].filename);
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

function tun_error_code_old(bu){
// error code presence of some kind
	var error = buffer_read(bu,buffer_u32);
	if error > 0 
		{
		trace("WARNING: error presence code: "+hex(error));
		buffer_seek(bu,buffer_seek_relative,4);
			
		var error2 = buffer_read(bu,buffer_u32);
		if error2 > 0 
			{
			trace("WARNING: error2 presence code: "+hex(error2));
			var done_offset = false;
			if error2 >= 0xF0 && error2 <= 0xF3//or error2 == 0xF1 or error2 == 0xF2 or error2 == 0xF3
				{
				trace("offset command "+hex(error2)+" found, skipping 5 bytes");
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
				trace("offset command "+hex(error2)+" found, skipping 49 bytes");
				buffer_seek(bu,buffer_seek_relative,49);
				done_offset = true;
				}
			if (error2 >> 24) >= 0x40 && !done_offset
				{
				// 0x401c is in zimbabwe but has no garbage code
				// MISHIKO.TUN has only 0x40
				trace("offset command "+hex(error2)+" found, skipping 40 bytes");
				buffer_seek(bu,buffer_seek_relative,40);
				done_offset = true;
				}
			}
		}
	else //buffer_seek(bu,buffer_seek_relative,4);
		{
		trace("weirdest shit, no offset command found, gonna try skipping 48 bytes anyway");
		buffer_seek(bu,buffer_seek_relative,48);
		//var t = buffer_tell(bu);
		//var offset = 48;
		}
}