// Movement
if !paused
	{
	spr_subimg += grabbed ? 16/timer_max : 8/timer_max;
	if round(spr_subimg) > 7 spr_subimg = 0;
	}

if grabbed || paused exit;
timer -= 1;
if timer < 1
	{
	// Adding this fixes REVERB.GAL but breaks RAINSONG.GAL
	// and likely every other file that uses direction tiles,
	// WTF?
	if warp_alt && global.reverb_hack
		{
		warp_alt = false;
		return;
		}
	if warp
		{
		x = ctrl_x;
		y = ctrl_y;
		ctrl_x = -1;
		ctrl_y = -1;
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
if x+8>room_width x -= room_width; if x+8<-8 x += room_width;
if y+8>room_height y -= room_height; if y+8<-8 y += room_height;
var xx = clamp(floor((x+8)/16),0,159);
var yy = clamp(floor((y+8)/16),0,103);
	
// Play note
if (hit_lastx != xx or hit_lasty != yy)
	{
	hit_lastx = xx;
	hit_lasty = yy;
	var c = global.note_grid[xx][yy];
	if c > 0
		{
		note = c;
		if !muted
			{
			if audio_is_playing(snd_last) audio_stop_sound(snd_last);
			var vol = (volume/128); //power(volume/128,2);
			//trace(string("bug {0} playing sound at calculated volume {1}",bugzid,vol));
			snd_last = audio_play_sound(snd_struct.snd[note-1],0,false,vol);
			}
		if ltxy_mode == 0 alarm[0] = 2;
		anim_playing = true;
		anim_index = 0;
		}
	var c2 = global.ctrl_grid[xx][yy];
	if c2 > 0 controlnote_hit(c2);
	
	// play function tile clicks
	if global.use_external_assets 
	&& global.function_tile_clicks 
	&& (c == 0 && c2 > 0)
		{
		var s;
		switch bugztype
			{
			case 0: s = global.snd_ui.yclick; break;
			case 1: s = global.snd_ui.gclick; break;
			case 2: s = global.snd_ui.bclick; break;
			case 3: s = global.snd_ui.rclick; break;
			}
		audio_play_sound(s,0,false);
		}
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
	if anim_index < array_length(ltxy_data[section])-1
	anim_index += play else
		{
		anim_playing = false;
		anim_index = 0;
		}
	}