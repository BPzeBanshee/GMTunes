if !display_video then exit;
var _data = video_draw();
var _status = _data[0];

if (_status == 0)
	{
    var _surface = _data[1];
	image_xscale = surface_get_width(_surface);
	image_yscale = surface_get_height(_surface);
    draw_surface(_surface, x, y);
	} 