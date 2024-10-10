///@desc .WAV Playback Test
var f = get_open_filename_ext("*.WAV","",@"C:/SimTunes/SIMTUNES/BUGZ/","Load .WAV...");
trace("f: "+string(f));

if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}
	
snd[0] = wav_load(f);
index = 0;