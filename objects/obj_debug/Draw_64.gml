//var xview = camera_get_view_x(view_camera[0]);
//var yview = camera_get_view_y(view_camera[0]);
if global.debug
    {
    // Init colour, positions, font etc
    scr_draw_vars(fnt_system,fa_right,make_color_rgb(90,218,90));
	draw_set_valign(fa_top);
	draw_set_alpha(1);
        
    // Display debug data
    var str = "";
    str += string(rfps_txt)+" RFPS\n";
    str += "I:"+string(instance_count)+", "+string(fps)+" FPS";
	var o = instance_exists(obj_ctrl_playfield) ? 36 : 0;
    draw_text(640,480-string_height(str)-o,str);
    }