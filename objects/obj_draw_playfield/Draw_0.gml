if !surface_exists(pixel_surf)
update_surf()
else draw_surface_ext(pixel_surf,0,0,1,1,0,c_white,1);

// Draw flags on top
var ind = 0;
var xx = 0;
var yy = 0;
var dir = 0;
var spr = spr_flag;
for (var i=0;i<4;i++)
	{
	// Create flags
	if global.flag_list[i][2] > -1
		{
		xx = global.flag_list[i][0] * 16;
		yy = global.flag_list[i][1] * 16;
		dir = global.flag_list[i][2];
		if global.use_external_assets
		spr = global.spr_flag2[i]
		else ind = i;
		draw_sprite_ext(spr,ind,xx+8,yy+8,1,1,dir,c_white,1);
		}
	}

/*if !surface_exists(ctrl_surf)
then update_ctrl_surf()
else draw_surface_ext(ctrl_surf,0,0,1,1,0,c_white,1);*/