if global.use_external_assets
	{
	// Deactivate button crap first
	if room == rm_debug_tools
		{
		instance_deactivate_object(obj_menu_tools);
		instance_deactivate_object(obj_button);
		}
	
	// Load background image
	var f1 = TUNERES+"startup.WAV";
	if file_exists(f1)
		{
		myspr = bmp_load_sprite(TUNERES+"About.bmp");
		mysnd = wav_load(f1,true);
		audio_play_sound(mysnd,0,true);
		}
	
	// Load credits text from string table
	txt_y = 480;	
	txt_credits = "";
	for (var i=0;i<95;i++)
		{
		txt_credits += global.string_table[i,3] + "\n";
		if i > 4 txt_credits += "\n";
		}
	}
else
	{
	// TODO: alt. credits text
	show_message("obj_menu_about called, call the other one bro");
	instance_destroy();
	}