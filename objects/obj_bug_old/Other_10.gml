///@desc Method Functions
// Feather disable GM2016
play_grabbed = function(){
audio_play_sound(array_last(snd_struct.snd),0,false);
}

calculate_speed = function(){
var block = 16;
var rmspeed = game_get_speed(gamespeed_fps);
var spd;
switch gear
	{
	case 0: spd = (block/2) / rmspeed; break;
	case 1: spd = (block) / rmspeed; break;
	case 2: spd = (block*2) / rmspeed; break;
	case 3: spd = (block*3) / rmspeed; break;
	case 4: spd = (block*4) / rmspeed; break;
	case 5: spd = (block*6) / rmspeed; break;
	case 6: spd = (block*8) / rmspeed; break;
	case 7: spd = (block*12) / rmspeed; break;
	case 8: spd = (block*14) / rmspeed; break;
	}
trace(string("spd in bpm: {0}",time_seconds_to_bpm(spd*rmspeed)));
return spd;
}

controlnote_hit = function(hit_id){
// Feather disable GM2016
var mm = hit_id;//.mode;
if mm == 10 then mm = choose(4,5,6,7,11,12,13,14);
//var xx = floor((x+8)/16);
//var yy = floor((y+8)/16);
var xx = floor((x+8+lengthdir_x(7,direction+180))/16);
var yy = floor((y+8+lengthdir_y(7,direction+180))/16);
switch mm
	{
	case 1: direction += 90; break;
	case 2: direction -= 90; break;
	case 3: direction += 180; break;
	case 4: direction = 0;		ctrl_x = (xx*16) + 128;		ctrl_y = (yy*16);			warp = true; break;
	case 5: direction = 270;	ctrl_x = (xx*16);			ctrl_y = (yy*16) + 128;		warp = true; break;
	case 6: direction = 180;	ctrl_x = (xx*16) - 128;		ctrl_y = (yy*16);			warp = true; break;
	case 7: direction = 90;		ctrl_x = (xx*16);			ctrl_y = (yy*16) - 128;		warp = true; break;
	//case 4: direction = 0;		ctrl_x = (x) + 128;		ctrl_y = (y);			break;
	//case 5: direction = 270;	ctrl_x = (x);			ctrl_y = (y) + 128;		break;
	//case 6: direction = 180;	ctrl_x = (x) - 128;		ctrl_y = (y);			break;
	//case 7: direction = 90;		ctrl_x = (x);			ctrl_y = (y) - 128;		break;
	case 8: // tele from
		{
		for (var i=0;i<array_length(global.warp_list);i++)
			{
			if global.warp_list[i][0] == xx
			&& global.warp_list[i][1] == yy
				{
				ctrl_x = (global.warp_list[i][2] * 16);
				ctrl_y = (global.warp_list[i][3] * 16);
				warp = true;
				}
			}
		break;
		}
	case 9: break;
	case 10: break; // random direction
	case 11: ctrl_x = (xx*16) - 128; ctrl_y = (yy*16) - 128; warp = true; break;
	case 12: ctrl_x = (xx*16) + 128; ctrl_y = (yy*16) - 128; warp = true; break;
	case 13: ctrl_x = (xx*16) + 128; ctrl_y = (yy*16) + 128; warp = true; break;
	case 14: ctrl_x = (xx*16) - 128; ctrl_y = (yy*16) + 128; warp = true; break;
	}
	
if !place_snapped(16,16) then move_snap(16,16);
direction_p = direction;
speed_p = speed;
update_sprite();
if ctrl_x > 0 or ctrl_y > 0
	{
	//x = ctrl_x;
	//y = ctrl_y;
	if ctrl_x > 160*16 then ctrl_x -= 160*16;
	if ctrl_y > 104*16 then ctrl_y -= 104*16;
	x -= (x - ctrl_x);
	y -= (y - ctrl_y);
	if warp
		{
		x += lengthdir_x(16,direction-180);
		y += lengthdir_y(16,direction-180);
		hit_lastx = floor((x+8+lengthdir_x(7,direction+180))/16);
		hit_lasty = floor((y+8+lengthdir_y(7,direction+180))/16);
		//hit_lastx = floor(x+8/16);
		//hit_lasty = floor(y+8/16);
		warp = false;
		}
	ctrl_x = -1;
	ctrl_y = -1;
	ctrl_spd = -1;
	speed = speed_p;
	direction = direction_p;
	update_sprite();
	//ctrl_spd = speed * (distance_to_point(ctrl_x,ctrl_y) / ((1000/60)));
	//trace("bug "+string(bugzid)+" ctrl_spd set to "+string(ctrl_spd));
	//direction = point_direction(x,y,ctrl_x,ctrl_y);
	}
}

update_sprite = function(){
// Sprite handling
// TODO: sprite animation speed, seems to be loosely tied to movement
var s;
switch direction
	{
	case 90: s = spr_up[global.zoom]; break;
	case 180: s = spr_left[global.zoom]; break;
	case 270: s = spr_down[global.zoom]; break;
	case 0: s = spr_right[global.zoom]; break;
	default: s = sprite_index; break;
	}
if sprite_index != s 
	{
	sprite_index = s;
	if !paused then image_speed = 0.5;
	}
}

draw_anim = function(xx,yy){
if anim_playing
	{
	// pull from LTCC data
	var b = ltcc_blend;
	
	switch ltxy_mode
		{
		// fallback: standard drawing of quartiles, their offsets should be handled in sprite creation
		case 0:
			{
			draw_sprite_ext(spr_notehit_tl,anim_index,xx,yy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_tr,anim_index,xx,yy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_br,anim_index,xx,yy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_bl,anim_index,xx,yy,1,1,0,b,1);
			break;
			}
			
		// only used by speech bugz, single speech bubble frame + y offset
		case 1:
			{
			draw_sprite_ext(spr_notehit_tl,ltxy_frame,xx+40+ltxy_x,yy+40-ltxy_y,1,1,0,b,1);
			break;
			}
			
		// draw quartiles with offset/flip based on LTXY data
		case 4:
			{
			var o;
			o[0] = {ox: xx + ltxy_x, oy: yy + ltxy_y};
			o[1] = {ox: xx - ltxy_x, oy: yy + ltxy_y};
			o[2] = {ox: xx - ltxy_x, oy: yy - ltxy_y};
			o[3] = {ox: xx + ltxy_x, oy: yy - ltxy_y};
			/*for (var i=0;i<4;i++)
				{
				draw_line_color(xx,yy,o[i].xx,o[i].yy,c_white,c_white);
				draw_text(o[i].xx,o[i].yy,string(i));
				}*/
			
			draw_sprite_ext(spr_notehit_tl,ltxy_frame,o[0].ox,o[0].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_tr,ltxy_frame,o[1].ox,o[1].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_br,ltxy_frame,o[2].ox,o[2].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_bl,ltxy_frame,o[3].ox,o[3].oy,1,1,0,b,1);
			break;
			}
			
		// same as mode 4 but with quartile 1 and 3 values reversed to achieve spin effect
		case 5:
			{
			var o;
			o[0] = {ox: xx + ltxy_x, oy: yy + ltxy_y};
			o[1] = {ox: xx - ltxy_y, oy: yy + ltxy_x};
			o[2] = {ox: xx - ltxy_x, oy: yy - ltxy_y};
			o[3] = {ox: xx + ltxy_y, oy: yy - ltxy_x};
			draw_sprite_ext(spr_notehit_tl,ltxy_frame,o[0].ox,o[0].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_tr,ltxy_frame,o[1].ox,o[1].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_br,ltxy_frame,o[2].ox,o[2].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_bl,ltxy_frame,o[3].ox,o[3].oy,1,1,0,b,1);
			break;
			}
		}
	}
}