///@desc Reload BMP
if sprite_exists(spr) then sprite_delete(spr);
if surface_exists(surf) then surface_free(surf);
event_user(0);