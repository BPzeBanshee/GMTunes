	
/*if ctrl_x > -1 or ctrl_y > -1
	{
	// TODO: maybe try a lerp(a,b,num/16) formula?
	//if round(x) == ctrl_x && round(y) == ctrl_y DOES NOT WORK
	//if round(ctrl_x) - x == 0 && round(ctrl_y) - y == 0
	//if round(x) == round(ctrl_x) && round(y) == round(ctrl_y)
	lerpamt += speed_p;
	//x = lerp(old_x,ctrl_x,lerpamt/16);
	//y = lerp(old_y,ctrl_y,lerpamt/16);
	
	//mp_linear_step(round(ctrl_x),round(ctrl_y),ctrl_spd,false);
	//if x == round(ctrl_x) && y == round(ctrl_y)
	if lerpamt >= 16//(lerpamt/16) == 1
		{
		//if !place_snapped(16,16) then move_snap(16,16);
		x -= (x - ctrl_x);
		y -= (y - ctrl_y);
		//x = ctrl_x + frac(xprevious);//frac(old_x);
		//y = ctrl_y + frac(yprevious);//frac(old_y);
		speed = speed_p;
		old_x = -1;
		old_y = -1;
		lerpamt = 0;
		ctrl_x = -1;
		ctrl_y = -1;
		ctrl_spd = -1;
		direction = direction_p;
		update_sprite();
		}
	}*/
	
// Movement
if paused
	{
	if speed > 0
	    {
	    speed_p = speed;
	    speed = 0;
	    image_speed = 0;
	    }
	}
else
    {
    if speed == 0 && (ctrl_x == -1 && ctrl_y == -1)
        {
        speed = speed_p;
        speed_p = 0;
        image_speed = 0.5;
        }
    }
	
// Map position wrap
if y > room_height then y -= room_height;
if y < 0 then y += room_height;
if x > room_width then x -= room_width;
if x < 0 then x += room_width;


	
if grabbed or warp or paused then exit;

//var xx = floor((x+8)/16);
//var yy = floor((y+8)/16);
var xx = floor((x+8+lengthdir_x(7,direction+180))/16);
var yy = floor((y+8+lengthdir_y(7,direction+180))/16);
	
// Play note
if (hit_lastx != xx or hit_lasty != yy)
	{
	hit_lastx = xx;
	hit_lasty = yy;
	var c = ds_grid_get(global.pixel_grid,xx,yy);
	if c > 0
		{
		note = c;
		if audio_is_playing(snd_last) then audio_stop_sound(snd_last);
		snd_last = audio_play_sound(snd_struct.snd[note-1],0,false,volume/128);
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
	var r = ltcc_data[note][ind][0];
	var g = ltcc_data[note][ind][1];
	var b = ltcc_data[note][ind][2];
	ltcc_blend = make_color_rgb(r,g,b);
	
	// Playback
	var play = 30/game_get_speed(gamespeed_fps);
	if anim_index < array_length(ltxy_data[section])-1 then anim_index += play else
		{
		anim_playing = false;
		anim_index = 0;
		}
	}