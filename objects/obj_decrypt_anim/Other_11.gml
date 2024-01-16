///@desc Generate sprites for bug
var ssw = surface_get_width(surf[0]);
var ssh = surface_get_height(surf[0]);
var surf2 = surface_create(ssw,ssh);

var sw,sh,smooth,removeback;
for (var z = 0; z < 3; z++)
    {
    // Compensate for weird fucking bug in sprite_create_from_surface
    surface_set_target(surf2);
    draw_surface_ext(surf[z],ssw,ssh,-1,-1,0,c_white,1);
    surface_reset_target();
    
    sw = ssw / 8;
    sh = ssh / 4;
    smooth = false;
    removeback = true;
    //spr_up[z] = sprite_create_from_surface(surf2,0,0,256,192,0,0,128,96);
    spr_up[z] = sprite_create_from_surface(surf2,0,0,sw,sh,removeback,smooth,0,0);
    spr_left[z] = sprite_create_from_surface(surf2,0,sh,sw,sh,removeback,smooth,sw/2,sh/2);
    spr_down[z] = sprite_create_from_surface(surf2,0,sh*2,sw,sh,removeback,smooth,sw/2,sh/2);
    spr_right[z] = sprite_create_from_surface(surf2,0,sh*3,sw,sh,removeback,smooth,sw/2,sh/2);
    
    for (var i=1; i<8; i++)
       {
       sprite_add_from_surface(spr_up[z],surf2,sw*i,0,sw,sh,removeback,smooth);
       sprite_add_from_surface(spr_left[z],surf2,sw*i,sh,sw,sh,removeback,smooth);
       sprite_add_from_surface(spr_down[z],surf2,sw*i,sh*2,sw,sh,removeback,smooth);
       sprite_add_from_surface(spr_right[z],surf2,sw*i,sh*3,sw,sh,removeback,smooth);
       }
    //sprite_save_strip(spr_up[z],"pngs/spr_up["+string(z)+"].png");
    //sprite_save_strip(spr_down[z],"pngs/spr_down["+string(z)+"].png");
    //sprite_save_strip(spr_left[z],"pngs/spr_left["+string(z)+"].png");
    //sprite_save_strip(spr_right[z],"pngs/spr_right["+string(z)+"].png");
    }
    
surface_free(surf2);
    
// ... and attempt configuring bug
var bug = instance_create_depth(x,y,0,obj_bug);
bug.spr_up = spr_up;
bug.spr_left = spr_left;
bug.spr_down = spr_down;
bug.spr_right = spr_right;
bug.speed = 2;
bug.direction = 270;