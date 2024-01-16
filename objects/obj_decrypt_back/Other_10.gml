///@desc Get file
var f = get_open_filename("*.BAC","");
if f == ""
	{
	instance_destroy();
	return 0;
	}

spr = bac_load(f);