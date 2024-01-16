/*
obj_movieplayer

Test of GM's movie playback abilities: doesn't support SMKs out-of-the-box, no surprise
*/
display_video = false;
var f = get_open_filename("*.SMK","SIMTUNES.SMK");
if f != ""
	{
	video_open(f);
	display_video = true;
	var _status = video_get_status();
	trace("_status: "+string(_status));
	}