if !surface_exists(pixel_surf)
update_surf()
else draw_surface_ext(pixel_surf,0,0,1,1,0,c_white,1);
/*else 
	{
	var cam = camera_get_active();
	var xx = camera_get_view_x(cam);
	var yy = camera_get_view_y(cam);
	draw_surface_part(pixel_surf,xx,yy,640,480,xx,yy);
	}*/
//draw_flags();