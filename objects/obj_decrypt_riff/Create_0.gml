event_inherited();

image_xscale = 108;
image_yscale = 32;
image_blend = c_black;

dir = "";
snd = []; // sounds created from buffer
buf = []; // buffer for creating said sounds
index = 0;

event_user(0);

save_sounds = function(){
var f = get_save_filename_ext("*.wav","0.wav","%USERPROFILE%/Desktop","Save Bugz audio...");
if string_length(f)==0 then return 0;
f = filename_dir(f)+"/";
for (var i=0;i<array_length(buf);i++)
    {
    buffer_save(buf[i],f+string(i)+".wav");
    }
msg("Success! Look in "+f+" for a folder of .wavs!");
return 0;
}

/*
TODO: Display/extract/allow edit of RIFF text information
ie. name and description
*/