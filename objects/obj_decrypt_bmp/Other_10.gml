/// @desc .BMP Loading
var f = get_open_filename("Windows Bitmap|*.BMP","");
if f == ""
	{
	instance_destroy();
	return 0;
	}

surf = bmp_load(f);
trace("bmp_load returned "+string(surf));

if surface_exists(surf)
	{
	var ww = surface_get_width(surf);
	var hh = surface_get_height(surf);
	spr = sprite_create_from_surface(surf,0,0,ww,hh,false,false,ww/2,hh/2);
	trace("spr returned "+string(spr));
	surface_free(surf);
	}
else instance_destroy();