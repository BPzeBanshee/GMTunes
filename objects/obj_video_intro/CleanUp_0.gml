if sprite_exists(spr_logo1) then sprite_delete(spr_logo1);
if sprite_exists(spr_logo2) then sprite_delete(spr_logo2);

if audio_exists(s) then audio_free_buffer_sound(s);
	
if surface_exists(surf) then surface_free(surf);
buffer_delete(bmp_buffer);
buffer_delete(snd_buffer);

gmlibsmacker_close_smk();