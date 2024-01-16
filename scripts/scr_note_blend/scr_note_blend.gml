///@param {real} note
/*
TODO: this is "HLE" simulation of getting the note colors,
the actual data's in the bug's LTCC somewhere.
*/
function scr_note_blend(note){
	note = clamp(note,1,25);
	var color = c_white;
	switch note
		{
		case 1: color = make_color_rgb(255,255,0); break;
		case 2: color = make_color_rgb(134,134,0); break;
		case 3: color = make_color_rgb(150,255,0); break;
		case 4: color = make_color_rgb(0,121,0); break;
		case 5: color = make_color_rgb(0,231,0); break;
		case 6: color = make_color_rgb(32,166,130); break;
		case 7: color = make_color_rgb(0,93,81); break;
		case 8: color = make_color_rgb(0,195,239); break;
		case 9: color = make_color_rgb(0,0,150); break;
		case 10: color = make_color_rgb(0,77,223); break;
		case 11: color = make_color_rgb(69,0,113); break;
		case 12: color = make_color_rgb(101,85,247); break;
		case 13: color = make_color_rgb(178,36,247); break;
		case 14: color = make_color_rgb(121,0,109); break;
		case 15: color = make_color_rgb(255,52,223); break;
		case 16: color = make_color_rgb(113,0,0); break;
		case 17: color = c_red; break;
		case 18: color = make_color_rgb(243,134,0); break;
		case 19: color = make_color_rgb(130,52,0); break;
		case 20: color = make_color_rgb(255,186,158); break;
		case 21: color = make_color_rgb(138,113,77); break;
		case 22: color = make_color_rgb(138,138,138); break;
		case 23: color = make_color_rgb(81,81,81); break;
		case 24: color = make_color_rgb(186,186,186); break;
		default: break;
		}
	return color;
}