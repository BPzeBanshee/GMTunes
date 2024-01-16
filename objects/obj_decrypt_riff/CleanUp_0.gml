// Feather disable GM1041
// GM 2023.6 Feather bug: expects real not soundid as arg to audio_free_buffer_sound
if array_length(buf) > 0
    {
    for (var i=0; i<array_length(snd); i++)
        {
        audio_free_buffer_sound(snd[i]);
        buffer_delete(buf[i]);
        }
    }