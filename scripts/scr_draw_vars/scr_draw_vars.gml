/// @description scr_draw_vars(font,align,color)
/// @param font
/// @param align
/// @param color
function scr_draw_vars(font,align,color) {
	/*
	scr_draw_vars(), by BPzeBanshee

	What it does:
	Does a few extra lines of code here, so you don't have to.
	Kind of a Macro command to do multiple draw-related settings at once.

	Call at the beginning of every Draw event
	*/
	draw_set_font(font);
	draw_set_halign(align);
	draw_set_color(color);
}