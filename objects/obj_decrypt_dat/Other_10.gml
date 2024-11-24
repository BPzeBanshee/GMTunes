//var d = environment_get_variable("USERPROFILE")+"/Desktop";
///@desc extract_lzari_dat script
var f = get_open_filename_ext(".DAT","TUNERES.DAT",global.main_dir,"Open LZARI (NOT string table) .DAT File...");
if string_length(f) == 0
	{
	instance_destroy();
	exit;
	}
var f2 = get_save_filename_ext("","",game_save_id,"Save LZARI directories to...");
if string_length(f2) == 0
	{
	instance_destroy();
	exit;
	}
if !variable_global_exists("dll_gmlzari_version") gmlzari_init();
extract_lzari_dat(f,f2,false);
if variable_global_exists("dll_gmlzari_version") gmlzari_free();