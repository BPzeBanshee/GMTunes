draw_set_alpha(alpha);
draw_set_valign(fa_middle);

if mode == 0 then draw_sprite(spr_logo1,0,0,0);
if mode == 1 then draw_sprite(spr_logo2,0,0,0);
// mode 2 loads for mode 3
if mode == 3 && surface_exists(surf) then draw_surface(surf,0,0);