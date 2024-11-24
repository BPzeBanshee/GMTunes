/// @desc wav_load Loads a .WAV file
/// @param {string} file .WAV/raw WAV file to load
/// @param {bool} [has_metadata]=true Uses file metadata to create sound
/// @param {real} [rate]=22050 Assuming has_metadata=false, manually define sample rate
/// @param {real} [channels]=1 Assuming has_metadata=false, manually define number of channels
/// @returns {Asset.GMSound}
//{struct} Id.Buffer, Asset.GMSound
function wav_load(file,has_metadata=true,rate=22050,channels=1){
//trace("loading {0}...",file);
var size = get_filesize(file);
var bu = buffer_create(size,buffer_fixed,1);
buffer_load_ext(bu,file,0);
buffer_seek(bu,buffer_seek_start,0);
var s = wav_load_from_buffer(bu,has_metadata,rate,channels);
return s;
}

function wav_load_from_buffer(bu,has_metadata=true,rate=22050,channels=1){
var c = audio_mono;
var s;
if has_metadata
	{
	// Metadata integrity checks (RIFF, filesize, WAVEfmt ,length)
	var test = buffer_read_word(bu); if test != "RIFF" return -1;
	buffer_read(bu,buffer_u32); //trace("test: {0}, size-8: {1}",test,size-8); //if test != size-8 return -2;
	test = buffer_read_word(bu); // YYC compile jank, executes these backwards if put in one line
	test += buffer_read_word(bu); 
	if test != "WAVEfmt " 
		{
		msg("wav_load_from_buffer: test returned "+string(test));
		return -3;
		}
	test = buffer_read(bu,buffer_u32); if test != 16 return -4;
	
	// Get the rest of the metadata
	var m = {format: 1, _channels: 1, samplerate: 0, samplerate2: 0, bps2: 0, bps: 0, datatag: "", datasize: 0};
	m.format = buffer_read(bu,buffer_u16);			// 1: PCM
	m._channels = buffer_read(bu,buffer_u16);		// number of channels
	m.samplerate = buffer_read(bu,buffer_u32);		// samples per second (hz)
	m.samplerate2 = buffer_read(bu,buffer_u32);		// (Sample Rate * BitsPerSample * Channels) / 8
	m.bps2 = buffer_read(bu,buffer_u16);			// (BitsPerSample * Channels) / 8 - 1: 8 bit mono, 2:8 bit stereo/16 bit mono, 4: 16 bit stereo
	m.bps = buffer_read(bu,buffer_u16);				// bits per sample
	test = buffer_read_word(bu);					// either "data" or "fact"
	if test == "fact"
		{
		/*var r = buffer_read(bu,buffer_u32) / 4;
		var a = [];
		repeat r array_push(a,buffer_read(bu,buffer_u32));
		trace("fact chunk: {0}",a);*/
		repeat 3 buffer_read(bu,buffer_u32); // "data"
		}
	m.datasize = buffer_read(bu,buffer_u32);		// size of data section
	
	//trace(m);
	if m._channels == 2 then c = audio_stereo;
	if m._channels > 2 then c = audio_3d;	
	s = audio_create_buffer_sound(bu,buffer_u8,m.samplerate,buffer_tell(bu),m.datasize,c);
	}
else 
	{
	if channels == 2 then c = audio_stereo;
	if channels > 2 then c = audio_3d;
	s = audio_create_buffer_sound(bu,buffer_u8,rate,0,size,c);
	}
return s;
}