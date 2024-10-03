if sprite_exists(spr_notehit_sheet) sprite_delete(spr_notehit_sheet);
for (var i=0;i<8;i++)
	{
	if sprite_exists(spr_notehit_tl[i]) sprite_delete(spr_notehit_tl[i]);
	if sprite_exists(spr_notehit_tr[i]) sprite_delete(spr_notehit_tr[i]);
	if sprite_exists(spr_notehit_bl[i]) sprite_delete(spr_notehit_bl[i]);
	if sprite_exists(spr_notehit_br[i]) sprite_delete(spr_notehit_br[i]);
	}