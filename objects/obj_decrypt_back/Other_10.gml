///@desc Get file
var f = get_open_filename("*.BAC","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}
mystruct = bac_load(f,true);
trace(mystruct);