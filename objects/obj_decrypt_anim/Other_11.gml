///@desc Generate sprites for bug
var ssw = surface_get_width(surf[0]);
var ssh = surface_get_height(surf[0]);
var sw = ssw / 8;
var sh = ssh / 4;
var smooth = false;
var removeback = true;
var xo = 16;//sw / 4;
var yo = 16;//sh / 4;

for (var z=0; z<3; z++)
    {
	// per issue https://github.com/YoYoGames/GameMaker-Bugs/issues/6165,
	// save subimages as full sprites separately for now.
	for (var i=0; i<8; i++)
		{
	    spr_up[z][i] = sprite_create_from_surface(surf[z],sw*i,0,sw,sh,removeback,smooth,xo,yo);
	    spr_right[z][i] = sprite_create_from_surface(surf[z],sw*i,sh,sw,sh,removeback,smooth,xo,yo);
	    spr_down[z][i] = sprite_create_from_surface(surf[z],sw*i,sh*2,sw,sh,removeback,smooth,xo,yo);
	    spr_left[z][i] = sprite_create_from_surface(surf[z],sw*i,sh*3,sw,sh,removeback,smooth,xo,yo);
		}
    //sprite_save_strip(spr_up[z],"pngs/spr_up["+string(z)+"].png");
    //sprite_save_strip(spr_down[z],"pngs/spr_down["+string(z)+"].png");
    //sprite_save_strip(spr_left[z],"pngs/spr_left["+string(z)+"].png");
    //sprite_save_strip(spr_right[z],"pngs/spr_right["+string(z)+"].png");
    }
    
surface_free(surf2);
    
// ... and attempt configuring bug
/*var bug = instance_create_depth(x,y,0,obj_bug);
bug.spr_up = spr_up;
bug.spr_left = spr_left;
bug.spr_down = spr_down;
bug.spr_right = spr_right;
bug.speed = 2;
bug.direction = 270;*/