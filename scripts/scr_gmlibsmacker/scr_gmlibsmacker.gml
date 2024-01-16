function gmlibsmacker_init(){
var dll = "gmlibsmacker64.dll";
var call = dll_cdecl;
global.dll_gmlibsmacker_version = external_define(dll,"get_version",call,ty_string,0);
global.dll_gmlibsmacker_open_smk = external_define(dll,"open_smk",call,ty_real,1,ty_string);
global.dll_gmlibsmacker_close_smk = external_define(dll,"close_smk",call,ty_real,0);

global.dll_gmlibsmacker_get_audio_track_count = external_define(dll,"get_audio_track_count",call,ty_real,0);
global.dll_gmlibsmacker_get_audio_channels = external_define(dll,"get_audio_channels",call,ty_real,1,ty_real);
global.dll_gmlibsmacker_get_audio_bitdepth = external_define(dll,"get_audio_bitdepth",call,ty_real,1,ty_real);
global.dll_gmlibsmacker_get_audio_frequency = external_define(dll,"get_audio_frequency",call,ty_real,1,ty_real);
global.dll_gmlibsmacker_get_audio_size = external_define(dll,"get_audio_size",call,ty_real,1,ty_real);

global.dll_gmlibsmacker_get_video_width = external_define(dll,"get_video_width",call,ty_real,0);
global.dll_gmlibsmacker_get_video_height = external_define(dll,"get_video_height",call,ty_real,0);
global.dll_gmlibsmacker_get_video_y_mode = external_define(dll,"get_video_y_mode",call,ty_real,0);
global.dll_gmlibsmacker_get_video_frame_count = external_define(dll,"get_video_frame_count",call,ty_real,0);
global.dll_gmlibsmacker_get_video_frame_rate = external_define(dll,"get_video_frame_rate",call,ty_real,0);

global.dll_gmlibsmacker_load_bitmap = external_define(dll,"load_bitmap",call,ty_real,2,ty_string,ty_real);
global.dll_gmlibsmacker_load_audio = external_define(dll,"load_audio",call,ty_real,3,ty_string,ty_real,ty_real);
}

function gmlibsmacker_free(){
external_free("gmlibsmacker64.dll");
global.dll_gmlibsmacker_version = -1;
global.dll_gmlibsmacker_open_smk = -1;
global.dll_gmlibsmacker_close_smk = -1;

global.dll_gmlibsmacker_get_audio_track_count = -1;
global.dll_gmlibsmacker_get_audio_channels = -1;
global.dll_gmlibsmacker_get_audio_bitdepth = -1;
global.dll_gmlibsmacker_get_audio_frequency = -1;
global.dll_gmlibsmacker_get_audio_size = -1;

global.dll_gmlibsmacker_get_video_width = -1;
global.dll_gmlibsmacker_get_video_height = -1;
global.dll_gmlibsmacker_get_video_y_mode = -1;
global.dll_gmlibsmacker_get_video_frame_count = -1;
global.dll_gmlibsmacker_get_video_frame_rate = -1;

global.dll_gmlibsmacker_load_bitmap = -1;
global.dll_gmlibsmacker_load_audio = -1;
return 0;
}

function gmlibsmacker_version(){
var e = external_call(global.dll_gmlibsmacker_version);
return e;
}

function gmlibsmacker_open_smk(file){
var e = external_call(global.dll_gmlibsmacker_open_smk,file);
return e;
}

function gmlibsmacker_close_smk(){
var e = external_call(global.dll_gmlibsmacker_close_smk);
return e;
}

// ========= AUDIO FUNCTIONS ===========

function gmlibsmacker_get_audio_track_count(){
var e = external_call(global.dll_gmlibsmacker_get_audio_track_count);
return e;
}

function gmlibsmacker_get_audio_channels(track=0){
var e = external_call(global.dll_gmlibsmacker_get_audio_channels,track);
return e;
}

function gmlibsmacker_get_audio_bitdepth(track=0){
var e = external_call(global.dll_gmlibsmacker_get_audio_bitdepth,track);
return e;
}

function gmlibsmacker_get_audio_frequency(track=0){
var e = external_call(global.dll_gmlibsmacker_get_audio_frequency,track);
return e;
}

function gmlibsmacker_get_audio_size(track=0){
var e = external_call(global.dll_gmlibsmacker_get_audio_size,track);
return e;
}

// ========== VIDEO FUNCTIONS ============

function gmlibsmacker_get_video_width(){
var e = external_call(global.dll_gmlibsmacker_get_video_width);
return e;
}

function gmlibsmacker_get_video_height(){
var e = external_call(global.dll_gmlibsmacker_get_video_height);
return e;
}

function gmlibsmacker_get_video_y_mode(){
var e = external_call(global.dll_gmlibsmacker_get_video_y_mode);
return e;
}

function gmlibsmacker_get_video_frame_count(){
var e = external_call(global.dll_gmlibsmacker_get_video_frame_count);
return e;
}

function gmlibsmacker_get_video_frame_rate(){
var e = external_call(global.dll_gmlibsmacker_get_video_frame_rate);
return e;
}

// ========== RENDER FUNCTIONS =============

function gmlibsmacker_load_audio(snd_buffer,size,track=0){
var e = external_call(global.dll_gmlibsmacker_load_audio,snd_buffer,size,track);
return e;
}

function gmlibsmacker_load_bitmap(bmp_buffer,frame){
var e = external_call(global.dll_gmlibsmacker_load_bitmap,bmp_buffer,frame);
return e;
}