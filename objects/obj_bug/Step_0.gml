// Movement
image_speed = paused ? 0 : 8/timer_max;

if !paused then timer -= 1;
if timer < 1
	{
	if warp
		{
		x = ctrl_x;
		y = ctrl_y;
		warp = false;
		}
	else
		{
		x += lengthdir_x(16,direction);
		y += lengthdir_y(16,direction);
		}
	calculate_timer();
	}
	
// Map position wrap
if y > room_height then y -= room_height;
if y < 0 then y += room_height;
if x > room_width then x -= room_width;
if x < 0 then x += room_width;

if grabbed or paused then exit;

var xx = floor((x+8)/16);
var yy = floor((y+8)/16);
	
// Play note
if (hit_lastx != xx or hit_lasty != yy)
	{
	hit_lastx = xx;
	hit_lasty = yy;
	var c = ds_grid_get(global.pixel_grid,xx,yy);
	if c > 0
		{
		note = c;
		if !muted
			{
			if audio_is_playing(snd_last) then audio_stop_sound(snd_last);
			var vol = (volume/128); //power(volume/128,2);
			//trace(string("bug {0} playing sound at calculated volume {1}",bugzid,vol));
			snd_last = audio_play_sound(snd_struct.snd[note-1],0,false,vol);
			}
		if ltxy_mode == 0 then alarm[0] = 2;
		anim_playing = true;
		anim_index = 0;
		}
	var c2 = ds_grid_get(global.ctrl_grid,xx,yy);
	if c2 > 0 then controlnote_hit(c2);
	}

if anim_playing == true
	{
	// Keyframe data (frame,x,y)(LTXY)
	var section = note;
	if array_length(ltxy_data) <= 1 then section = 0;
	var ind = floor(anim_index);
	ltxy_frame = ltxy_data[section][ind][0] - 1;
	ltxy_x = ltxy_data[section][ind][1];
	ltxy_y = ltxy_data[section][ind][2];
	
	// Note hit blend data (LTCC)
	if !muted
		{
		var r = ltcc_data[note][ind][0];
		var g = ltcc_data[note][ind][1];
		var b = ltcc_data[note][ind][2];
		ltcc_blend = make_color_rgb(r,g,b);
		}
	else ltcc_blend = c_black;
	
	// Playback
	var play = 30/game_get_speed(gamespeed_fps);
	if anim_index < array_length(ltxy_data[section])-1 then anim_index += play else
		{
		anim_playing = false;
		anim_index = 0;
		}
	}