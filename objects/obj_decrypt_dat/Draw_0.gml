draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var str = "";
for (var i=0;i<array_length(filenames);i++)
	{
	str = filenames[i]+", size: "+string(sizes[i])+", offset: "+string(offsets[i]);
	draw_text(x,y+(12*i),str);
	}
image_xscale = string_width(str)/2;
image_yscale = (string_height(str) * array_length(filenames))/2;

event_inherited();