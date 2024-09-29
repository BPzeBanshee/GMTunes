///@desc Create object if respective button is pressed
/*for (var i=0;i<array_length(txta);i++)
    {
    if button[i].pressed then method_call(evt[i],[]);
    }*/
	
// size: 227x244
if point_in_rectangle(mouse_x,mouse_y,206,21,206+227,21+244)
	{
	if !over
		{
		if !audio_is_playing(snd_play) audio_play_sound(snd_play,100,false);
		over = true;
		}
	if mouse_check_button_pressed(mb_left) start_game();
	cycle_surfpal(surf,h);
	}
	
// size: 157x138
else if point_in_rectangle(mouse_x,mouse_y,46,270,46+157,270+138)
	{
	if !over
		{
		if !audio_is_playing(snd_gal) audio_play_sound(snd_gal,100,false);
		over = true;
		}
	if mouse_check_button_pressed(mb_left) start_game();
	cycle_surfpal(surf2,h2);
	}
	
// size: 176x137
else if point_in_rectangle(mouse_x,mouse_y,427,270,427+176,270+138)
	{
	if !over
		{
		if !audio_is_playing(snd_tut) audio_play_sound(snd_tut,100,false);
		over = true;
		}
	if mouse_check_button_pressed(mb_left) start_debug();
	cycle_surfpal(surf3,h3);
	}
	
// size: 77x85
else if point_in_rectangle(mouse_x,mouse_y,280,371,280+77,371+85)
	{
	if !over
		{
		if !audio_is_playing(snd_exit) audio_play_sound(snd_exit,100,false);
		over = true;
		}
	if mouse_check_button_pressed(mb_left) exit_game();
	cycle_surfpal(surf4,h4);
	}
	
else
	{
	over = false;
	}
	
/*if button[0].pressed then start_game();
if button[1].pressed then start_debug();
if button[2].pressed then dat_extract();
if button[3].pressed then exit_game();*/