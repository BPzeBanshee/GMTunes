var o = collision_point(mouse_x,mouse_y,obj_window,false,true);
if o != noone
    {
    if id < o.id then selected = true;
    trace(string(o.id));
    }
else selected = true;
//if !place_free(mouse_x,mouse_y) selected = true;