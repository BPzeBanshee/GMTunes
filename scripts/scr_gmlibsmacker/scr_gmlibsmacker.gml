function gmlibsmacker_init(){
var dll = "gmlibsmacker64.dll";
var call = dll_cdecl;

global.dll_gmlibsmacker = {
	version: external_define(dll,"get_version",call,ty_string,0),
	open_smk: external_define(dll,"open_smk",call,ty_real,1,ty_string),
	close_smk: external_define(dll,"close_smk",call,ty_real,0),

	get_audio_track_count: external_define(dll,"get_audio_track_count",call,ty_real,0),
	get_audio_channels: external_define(dll,"get_audio_channels",call,ty_real,1,ty_real),
	get_audio_bitdepth: external_define(dll,"get_audio_bitdepth",call,ty_real,1,ty_real),
	get_audio_frequency: external_define(dll,"get_audio_frequency",call,ty_real,1,ty_real),
	get_audio_size: external_define(dll,"get_audio_size",call,ty_real,1,ty_real),

	get_video_width: external_define(dll,"get_video_width",call,ty_real,0),
	get_video_height: external_define(dll,"get_video_height",call,ty_real,0),
	get_video_y_mode: external_define(dll,"get_video_y_mode",call,ty_real,0),
	get_video_frame_count: external_define(dll,"get_video_frame_count",call,ty_real,0),
	get_video_frame_rate: external_define(dll,"get_video_frame_rate",call,ty_real,0),

	load_bitmap: external_define(dll,"load_bitmap",call,ty_real,2,ty_string,ty_real),
	load_audio: external_define(dll,"load_audio",call,ty_real,3,ty_string,ty_real,ty_real)
	}
}

function gmlibsmacker_free(){
external_free("gmlibsmacker64.dll");
global.dll_gmlibsmacker = -1;
return 0;
}

function gmlibsmacker_version(){
var e = external_call(global.dll_gmlibsmacker.version);
return e;
}

function gmlibsmacker_open_smk(file){
var e = external_call(global.dll_gmlibsmacker.open_smk,file);
return e;
}

function gmlibsmacker_close_smk(){
var e = external_call(global.dll_gmlibsmacker.close_smk);
return e;
}

// ========= AUDIO FUNCTIONS ===========

function gmlibsmacker_get_audio_track_count(){
var e = external_call(global.dll_gmlibsmacker.get_audio_track_count);
return e;
}

function gmlibsmacker_get_audio_channels(track=0){
var e = external_call(global.dll_gmlibsmacker.get_audio_channels,track);
return e;
}

function gmlibsmacker_get_audio_bitdepth(track=0){
var e = external_call(global.dll_gmlibsmacker.get_audio_bitdepth,track);
return e;
}
/// @desc Returns the intended audio frequency of the opened .smk's selected audio channel content in Hz.
/// @param {real} [track]=0 Description
/// @returns {real} audio channel frequency in Hz
function gmlibsmacker_get_audio_frequency(track=0){
var e = external_call(global.dll_gmlibsmacker.get_audio_frequency,track);
return e;
}

/// @desc Returns the size of the opened .smk's selected audio channel content in bytes.
/// @param {real} [track]=0 The selected audio channel (supported: 0-6)
/// @returns {real} Track size in bytes
function gmlibsmacker_get_audio_size(track=0){
var e = external_call(global.dll_gmlibsmacker.get_audio_size,track);
return e;
}

// ========== VIDEO FUNCTIONS ============
/// @desc Returns the video width of the opened .smk. 
/// @returns {real}
function gmlibsmacker_get_video_width(){
var e = external_call(global.dll_gmlibsmacker.get_video_width);
return e;
}

/// @desc Returns the video height of the opened .smk. 
/// @returns {real}
function gmlibsmacker_get_video_height(){
var e = external_call(global.dll_gmlibsmacker.get_video_height);
return e;
}

/// @desc Returns the y-scaling mode of the opened .smk. 
/// @returns {real} (-1: failure, supported: 0-2)
function gmlibsmacker_get_video_y_mode(){
var e = external_call(global.dll_gmlibsmacker.get_video_y_mode);
return e;
}

/// @desc Returns the total amount of video frames of the opened .smk
/// @returns {real}
function gmlibsmacker_get_video_frame_count(){
var e = external_call(global.dll_gmlibsmacker.get_video_frame_count);
return e;
}

/// @desc Returns the intended video framerate of the opened .smk
/// @returns {real}
function gmlibsmacker_get_video_frame_rate(){
var e = external_call(global.dll_gmlibsmacker.get_video_frame_rate);
return e;
}

// ========== RENDER FUNCTIONS =============

/// @desc Loads the .smk audio into a given buffer
/// @param {Pointer} snd_buffer Pointer to your GML-side audio buffer
/// @param {real} size Size of your GML-side buffer
/// @param {real} [track]=0 Track number (supported: 0-6)
/// @returns {real} 0: success, -1: failure
function gmlibsmacker_load_audio(snd_buffer,size,track=0){
var e = external_call(global.dll_gmlibsmacker.load_audio,snd_buffer,size,track);
return e;
}

/// @desc Loads a video image of the indicated frame number from the .smk into a given buffer
/// @param {Pointer} bmp_buffer Pointer to your GML-side video buffer
/// @param {real} frame Frame number of the video
/// @returns {real} (0: success, -1: failure)
function gmlibsmacker_load_bitmap(bmp_buffer,frame){
var e = external_call(global.dll_gmlibsmacker.load_bitmap,bmp_buffer,frame);
return e;
}