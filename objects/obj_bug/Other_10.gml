///@desc Method Functions
// Feather disable GM2016
play_grabbed = function(){
audio_play_sound(array_last(snd_struct.snd),0,false);
}

calculate_timer = function(){
var second = game_get_speed(gamespeed_fps);
if timer < 0 timer = 0;
switch gear
	{
	// Bad Apple BPM test:
	// 138 BPM: 60 / (138/60[2.3])==26.086etc too slow, 
	// 276 BPM: 60 / (276/60[4.6])==13.043etc correct
	// formula?: FPS / (BPM*2/FPS)
	// alt: 30 (OG speed) / (BPM / FPS)
	case -1: timer += 13.043478260869565217391304347826; break;
	case 0: timer += second * 2; break;
	case 1: timer += second; break;
	case 2: timer += second / 2; break;
	case 3: timer += second / 3; break;
	case 4: timer += second / 4; break; // confirmed in Direction Test
	case 5: timer += second / 6; break; // confirmed in Direction Test
	case 6: timer += second / 8; break;
	case 7: timer += second / 12; break;
	case 8: timer += second / 16; break; // confirmed in Speed Test
	}
timer_max = timer;
}

controlnote_hit = function(hit_id){
// Feather disable GM2016
var mm = hit_id;
if mm == 10 then mm = choose(4,5,6,7,11,12,13,14);
var xx = floor((x+8)/16);
var yy = floor((y+8)/16);
switch mm
	{
	case 1: direction += 90; break;
	case 2: direction -= 90; break;
	case 3: direction += 180; break;
	case 4: direction = 0;		ctrl_x = (xx + 8) * 16;		ctrl_y = (yy) * 16;			break;
	case 5: direction = 270;	ctrl_x = (xx) * 16;			ctrl_y = (yy + 8) * 16;		break;
	case 6: direction = 180;	ctrl_x = (xx - 8) * 16;		ctrl_y = (yy) * 16;			break;
	case 7: direction = 90;		ctrl_x = (xx) * 16;			ctrl_y = (yy - 8) * 16;		break;
	case 8: // tele from
		{
		for (var i=0;i<array_length(global.warp_list);i++)
			{
			if global.warp_list[i][0] == xx
			&& global.warp_list[i][1] == yy
				{
				ctrl_x = (global.warp_list[i][2] * 16);
				ctrl_y = (global.warp_list[i][3] * 16);
				}
			}
		break;
		}
	case 9: break;
	case 10: break; // random direction
	case 11: ctrl_x = (xx - 8) * 16; ctrl_y = (yy - 8) * 16; break;
	case 12: ctrl_x = (xx + 8) * 16; ctrl_y = (yy - 8) * 16; break;
	case 13: ctrl_x = (xx + 8) * 16; ctrl_y = (yy + 8) * 16; break;
	case 14: ctrl_x = (xx - 8) * 16; ctrl_y = (yy + 8) * 16; break;
	}
	
if !place_snapped(16,16) then move_snap(16,16);
if (ctrl_x > -1 || ctrl_y > -1) {warp = true; warp_alt = true;}
direction_p = direction;
}

draw_bug = function(xx,yy){
var spr = spr_up[global.zoom,round(spr_subimg)];
if sprite_exists(spr) 
draw_sprite_ext(spr,0,xx,yy,image_xscale,image_yscale,direction-90,image_blend,image_alpha);
}

draw_anim = function(xx,yy){
if anim_playing
	{
	draw_set_alpha(1);
	// pull from LTCC data
	var b = ltcc_blend;
	
	switch ltxy_mode
		{
		// fallback: standard drawing of quartiles, their offsets should be handled in sprite creation
		case 0:
			{
			draw_sprite_ext(spr_notehit_tl[anim_index],0,xx,yy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_tr[anim_index],0,xx,yy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_br[anim_index],0,xx,yy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_bl[anim_index],0,xx,yy,1,1,0,b,1);
			break;
			}
			
		// only used by speech bugz, single speech bubble frame + y offset
		case 1:
			{
			draw_sprite_ext(spr_notehit_tl[ltxy_frame],0,xx+40+ltxy_x,yy+40-ltxy_y,1,1,0,b,1);
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
			
			draw_sprite_ext(spr_notehit_tl[ltxy_frame],0,o[0].ox,o[0].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_tr[ltxy_frame],0,o[1].ox,o[1].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_br[ltxy_frame],0,o[2].ox,o[2].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_bl[ltxy_frame],0,o[3].ox,o[3].oy,1,1,0,b,1);
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
			draw_sprite_ext(spr_notehit_tl[ltxy_frame],0,o[0].ox,o[0].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_tr[ltxy_frame],0,o[1].ox,o[1].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_br[ltxy_frame],0,o[2].ox,o[2].oy,1,1,0,b,1);
			draw_sprite_ext(spr_notehit_bl[ltxy_frame],0,o[3].ox,o[3].oy,1,1,0,b,1);
			break;
			}
		}
	}
}