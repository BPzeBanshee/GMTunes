///@desc Save buffer to file in a convenient folder
var f = get_save_filename_ext("*.wav","0.wav","%USERPROFILE%/Desktop","Save Bugz audio...");
if f == "" then return 0;
f = filename_dir(f)+"/";
for (var i=0;i<array_length(buf);i++)
    {
    buffer_save(buf[i],f+string(i)+".wav");
    }
msg("Success! Look in "+f+" for a folder of .wavs!");