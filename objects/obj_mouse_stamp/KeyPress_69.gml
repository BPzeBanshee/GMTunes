///@desc Rotate Grid Right
var ww = width;
var hh = height;
var grid2 = ds_grid_create(hh,ww);

for (var xx=0; xx<ww; xx++)
	{
	for (var yy=0; yy<hh; yy++)
		{
		var data = ds_grid_get(grid,xx,yy);
		if data > 0 ds_grid_set(grid2,height-yy,xx,data);
		}
	}

ds_grid_copy(grid,grid2);
width = ds_grid_width(grid);
height = ds_grid_height(grid);
ds_grid_destroy(grid2);

// update surface
update_surf(hh,ww);