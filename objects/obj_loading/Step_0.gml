switch mode
	{
	// fade in
	case 0:
		{
		if alpha < 1 alpha += inc;// else mode = 1;
		break;
		}
		
	// loading bar if needed
	case 1:
		{
		//tasks++;
		//if tasks >= max_tasks mode = 2;
		break;
		}
		
	// fade out
	case 2:
		{
		if alpha > 0 alpha -= inc else instance_destroy();
		break;
		}
	}