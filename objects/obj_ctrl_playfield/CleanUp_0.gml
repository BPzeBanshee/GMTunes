global.note_grid = [];
global.ctrl_grid = [];
global.playfield = {};
window_set_caption("GMTunes"); 

if use_classic_gui
	{
	var a = struct_get_names(gui);
	var b = struct_names_count(gui);
	for (var i=0;i<b;i++)
		{
		var s = struct_get(gui,a[i]);
		if sprite_exists(s) sprite_delete(s);
		}
	}