var _type = async_load[? "type"];
if (_type == "video_start")
	{
    display_video = true;
	trace("starting vid");
	}
else if (_type == "video_end")
	{
    display_video = false;
	trace("closing vid");
    video_close();
	instance_destroy();
	} 