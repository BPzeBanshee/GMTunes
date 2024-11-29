///@desc old load code
/*
TODO: UPDATE TO USE FINDINGS FROM TUN_LOAD
*/

// Get file
var f = get_open_filename("SimTunes .tun File (.tun)|*.TUN","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);
if buffer_word(bu,0) != "VER5"
&& buffer_word(bu,0) != "VER4"
    {
    msg("File doesn't match SimTunes VER4/5 format.");
    instance_destroy();
	exit;
    }
var eob = buffer_get_size(bu);
    
// Start offsetting, get project name + single space padding indicating end of string
buffer_seek(bu,buffer_seek_start,4);
var offset = 0;
var s = buffer_read(bu,buffer_u32); // u32 size of project name string
trace("Size of string: "+string(s));

str_name = "";
for (var i=0; i<s; i++)
    {
    var a = buffer_read(bu,buffer_u8);
    str_name = str_name + chr(a);
    }
//buffer_read(bu,buffer_u8); // skip space at end of string
trace("Project Name: '"+str_name+"'");

// At this point, existing included projects have 4 sets of FF padding,
// but user made projects get some weird garbage instead.
// I think it's safe to skip this.

// Unknown value
var unk = [];
repeat 4 array_push(unk,buffer_read(bu,buffer_u8));
trace("Unknown BS #1: "+string(unk));

// Get binary size of next blob minus size bit (assuming preview picture)
s = buffer_read(bu,buffer_u32); trace("Size of preview picture in bytes: "+string(s));

// Decrypt chunk
var newbuf = scr_decrypt_chunk(bu,s);
var minibuf = newbuf.buffer_new;
var minibuf_size = newbuf.size_final;
buffer_seek(minibuf,buffer_seek_start,0);
trace("buffer written, size: "+string(minibuf_size)+" ("+string(buffer_get_size(minibuf))+")");

// Now we have the data, let's draw it
surf = surface_create(160,104);
surface_set_target(surf);
draw_clear_alpha(c_black,1);
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
var colortable = [0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F,0x80,0x81,0x82,0x83,0x84,0x20,0x19,0x26,0x2F];
// Draw preview picture using decompressed chunk data (invalid colors), possibly wrong res?
var count = 0;
for (var yy = 0; yy < surface_get_height(surf); yy++)
    {
    for (var xx = 0; xx < surface_get_width(surf); xx++)
        {
		if buffer_tell(minibuf) >= minibuf_size then exit;
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
if count > 0 then trace(string(count)+" erroneous color value entries found in preview image");

// Keep decryped chunk for analysis, and attempt a re-encryption for testing
buffer_seek(minibuf,buffer_seek_start,0);
buffer_copy(minibuf,0,minibuf_size,newchunk,0);
buffer_seek(minibuf,buffer_seek_start,0);

// Author name string size
var author_size = buffer_read(bu,buffer_u32);
trace("Size of author str: "+string(author_size));

// Author name
for (var i=0;i<author_size;i++)
    {
    str_author += chr(buffer_read(bu,buffer_u8));
    }
trace("Author string: "+string(str_author));

// Description (big endian but doesn't matter as it's just an offset bit)
var desc_size = buffer_read(bu,buffer_u32);
for (var i=0;i<desc_size;i++)
    {
    str_desc += chr(buffer_read(bu,buffer_u8));
    }
trace("Desc string: "+string(str_desc));

// Description always ends with two bytes: 00 04, end termination string?
str_desc = string_wordwrap_width(str_desc,160,"\n",false);
image_xscale = string_width(str_desc)/2;
image_yscale = string_height(str_desc)/2;

// TODO: Mystery data here, seems to be 8 bytes of 00 following a value,
// then another value after 8 bytes, then FF FF FF FF
var unkb = [];
repeat 28 array_push(unkb,buffer_read(bu,buffer_u8));
trace("Unknown BS #2: "+string(unkb));

// Pull background filename as string
var str_size = buffer_read(bu,buffer_u32);
//offset += 4;
for (var i=0;i<str_size;i++) bkg_file += chr(buffer_read(bu,buffer_u8));
trace("background filename: "+string(bkg_file));
//offset += str_size;

// Random BS #3
var unkc = [];
repeat 32 array_push(unkc,buffer_read(bu,buffer_u8));
trace("Unknown BS #3: "+string(unkc));

// Teleporter warp list
// Count is apparently always hardlocked at 61
var num_warps = buffer_read(bu,buffer_u32);

var warp_list = [];
for (var i=0;i<num_warps;i++)
	{
	// xfrom, yfrom, xto, yto
	warp_list[i][0] = buffer_read(bu,buffer_s32);
	warp_list[i][1] = buffer_read(bu,buffer_s32);
	warp_list[i][2] = buffer_read(bu,buffer_s32);
	warp_list[i][3] = buffer_read(bu,buffer_s32);
	}
trace("Warp list: "+string(warp_list));

var bugz_list = [];
for (var i=0;i<4;i++)
	{
	// x,y,direction (0-3, 0: up, rotates clockwise 90)
	bugz_list[i][0] = buffer_read(bu,buffer_u32);
	bugz_list[i][1] = buffer_read(bu,buffer_u32);
	bugz_list[i][2] = buffer_read(bu,buffer_u32);
	}
trace("Bugz list: "+string(bugz_list));	

// finally, the actual note position data
s = buffer_read(bu,buffer_u32);
trace("Size of note table size: "+string(s));
newbuf = scr_decrypt_chunk(bu,s);
minibuf = newbuf.buffer_new;
minibuf_size = newbuf.size_final;
buffer_seek(minibuf,buffer_seek_start,0);
trace("buffer written, size: "+string(minibuf_size)+" ("+string(buffer_get_size(minibuf))+")");

for (var yy = 0; yy < 104; yy++)
	{
	for (var xx = 0; xx < 160; xx++)
		{
		var data = buffer_read(minibuf,buffer_u8);
		global.note_grid[xx][yy] = data;
		}
	}
buffer_delete(minibuf);

// ...then the control bit position data
s = buffer_read(bu,buffer_u32);
trace("Size of note table size: "+string(s));
newbuf = scr_decrypt_chunk(bu,s);
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
			if data == 34
			then array_push(startpos,[xx,yy])
			else global.ctrl_grid[xx][yy] = data;
			}
		}
	}
trace("Starting positions in control bit buffer: "+string(startpos));
buffer_delete(minibuf);

// Random Bullshit #4
var unkd = [];
repeat 16 array_push(unkd,buffer_read(bu,buffer_u8));
trace("Random Bullshit #4: "+string(unkd));

// Bugz metadata
var bugname_str = [];
var bugz_current_posdir = [];
var bugz_speed = [];
var bugz_paused = [];
var bugz_volume = [];
for (var i=0;i<4;i++)
	{
	var bugname_size = buffer_read(bu,buffer_u32);
	bugname_str[i] = "";
	repeat bugname_size bugname_str[i] += chr(buffer_read(bu,buffer_u8));
	
	// First two always 0,2, other two fractional takes possibly?
	repeat 4 buffer_read(bu,buffer_u32);
	
	// Current positions
	array_push(bugz_current_posdir,[buffer_read(bu,buffer_u32),buffer_read(bu,buffer_u32),buffer_read(bu,buffer_u32)]);
	
	// More unknowns
	repeat 4 buffer_read(bu,buffer_u32);
	
	// More unknowns (tweezers change last two u8s)
	repeat 4 buffer_read(bu,buffer_u8);
	
	bugz_speed[i] = buffer_read(bu,buffer_u32);
	bugz_paused[i] = buffer_read(bu,buffer_u32);
	bugz_volume[i] = buffer_read(bu,buffer_u32);
	}

// clear buffer
buffer_delete(bu);