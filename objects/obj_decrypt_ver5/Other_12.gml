///@desc scr_decrypt_chunk test
var f = get_open_filename(".TUN","");
if f == ""
	{
	instance_destroy();
	exit;
	}
	
var bu = buffer_create(8,buffer_grow,1);
buffer_load_ext(bu,f,0);

newchunk = scr_decrypt_chunk(bu,buffer_get_size(bu));
trace("size: "+string(buffer_get_size(newchunk)));