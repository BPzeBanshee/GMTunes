///@desc Create buttons/array list
window_set_caption("GMTunes");

loading = false;

start_game = function(){
loading = true;
alarm[0] = 1;
}

start_debug = function(){
room_goto(rm_debug_tools);
instance_destroy();
}

exit_game = function(){
game_end();
}


// First, array list
txta = []; evt = [];
array_push(txta,"START GAME");		array_push(evt,start_game);
array_push(txta,"DEBUG TOOLS");		array_push(evt,start_debug);
array_push(txta,"EXIT TO WINDOWS");	array_push(evt,exit_game);

// Create buttons
for (var i=0; i<array_length(txta); i++)
    {
    button[i] = instance_create_depth(x,y+(64*i),-1,obj_button);
    button[i].txt = txta[i];
    }
	
var f1 = game_save_id+"TUNERES.DAT_ext/startup.WAV";
var f2 = game_save_id+"TUNERES.DAT_ext/Startup2.bmp";
b = -1;
if file_exists(f1)
	{
	trace(f1);
	b = wav_load(f1,true);
	audio_play_sound(b,0,true);
	}
if file_exists(f2)
	{
	bmp = bmp_load(f2);
	spr = sprite_create_from_surface(bmp,0,0,640,480,false,false,0,0);
	}