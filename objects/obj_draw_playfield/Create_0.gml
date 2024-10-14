pixel_surf = -1;
/*ctrl_surf = -1;
update_ctrl_surf = function(){
var ww = 160*16;
var hh = 104*16;
if !surface_exists(ctrl_surf) then ctrl_surf = surface_create(ww,hh);
surface_set_target(ctrl_surf);
draw_clear_alpha(c_black,0);
for (var xx = 0; xx < ww; xx+=16)
	{
	for (var yy = 0; yy < hh; yy+=16)
		{
		var data = ds_grid_get(global.ctrl_grid,xx/16,yy/16);
		if data > 0
			{
			if !global.use_external_assets
			draw_sprite(spr_note_ctrl,data-1,xx,yy)
			else draw_sprite(spr_note_ctrl2[data-1],0,xx,yy);
			}
		}
	}
surface_reset_target();
}
update_ctrl_surf_partial = function(xx,yy){
var ww = 160;
var hh = 104;
var data = ds_grid_get(global.ctrl_grid,xx,yy);
if !surface_exists(ctrl_surf) then update_ctrl_surf();
surface_set_target(ctrl_surf);

var rx = xx*16;
var ry = yy*16;

gpu_set_blendmode(bm_subtract);
draw_set_alpha(1);
draw_rectangle(rx,ry,rx+16,ry+16,false);
gpu_set_blendmode(bm_normal);

if data > 0
	{
	if !global.use_external_assets
	draw_sprite(spr_note_ctrl,data-1,rx,ry)
	else draw_sprite(spr_note_ctrl2[data-1],0,rx,ry);
	}
surface_reset_target();		
}*/
update_surf = function(){
var ww = 160;//ds_grid_width(global.pixel_grid);
var hh = 104;//ds_grid_height(global.pixel_grid);
if !surface_exists(pixel_surf) then pixel_surf = surface_create(ww*16,hh*16); //ww,hh
surface_set_target(pixel_surf);
draw_clear_alpha(c_black,0);
for (var xx = 0; xx < ww; xx++)
	{
	for (var yy = 0; yy < hh; yy++)
		{
		var data = ds_grid_get(global.pixel_grid,xx,yy);
		var data_ctrl = ds_grid_get(global.ctrl_grid,xx,yy);
		if data > 0 or data_ctrl > 0
			{
			if global.use_external_assets
				{
				draw_sprite(global.spr_note2[data_ctrl][data],0,xx*16,yy*16);
				}
			else 
				{
				draw_sprite(spr_note,data,xx*16,yy*16);
				draw_sprite(spr_note_ctrl,data_ctrl,xx*16,yy*16);
				}
			}
		}
	}

surface_reset_target();
}
update_surf_partial = function(xx,yy){
var data = ds_grid_get(global.pixel_grid,xx,yy);
var data_ctrl = ds_grid_get(global.ctrl_grid,xx,yy);
if !surface_exists(pixel_surf) then update_surf();
surface_set_target(pixel_surf);

if data > 0 or data_ctrl > 0
	{
	if global.use_external_assets
	draw_sprite(global.spr_note2[data_ctrl][data],0,xx*16,yy*16)
	else 
		{
		draw_sprite(spr_note,data,xx*16,yy*16);
		draw_sprite(spr_note_ctrl,data_ctrl,xx*16,yy*16);
		}
	}
else
	{
	gpu_set_blendmode(bm_subtract);
	draw_set_alpha(1);
	draw_rectangle(xx*16,yy*16,(xx*16)+16,(yy*16)+16,false);
	gpu_set_blendmode(bm_normal);
	}
surface_reset_target();
}