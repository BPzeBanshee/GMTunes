if surface_exists(surf[surf_side]) 
    {
    var ww = (surface_get_width(surf[surf_side]) / 2) * surf_scale;
    var hh = (surface_get_height(surf[surf_side]) / 2) * surf_scale;
    image_xscale = ww;
    image_yscale = hh;
    var xx = x + lengthdir_x(ww,direction+180) + lengthdir_x(hh,direction+90);
    var yy = y + lengthdir_y(ww,direction+180) + lengthdir_y(hh,direction+90);
    draw_surface_ext(surf[surf_side],xx,yy,surf_scale,surf_scale,direction,c_white,1);
    }
event_inherited();