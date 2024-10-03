if mode == 0
	{
	draw_sprite_ext(spr_notehit_sheet,0,x-sw,y-sh,1,1,0,c_white,1);
	}
else 
	{
	draw_sprite(spr_notehit_tl[spr_index],0,x,y);
	draw_sprite(spr_notehit_tr[spr_index],0,x,y);
	draw_sprite(spr_notehit_bl[spr_index],0,x,y);
	draw_sprite(spr_notehit_br[spr_index],0,x,y);
	}
event_inherited();