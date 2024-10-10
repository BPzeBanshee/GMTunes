///@desc Play set of notes
var mynotes = [0,2,4,5,7,9,11,12];
var b = bug[snd_index_x][snd_index_y];
var m = audio_play_sound(b.sounds.snd[mynotes[snd_count]],0,false);
snd_count++;
if snd_count<8 alarm[2] = audio_sound_length(m)*60;
//trace("alarm[2] called, set to {0}",alarm[2]);