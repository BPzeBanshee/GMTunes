///@desc Free sprites
for (var ff=0;ff<array_length(spr);ff++)
	{
	//if surface_exists(surf[ff]) then surface_free(surf[ff]);
	if sprite_exists(spr[ff]) then sprite_delete(spr[ff]);
	}