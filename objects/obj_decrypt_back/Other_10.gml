///@desc Get file
var f = get_open_filename("*.BAC","");
if f == ""
	{
	instance_destroy();
	exit;
	}

spr = bac_load(f);