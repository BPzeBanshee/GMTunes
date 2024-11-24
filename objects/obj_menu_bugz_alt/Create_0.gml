parent = noone;
x = 640 * 0.25;
y = 480 * 0.25;
width = 320;
height = 240;
mouse_old = instance_find(obj_mouse_parent,1);
instance_deactivate_object(mouse_old);
mymouse = instance_create_depth(0,0,depth-1,obj_mouse_parent);
