event_inherited();

spr = [];
zoom = 0;
index = 0;

event_user(0);

delete_sprites = function(){
for (var xx=0;xx<array_length(spr);xx++)
for (var yy=0;yy<array_length(spr[xx]);yy++)
	{
	if sprite_exists(spr[xx][yy]) sprite_delete(spr[xx][yy]);
	}
return 0;
}

save_sprites = function(filename=""){

for (var xx=0; xx<array_length(spr);xx++)
	{
	// create surface strip
	var ww = sprite_get_width(spr[xx][0]) * array_length(spr[xx])-1;
	var hh = sprite_get_height(spr[xx][0]);
	var surf = surface_create(ww,hh);
	
	// draw sprites to surface strip
	surface_set_target(surf);
	draw_clear_alpha(c_black,0);
	for (var yy=0; yy<array_length(spr[xx]); yy++)
		{
		if sprite_exists(spr[xx][yy])
		draw_sprite(spr[xx][yy],0,sprite_get_width(spr[xx][yy])*yy,0);
		}
	surface_reset_target();
	
	// save strip to file, loop to next size
	//var f = filename_dir+(filename)+filename_name(filename)+"_"+string(xx)+filename_ext(filename);
	var f = filename_path(filename)+"anim"+string(xx)+".png";
	surface_save(surf,f);
	trace("surface saved to {0}",f);
	surface_free(surf);
	}
return 0;
}