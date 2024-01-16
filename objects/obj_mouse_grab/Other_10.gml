// Inherit the parent event
// Feather disable GM2016
event_inherited();

grab_bug = function(){
if grabbed_bug == noone
	{
	var bug;
	if instance_exists(bug_to_grab)
	then bug = bug_to_grab
	else bug = collision_rectangle(x-8,y-8,x+8,y+8,obj_bug,false,false);
	if instance_exists(bug)
		{
		grabbed_bug = bug;
		grabbed_bug.grabbed = true;
		grabbed_bug.play_grabbed();
		}
	}
else
	{
	grabbed_bug.x = x-8;
	grabbed_bug.y = y-8;
	if keyboard_check_pressed(ord("Z")) 
		{
		grabbed_bug.direction += 90; 
		grabbed_bug.update_sprite();
		}
	if keyboard_check_pressed(ord("X")) 
		{
		grabbed_bug.direction -= 90; 
		grabbed_bug.update_sprite();
		}
	if keyboard_check_pressed(ord("C"))
		{
		if grabbed_bug.gear < 8 then grabbed_bug.gear += 1;
		//grabbed_bug.speed = grabbed_bug.calculate_speed();
		}
	if keyboard_check_pressed(ord("V"))
		{
		if grabbed_bug.gear > 0 then grabbed_bug.gear -= 1;
		//grabbed_bug.speed = grabbed_bug.calculate_speed();
		}
	}
return 0;
}

drop_bug = function(){
if instance_exists(grabbed_bug)
	{
	grabbed_bug.grabbed = false;
	with grabbed_bug move_snap(16,16);
	grabbed_bug = noone;
	}
return 0;
}