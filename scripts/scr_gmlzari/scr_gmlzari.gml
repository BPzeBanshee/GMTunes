function gmlzari_init(){
var dll = "gmlzari64.dll";
var call = dll_cdecl;
global.dll_gmlzari_version = external_define(dll,"get_version",call,ty_string,0);
global.dll_gmlzari_encode_file = external_define(dll,"encode_file",call,ty_real,2,ty_string,ty_string);
global.dll_gmlzari_decode_file = external_define(dll,"decode_file",call,ty_real,2,ty_string,ty_string);
}

function gmlzari_free(){
external_free("gmlzari64.dll");
global.dll_gmlzari_version = -1;
global.dll_gmlzari_encode_file = -1;
global.dll_gmlzari_decode_file = -1;
return 0;
}

function gmlzari_version(){
var e = external_call(global.dll_gmlzari_version);
return e;
}

function gmlzari_encode_file(in,out){
var e = external_call(global.dll_gmlzari_encode_file,in,out);
return e;
}

function gmlzari_decode_file(in,out){
var e = external_call(global.dll_gmlzari_decode_file,in,out);
return e;
}