///@desc Create object if respective button is pressed
for (var i=0;i<array_length(txta)-1;i++)
    {
    if button[i].pressed then instance_create_depth(0,0,0,obj[i]);
    }
	
if button[array_length(txta)-1].pressed then room_goto(rm_main);