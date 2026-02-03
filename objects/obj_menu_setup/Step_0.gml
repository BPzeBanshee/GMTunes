if !ready or exiting exit;
var mx = mouse_x;
var my = mouse_y;
var mb = mouse_check_button_pressed(mb_left);

// Function Tile Clicks
if point_in_rectangle(mx,my,253,112,253+50,112+16) && mb
	{
	global.function_tile_clicks = true;
	}
if point_in_rectangle(mx,my,329,112,329+55,112+16) && mb
	{
	global.function_tile_clicks = false;
	}
	
// Display on palette
var palette_x = 438;
for (var i=0;i<3;i++)
	{
	if point_in_rectangle(mx,my,palette_x+(60*i),46,palette_x+(60*(i+1)),46+60) && mb
		{
		global.display_on_palette = i;
		}
	}
	
// OK
if point_in_rectangle(mx,my,223,446,223+111,446+32) && mb
	{
	flash(1);
	scr_config_save();
	exit_setup();
	}
	
// CANCEL
if point_in_rectangle(mx,my,341,446,341+111,446+32) && mb
	{
	flash(2);
	exit_setup();
	}
	
// RESET
if point_in_rectangle(mx,my,459,446,459+111,446+32) && mb
	{
	flash(3);
	scr_config_reset();
	}