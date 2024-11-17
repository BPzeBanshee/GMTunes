pixel_surf = -1;
update_surf = function(){
var ww = 160;
var hh = 104;
if !surface_exists(pixel_surf) then pixel_surf = surface_create(ww*16,hh*16); //ww,hh
surface_set_target(pixel_surf);
draw_clear_alpha(c_black,0);

// Draw notes
for (var yy = 0; yy < hh; yy++)
	{
	for (var xx = 0; xx < ww; xx++)
		{
		var data = global.note_grid[xx][yy];
		var data_ctrl = global.ctrl_grid[xx][yy];
		if data_ctrl == 34 data_ctrl = 0;
		if data > 0 or data_ctrl > 0
			{
			if global.use_external_assets
				{
				draw_sprite(global.spr_note2[data_ctrl][data],0,xx*16,yy*16);
				}
			else 
				{
				if data > 0 draw_sprite(spr_note,data-1,xx*16,yy*16);
				if data_ctrl > 0 draw_sprite(spr_note_ctrl,data_ctrl-1,xx*16,yy*16);
				}
			}
		}
	}
surface_reset_target();
}

update_surf_partial = function(xx,yy){
var data = global.note_grid[xx][yy];
var data_ctrl = global.ctrl_grid[xx][yy];
if data_ctrl == 34 data_ctrl = 0;
if !surface_exists(pixel_surf) then update_surf();
surface_set_target(pixel_surf);

if data > 0 or data_ctrl > 0
	{
	if global.use_external_assets
	draw_sprite(global.spr_note2[data_ctrl][data],0,xx*16,yy*16)
	else 
		{
		if data > 0 draw_sprite(spr_note,data-1,xx*16,yy*16);
		if data_ctrl > 0 draw_sprite(spr_note_ctrl,data_ctrl-1,xx*16,yy*16);
		}
	}
else
	{
	gpu_set_blendmode(bm_subtract);
	draw_set_alpha(1);
	draw_rectangle(xx*16,yy*16,(xx*16)+15,(yy*16)+15,false);
	gpu_set_blendmode(bm_normal);
	}
surface_reset_target();
}

update_surf_zone = function(xx,yy,w,h){
if !surface_exists(pixel_surf) then update_surf();
surface_set_target(pixel_surf);
for (var ny=0; ny<h; ny++)
	{
	for (var nx=0; nx<w; nx++)
		{
		var _x = xx+nx;
		var _y = yy+ny;
		var data = global.note_grid[_x][_y];
		var data_ctrl = global.ctrl_grid[_x][_y];
		if data_ctrl == 34 data_ctrl = 0;
		
		if data > 0 or data_ctrl > 0
			{
			if global.use_external_assets
			draw_sprite(global.spr_note2[data_ctrl][data],0,_x*16,_y*16)
			else 
				{
				if data > 0 draw_sprite(spr_note,data-1,_x*16,_y*16);
				if data_ctrl > 0 draw_sprite(spr_note_ctrl,data_ctrl-1,_x*16,_y*16);
				}
			}
		else
			{
			gpu_set_blendmode(bm_subtract);
			draw_set_alpha(1);
			draw_rectangle(_x*16,_y*16,(_x*16)+15,(_y*16)+15,false);
			gpu_set_blendmode(bm_normal);
			}
		}
	}
	
surface_reset_target();
}

draw_flags = function(){
// Draw flags on top
var ind = 0;
var spr = spr_flag;
for (var i=0;i<4;i++)
	{
	// Create flags
	if global.flag_list[i][2] > -1
		{
		var fx = (global.flag_list[i][0] * 16);
		var fy = (global.flag_list[i][1] * 16);
		var g = xy_to_gui(fx,fy);
		var g2 = 8;
		if global.zoom == 1 g2 /= 2;
		if global.zoom == 0 g2 /= 4;
		
		// establish flag direction
		var ang = 0;
		switch global.flag_list[i][2]
			{
			default: break;
			case 0: ang = 1; break;
			case 270: ang = 2; break;
			case 180: ang = 3; break;
			}
			
		// Sprite asset/scale
		var d = 0;
		var sc = 1;
		if global.use_external_assets
			{
			spr = global.spr_flag2[global.zoom][i][ang];
			}
		else 
			{
			d = global.flag_list[i][2];
			ind = i;
			switch global.zoom
				{
				default: break;
				case 1: sc = 0.5; break;
				case 0: sc = 0.25; break;
				}
			}
		draw_sprite_ext(spr,ind,g.gx+g2,g.gy+g2,sc,sc,d,c_white,1); //g.gx+g2,g.gy+g2
		}
	}
}