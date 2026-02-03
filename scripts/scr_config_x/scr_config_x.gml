function scr_config_load(inifile=game_save_id+"/GMTunes.ini"){
ini_open(inifile);
global.debug = ini_read_real("Core","debug",true);
global.main_dir = ini_read_string("Core","simtunes_dir","");
global.use_external_assets = ini_read_real("Core","use_external_assets",true);
global.music_volume = ini_read_real("Core","music_volume",50);
global.use_texfilter = ini_read_real("Core","use_texture_filtering",false);
global.target_framerate = ini_read_real("Core","target_framerate",60);
//if os_type == os_operagx global.use_external_assets = false;

// TODO: sound output
// TODO: "performance mode"

// TODO: interface sounds
global.function_tile_clicks = ini_read_real("SimTunes","function_tile_clicks",false);
// TODO: auto pop-up menu
// TODO: warning boxes

global.display_on_palette = ini_read_real("SimTunes","display_on_palette",0);
global.display_on_tiles = ini_read_real("SimTunes","display_on_tiles",1);
// Key scale not saved in SimTunes, done so here for convenience
global.key_scale = ini_read_real("SimTunes","key_scale",KEY_SCALE.MAJOR);
ini_close();
}

function scr_config_save(inifile=game_save_id+"/GMTunes.ini"){
// Feather disable GM1041
ini_open(inifile);
ini_write_real("Core","debug",global.debug);
ini_write_string("Core","simtunes_dir",global.main_dir);
ini_write_real("Core","use_external_assets",global.use_external_assets);
ini_write_real("Core","music_volume",global.music_volume);
ini_write_real("Core","use_texture_filtering",global.use_texfilter);
ini_write_real("Core","target_framerate",global.target_framerate);

ini_write_real("SimTunes","function_tile_clicks",global.function_tile_clicks);
ini_write_real("SimTunes","display_on_palette",global.display_on_palette);
ini_write_real("SimTunes","display_on_tiles",global.display_on_tiles);
ini_write_real("SimTunes","key_scale",global.key_scale);
ini_close();
}

function scr_config_reset(){
scr_config_load("asdf");
find_default_simtunes_dir();
scr_config_save();
}