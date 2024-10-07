///@desc Summons the transition object for going between rooms
function scr_trans(nextroom){
if instance_exists(obj_trans) return -1;
var o = instance_create_depth(0,0,-9999,obj_trans);
o.nextroom = nextroom;
return o;
}