///@desc .STP "STP2" Format (script)
// Get filename + open approval
var f = get_open_filename("*.STP","");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}

// reset surface if present
if surface_exists(surf) then surface_free(surf);

// reset strings if reloading
name = "";
author = "";
desc = "";

mystamp = stamp_load(f);
name = mystamp.name;
author = mystamp.author;
desc = mystamp.desc;
surf = mystamp.surf;