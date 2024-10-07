// method list
populate_list = function(list,filename){
var result = file_find_first(filename,fa_none);
while (result != "")
	{
    array_push(list, result);
	result = file_find_next();
	}
}

load_bug_metadata = function(filename){
var name = "";
var desc = "";
var spr = -1;

// Load file into buffer, do some error checking
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,filename,0);

if buffer_word(bu,0) != "FORM"
    {
    msg("File doesn't match SimTunes BUGZ format.");
    instance_destroy();
    }
    
var offset = 0;
var s = buffer_peek_be32(bu,4); // Big Endian record of filesize according to FORM metadata
var s2 = buffer_get_size(bu); // actual size of file loaded into buffer, s + 8 usually

// "TEXT", container for name
if buffer_word(bu,offset) != "TEXT"
then do offset += 1 until buffer_word(bu,offset) == "TEXT" || offset >= s2;

var size = buffer_peek_be32(bu,offset+4);// 4 bytes after RIFF for filesize
var eof = offset + size + 8;
//trace("\\n");
//trace("TEXT found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));

for (var i=offset+8;i<eof;i++) name += chr(buffer_peek(bu,i,buffer_u8));
//trace(name);

// "INFO" (animation on note hit sprite)
if buffer_word(bu,offset) != "INFO"
then do offset += 1 until buffer_word(bu,offset) == "INFO" || offset >= s2;
    
// Establish size of file
size = buffer_peek_be32(bu,offset+4); // 4 bytes after RIFF for filesize
eof = offset + size + 8;
//trace("INFO found, offset: "+string(offset)+", size: "+string(size)+", eof:"+string(eof));

// Get description
for (var i=offset+8;i<eof;i++) desc += chr(buffer_peek(bu,i,buffer_u8));
//trace(desc);
//str_desc = string_wordwrap_width(str_desc,256,chr(10),false);

// Search until "SHOW" is found
do offset += 1 until buffer_word(bu,offset) == "SHOW" || offset >= s2;
buffer_seek(bu,buffer_seek_start,offset);
spr = bitmap_load_from_buffer(bu);

// Free buffer
buffer_delete(bu);

return {name,desc,spr};
}

// some dicking around here to make ui work in playfield
var cam = view_camera[0];
cam_pos = [camera_get_view_x(cam),camera_get_view_y(cam)];
cam_siz = [camera_get_view_width(cam),camera_get_view_height(cam)];
camera_set_view_pos(cam,0,0);
camera_set_view_size(cam,640,480);

with obj_button_dgui enabled = false;
with obj_bug paused = true;
loading_prompt = false;
done = false;

// variable init
back = -1;
select_a = 1;
select_am = 1;
var o = obj_ctrl_playfield;
var bug_list = [o.bug_yellow,o.bug_green,o.bug_blue,o.bug_red];
for (var i=0;i<4;i++) 
	{
	bug_index[i] = 0;
	bug_pos[i] = 0;
	
	if instance_exists(bug_list[i]) 
		{
		if bug_list[i].bugzid > 0
		bug_index[i] = bug_list[i].bugzid - 1;
		trace("bug index "+string(i)+" set to "+string(bug_index[i]));
		}
	}
	
instance_deactivate_object(o);

back = bmp_load_sprite(game_save_id+"/TUNERES.DAT_ext/Loadbugz.bmp");
dir = global.main_dir+"/BUGZ/";

list_yellow = [];
list_green = [];
list_blue = [];
list_red = [];

populate_list(list_yellow,dir+"YELLOW*.bug");
populate_list(list_green,dir+"GREEN*.bug");
populate_list(list_blue,dir+"BLUE*.bug");
populate_list(list_red,dir+"RED*.bug");
//trace(list_yellow);
//trace(list_green);
//trace(list_blue);
//trace(list_red);

var lists = [list_yellow,list_green,list_blue,list_red];
for (var xx=0;xx<4;xx++)
	{
	for (var yy=0; yy < array_length(lists[xx]); yy++)
		{
		bug[xx][yy] = load_bug_metadata(dir+lists[xx][yy]);
		}
	}