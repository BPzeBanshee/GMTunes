///@desc Draw cursor + stamp
if surface_exists(surf)
    {
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	var sw,sh,dx,dy,w,h;
	if device_mouse_y_to_gui(0) < 416
		{
		w = copy_w * 16;
		h = copy_h * 16;
		dx = floor(x/16)*16;
		dy = floor(y/16)*16;
		sw = dx - max(w,0);
		sh = dy - max(h,0);
		}
	else
		{
		var ssw = (surface_get_width(surf)/2);
		var ssh = (surface_get_height(surf)/2);
		var xview = camera_get_view_x(view_camera[0]);
		var yview = camera_get_view_y(view_camera[0]);
		sw = xview+(camera_get_view_width(view_camera[0])/2) - ssw;
		sh = yview+(camera_get_view_height(view_camera[0])/2) - ssh;
		dx = sw;
		dy = sh;
		w = -ssw*2;
		h = -ssh*2;
		}
	
	gpu_set_texfilter(false);
	draw_set_color(c_white);
	draw_rectangle(dx,dy,dx - w,dy - h,true);
	draw_surface_ext(surf,sw,sh,16,16,0,c_white,1);
	gpu_set_texfilter(global.use_texfilter);
    }
else if loaded update_surf();

