draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(x,bbox_top,str_name);
draw_text(x,bbox_top+16,str_author);
draw_text(x,bbox_top+32,str_desc);

if surface_exists(surf) then draw_surface_ext(surf,bbox_left,bbox_top+32+string_height(str_desc),surf_scale,surf_scale,0,c_white,1);
event_inherited();

