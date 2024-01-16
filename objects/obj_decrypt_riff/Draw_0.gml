draw_set_alpha(1);

draw_self();

draw_set_font(global.fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(x,y-16,dir);
draw_text(x,y+8,"ID: "+string(index));
if audio_is_playing(snd[index]) then draw_text(x+64,y+8,"|>");

if index > 0 then draw_text(x-40,y+8,"<");
if index < array_length(snd)-1 then draw_text(x+40,y+8,">");

draw_text(x,y+24,"Z: PLAY, SPACE: EXPORT");

event_inherited();