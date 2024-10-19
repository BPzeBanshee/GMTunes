// Button events
if instance_exists(obj_trans) exit;
if !use_classic_gui
	{
	for (var i=0;i<array_length(txta);i++)
	    {
	    if button[i].pressed then method_call(evt[i],[]);
	    }
	}

// Keyboard events
event_user(1);