// Inherit the parent event
event_inherited();
zooming_in = true;
if global.zoom == 2 zooming_in = false;
if global.use_external_assets cursor_sprite = global.spr_ui.magnify;