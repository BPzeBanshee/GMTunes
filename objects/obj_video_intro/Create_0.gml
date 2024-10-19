// Basic variable init
mode = 0;
alpha = 0;
frame = 0;
timer = 0;
surf = -1;

if global.use_external_assets
	{
	// Company logos
	spr_logo1 = -1;
	spr_logo2 = -1;
	var f1 = TUNERES+"MaxKids.bmp";
	var f2 = TUNERES+"IwaiLogo.bmp";
	if file_exists(f1) spr_logo1 = bmp_load_sprite(f1,,,,,,,0,0);
	if file_exists(f2) spr_logo2 = bmp_load_sprite(f2,,,,,,,0,0);

	gmlibsmacker_init();

	// Version string
	trace("GMLibSmacker Version: "+gmlibsmacker_version());

	// Open SMK file
	var o = gmlibsmacker_open_smk(global.main_dir+"SIMTUNES.SMK");
	if o < 0
		{
		trace("problem loading {0}, skipping to main menu",global.main_dir+"SIMTUNES.SMK");
		room_goto(rm_main);
		}
	
	// Track count
	var c = gmlibsmacker_get_audio_track_count();
	trace("number of channels: {0}",c);

	var ac = gmlibsmacker_get_audio_channels(0);
	var af = gmlibsmacker_get_audio_frequency(0);
	var ab = gmlibsmacker_get_audio_bitdepth(0);
	trace("track 0 info: {0} channels, {1} hz, bitdepth: {2}",ac,af,ab);

	// Audio buffer
	var a = gmlibsmacker_get_audio_size(0);
	trace("gmlibsmacker_get_audio_size(0) returned {0}",a);

	// memory needs to be pre-allocated first in GM-land
	// before the DLL can manipulate it
	snd_buffer = buffer_create(a,buffer_fast,1);
	buffer_fill(snd_buffer,0,buffer_u8,0xFF,buffer_get_size(snd_buffer));

	gmlibsmacker_load_audio(buffer_get_address(snd_buffer),a,0);
	var cc = ac > 1 ? audio_stereo : audio_mono;
	s = audio_create_buffer_sound(snd_buffer,buffer_u8,af,0,a,cc);

	// Video buffer
	ww = gmlibsmacker_get_video_width();
	hh = gmlibsmacker_get_video_height();

	// Y mode 0: plain, 1: interlaced (untested), 2: "double" (black padding line on even y values)
	var yy = gmlibsmacker_get_video_y_mode();
	trace("y mode: {0}",yy);
	if yy > 0 then hh = hh*2;

	ff = gmlibsmacker_get_video_frame_rate();
	fc = gmlibsmacker_get_video_frame_count();
	trace("{0}x{1}, {2} FPS, {3} frames",ww,hh,ff,fc);

	// video buffer needs to be width * height * 4 in size for RGBA frames
	// and needs to be prefilled GM-side so that the memory is allocated
	bmp_buffer = buffer_create(ww*hh*4,buffer_fast,1);
	buffer_fill(bmp_buffer,0,buffer_u8,0xFF,buffer_get_size(bmp_buffer));

	update = function(){
		gmlibsmacker_load_bitmap(buffer_get_address(bmp_buffer),frame);

		// update surface
		if surface_exists(surf) buffer_set_surface(bmp_buffer,surf,0)
		else 
			{
			surf = surface_create(ww,hh);
			surface_set_target(surf);
			draw_clear_alpha(c_black,1);
			surface_reset_target();
			buffer_set_surface(bmp_buffer,surf,0);
			}
		}
	update();
	}
else
	{
	trace("problem loading {0}, skipping to main menu",global.main_dir+"SIMTUNES.SMK");
	room_goto(rm_main);
	}