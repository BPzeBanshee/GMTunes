var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if global.use_external_assets
	{
	var ang;
	switch global.flag_list[flag_id][2]-90
		{
		case 90: ang = 0; break;
		default: ang = 1; break;
		case 270: case -90: ang = 2; break;
		case 180: ang = 3; break;
		}
	var spr = global.spr_ui.flags[flag_id][ang];//global.spr_flag2[flag_id] : spr_flag;
	draw_sprite(global.spr_ui.ctrl[0],0,mx,my);
	draw_sprite_ext(spr,0,mx+16,my+16,1,1,0,c_white,1);
	}
else
	{
	var ang = global.flag_list[flag_id,2] == -1 ? 0 : global.flag_list[flag_id,2]-90;
	draw_sprite_ext(spr_flag,flag_id,mx,my,1,1,ang,c_white,1);
	}