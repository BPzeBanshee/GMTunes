//var xview = camera_get_view_x(view_camera[0]);
//var yview = camera_get_view_y(view_camera[0]);
if global.debug
    {
    // Init colour, positions, font etc
    scr_draw_vars(fnt_debug,fa_right,make_color_rgb(90,218,90));
	draw_set_valign(fa_middle);
	draw_set_alpha(1);
        
    // Display debug data
    var str = "";
    str += string(rfps_txt)+" RFPS\n";
    str += "S:"+string(global.step)+", I:"+string(instance_count)+"\n";
    str += string(fps)+" FPS";
    draw_text(640,460,str);
    }