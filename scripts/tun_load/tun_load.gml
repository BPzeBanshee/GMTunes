function tun_load(file){
// Load file into buffer, do some error checking
if !file_exists(file) then return -2;
trace("Loading map "+string(file));

// Clear playfield first
with obj_bug instance_destroy();
with obj_flag instance_destroy();
ds_grid_clear(global.pixel_grid,0);
ds_grid_clear(global.ctrl_grid,0);

var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,file,0);
if buffer_word(bu,0) != "VER5"
&& buffer_word(bu,0) != "VER4"
    {
    msg("File doesn't match SimTunes VER4/5 format.");
    return -3;
    }
var eob = buffer_get_size(bu);
    
// Start offsetting, get project name + single space padding indicating end of string
buffer_seek(bu,buffer_seek_start,4);

var s = buffer_read(bu,buffer_u32); // u32 size of project name string
buffer_seek(bu,buffer_seek_relative,s);
/*trace("Size of string: "+string(s));

str_name = "";
for (var i=0; i<s; i++)
    {
    var a = buffer_read(bu,buffer_u8);
    str_name = str_name + chr(a);
    }
//buffer_read(bu,buffer_u8); // skip space at end of string
trace("Project Name: '"+str_name+"'");*/

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
buffer_seek(bu,buffer_seek_relative,author_size);
/*trace("Size of author str: "+string(author_size));

// Author name
for (var i=0;i<author_size;i++)
    {
    str_author += chr(buffer_read(bu,buffer_u8));
    }
trace("Author string: "+string(str_author));*/

// Description (big endian but doesn't matter as it's just an offset bit)
var desc_size = buffer_read(bu,buffer_u32);
buffer_seek(bu,buffer_seek_relative,desc_size);
/*for (var i=0;i<desc_size;i++)
    {
    str_desc += chr(buffer_read(bu,buffer_u8));
    }
trace("Desc string: "+string(str_desc));*/

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

if sprite_exists(myback) then sprite_delete(myback);
myback = bac_load(global.main_dir+"/BACKDROP/"+bkg_file);
if sprite_exists(myback)
	{
	var bid = layer_background_get_id("lay_bkg");
	layer_background_blend(bid,c_white);
	layer_background_sprite(bid,myback);
	layer_background_xscale(bid,4);
	layer_background_yscale(bid,4);
	}
	
// Camera/Zoom positions
var cam_x = buffer_read(bu,buffer_u32);
var cam_y = buffer_read(bu,buffer_u32);
var pixelsize = buffer_read(bu,buffer_u32);
trace(string("cam: [{0},{1}]",cam_x,cam_y));
trace(string("pixelsize: {0}",pixelsize));

var ww = 640*4;
var hh = 480*4;
switch pixelsize
	{
	//case 4
	case 8: global.zoom = 1; ww /= 2; hh /= 2; break;
	case 16: global.zoom = 2; ww /= 4; hh /= 4; break;
	default: global.zoom = 0; break;
	}
var cam = view_get_camera(0);
camera_set_view_size(cam,ww,hh);
camera_set_view_pos(cam,clamp(cam_x,0,1920),clamp(cam_y,0,1856));

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
global.warp_list = warp_list;
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
		flag[i] = instance_create_depth(flag_list[i][0]*16,flag_list[i][1]*16,99,obj_flag);
		flag[i].flagtype = i;
		flag[i].image_index = i;
		//flag.direction = 90 - (90*flag_list[i][2]);
		switch flag_list[i][2]
			{
			case 0: flag[i].direction = 90; break;
			case 1: flag[i].direction = 0; break;
			case 2: flag[i].direction = 270; break;
			case 3: flag[i].direction = 180; break;
			}
		flag[i].image_angle = flag[i].direction;
		}
	}
trace("Flag list: "+string(flag_list));	

// finally, the actual note position data
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
		ds_grid_add(global.pixel_grid,xx,yy,data);
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
			else ds_grid_add(global.ctrl_grid,xx,yy,data);
			}
		}
	}
trace("Starting positions in control bit buffer: "+string(startpos));
buffer_delete(minibuf);

// Random Bullshit #4
var unkd = [];
repeat 2 array_push(unkd,buffer_read(bu,buffer_u32));
//repeat 16 array_push(unkd,buffer_read(bu,buffer_u8));
trace("Random Bullshit #4: "+string(unkd));

// Mystery number, metadata version related?
// REVERB.GAL: 0x0D/13, BIRDINTH.GAL: 0x13/19, ALIENEXP.GAL: 0x1F/31
// CITYTALK.GAL: 0x00/0
var meta_number = buffer_read(bu,buffer_u32);
trace("Mystery Number: "+string(meta_number));
buffer_read(bu,buffer_u32);

// Bugz metadata
var bugname_str = [];
var bugz_posdir = [];
var bugz_speed = [];
var bugz_paused = [];
var bugz_volume = [];

// should be 60*4 bytes after the bugz names, the strings make it inconsistent tho
for (var i=0;i<4;i++)
	{
	//var chunk_size = buffer_read(bu,buffer_u32);
	//buffer_read(bu,buffer_u32);
	trace("file bytes remaining: "+string(eob - buffer_tell(bu)));
	var bugname_size = buffer_read(bu,buffer_u32);
	bugname_str[i] = "";
	repeat bugname_size bugname_str[i] += chr(buffer_read(bu,buffer_u8));
	trace(bugname_str[i]);
	if (eob - buffer_tell(bu)) == 87
		{
		trace("warning: metadata corruption, deferring read");
		bugz_posdir[i][0] = bugz_posdir[i-1][0];
		bugz_posdir[i][1] = bugz_posdir[i-1][1];
		bugz_posdir[i][2] = bugz_posdir[i-1][2];
		bugz_speed[i] = bugz_speed[i-1];
		bugz_paused[i] = bugz_paused[i-1];
		bugz_volume[i] = bugz_volume[i-1];
		}
	else
		{
	
		// First two always 0,2, other two fractional takes possibly?
		/*unk = [];
		repeat 4 array_push(unk,buffer_read(bu,buffer_u32));
		trace("Unk Bugz Metadata #1: "+string(unk));*/
		buffer_seek(bu,buffer_seek_relative,16);
	
		// Current positions (X, Y, DIR)
		bugz_posdir[i][0] = buffer_read(bu,buffer_u32); // X
		bugz_posdir[i][1] = buffer_read(bu,buffer_u32); // Y
		bugz_posdir[i][2] = buffer_read(bu,buffer_u32); // Dir
		trace("Direction: "+string(bugz_posdir[i][2])+", Position: "+string(bugz_posdir[i][0])+", "+string(bugz_posdir[i][1]));
		
		// More unknowns
		/*unk = [];
		repeat 2 array_push(unk,buffer_read(bu,buffer_u32));
		trace("Unk Bugz Metadata #2: "+string(unk));*/
		buffer_seek(bu,buffer_seek_relative,8);
		
		// error code presence of some kind
		var error = buffer_read(bu,buffer_u32);
		if error > 0 
			{
			trace("error presence code: "+string(error));
			buffer_seek(bu,buffer_seek_relative,4);
			
			var error2 = buffer_read(bu,buffer_u32);
			if error2 > 0 
				{
				trace("error2 presence code: "+string(error2));
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
				
				// FUNKBOW.TUN
				or ((error2 >> 16) == 0x4050 && (error >> 16) != 0x4055)
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
		
	
		// More unknowns
		// 0, 0, "tweezer values" usually 16, 64
		/*unk = [];
		repeat 4 array_push(unk,buffer_read(bu,buffer_u8));
		trace("Unk Bugz Metadata #3: "+string(unk));*/
		buffer_seek(bu,buffer_seek_relative,4);
	
		bugz_speed[i] = buffer_read(bu,buffer_u32); //0-8
		bugz_paused[i] = buffer_read(bu,buffer_u32); //0:paused, 1: playing, flip this later
		bugz_volume[i] = buffer_read(bu,buffer_u32); //0-128 in increments of 16
		
		trace(string("bug {0} speed: {1}, paused: {2}, volume: {3}",i,bugz_speed[i],bugz_paused[i],bugz_volume[i]));
		if filename_ext(file)==".GAL" then bugz_paused[i] = false;
		bugz_volume[i] = clamp(bugz_volume[i],0,128);
		}
	}

// clear buffer
buffer_delete(bu);

// finally, actually create the bugz
for (var i=0;i<4;i++)
	{
	var bug = bug_create(bugz_posdir[i][0]*16,bugz_posdir[i][1]*16,global.main_dir+"/BUGZ/"+bugname_str[i]);
	bug.gear = bugz_speed[i];
	bug.paused = bugz_paused[i];
	bug.volume = bugz_volume[i];
	switch bugz_posdir[i][2]
		{
		case 0: bug.direction = 90; break;
		case 1: bug.direction = 0; break;
		case 2: bug.direction = 270; break;
		case 3: bug.direction = 180; break;
		}
	trace("bug "+string(i)+" set to direction "+string(bugz_posdir[i][2])+" ("+string(bug.direction)+")");
	
	bug.calculate_timer();
	switch i
		{
		case 0: bug_yellow = bug; break;
		case 1: bug_green = bug; break;
		case 2: bug_blue = bug; break;
		case 3: bug_red = bug; break;
		}
	}
}