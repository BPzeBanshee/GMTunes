///@desc Change Bug Speed
// Feather disable GM2016
var i_d = ds_map_find_value(async_load, "id");
if (i_d == dialog)
	{
    if (ds_map_find_value(async_load, "status"))
		{
        var spd = clamp(ds_map_find_value(async_load, "value"),-1,8);
		with obj_bug
			{
			gear = spd;
			calculate_timer();
			}
		dialog = -1;
		}
	}