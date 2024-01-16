///@desc Zoom Out
if (y >= room_height or device_mouse_y_to_gui(0) > 416) then exit;
zoom_out();
if global.zoom == 0 then zooming_in = true;