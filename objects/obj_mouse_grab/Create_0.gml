// Inherit the parent event
event_inherited();
image_blend = c_white;
pressed = false;
released = false;
grabbed_bug = noone;
bug_to_grab = noone;
if global.use_external_assets sprite_index = -1;
	
#region macros
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
		}
	if keyboard_check_pressed(ord("X")) 
		{
		grabbed_bug.direction -= 90; 
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
		
	// Attempt win3.1 port's "shake" function for setting Bug direction via mouse
	if x > xprevious+160 grabbed_bug.direction = 0;
	if x < xprevious-160 grabbed_bug.direction = 180;
	if y < yprevious-120 grabbed_bug.direction = 90;
	if y > yprevious+120 grabbed_bug.direction = 270;
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
#endregion