pixel_surf = -1;
update_surf = function(){
var ww = 160;//ds_grid_width(global.pixel_grid);
var hh = 104;//ds_grid_height(global.pixel_grid);
if !surface_exists(pixel_surf) then pixel_surf = surface_create(ww*16,hh*16); //ww,hh
surface_set_target(pixel_surf);
draw_clear_alpha(c_black,0);

// Draw notes
for (var xx = 0; xx < ww; xx++)
	{
	for (var yy = 0; yy < hh; yy++)
		{
		var data = ds_grid_get(global.pixel_grid,xx,yy);
		var data_ctrl = ds_grid_get(global.ctrl_grid,xx,yy);
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
var data = ds_grid_get(global.pixel_grid,xx,yy);
var data_ctrl = ds_grid_get(global.ctrl_grid,xx,yy);
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
		var data = ds_grid_get(global.pixel_grid,_x,_y);
		var data_ctrl = ds_grid_get(global.ctrl_grid,_x,_y);
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
		var fx = global.flag_list[i][0] * 16;
		var fy = global.flag_list[i][1] * 16;
		var dir = global.flag_list[i][2];
		if global.use_external_assets
		spr = global.spr_flag2[i]
		else ind = i;
		draw_sprite_ext(spr,ind,fx+8,fy+8,1,1,dir,c_white,1);
		}
	}
}