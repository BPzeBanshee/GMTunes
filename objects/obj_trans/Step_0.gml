switch mode
	{
	// fade in
	case 0:
		{
		if alpha < 1 alpha += 0.05 else
			{
			mode = max_tasks == 0 ? 2 : 1;
			if room_exists(nextroom) room_goto(nextroom);
			}
		break;
		}
		
	// loading bar if needed
	case 1:
		{
		//tasks++;
		if tasks >= max_tasks mode = 2;
		break;
		}
		
	// fade out
	case 2:
		{
		if alpha > 0 alpha -= 0.05 else instance_destroy();
		break;
		}
	}