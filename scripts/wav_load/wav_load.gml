/// @desc wav_load Loads a .WAV file
/// @param {string} file .WAV/raw WAV file to load
/// @param {bool} [has_metadata]=true Uses file metadata to create sound
/// @param {real} [rate]=22050 Assuming has_metadata=false, manually define sample rate
/// @param {real} [channels]=1 Assuming has_metadata=false, manually define number of channels
/// @returns {Asset.GMSound}
//{struct} Id.Buffer, Asset.GMSound
function wav_load(file,has_metadata=true,rate=22050,channels=1){
var size = get_filesize(file);
var bu = buffer_create(size,buffer_fixed,1);
buffer_load_ext(bu,file,0);
buffer_seek(bu,buffer_seek_start,0);
var s = wav_load_from_buffer(bu,has_metadata,rate,channels);
return s;
}

function wav_load_from_buffer(bu,has_metadata=true,rate=22050,channels=1){
var size = buffer_get_size(bu);
var t = buffer_tell(bu);
var c = audio_mono;
var s;
if has_metadata
	{
	var o = 44;
	var m = {wavetag: "", wavetag_length: 0, format: 1, _channels: 1, samplerate: 0, samplerate2: 0, bps2: 0, bps: 0, datatag: "", datasize: 0};
	m.wavetag = buffer_word(bu,t+8) + buffer_word(bu,t+12); // always gonna be 'WAVEfmt '
	m.wavetag_length = buffer_peek(bu,t+16,buffer_u32);	 // therefore this will be same
	m.format = buffer_peek(bu,t+20,buffer_u16);			// 1: PCM
	m._channels = buffer_peek(bu,t+22,buffer_u16);		// number of channels
	m.samplerate = buffer_peek(bu,t+24,buffer_u32);		// samples per second (hz)
	m.samplerate2 = buffer_peek(bu,t+28,buffer_u32);	// (Sample Rate * BitsPerSample * Channels) / 8
	m.bps2 = buffer_peek(bu,t+32,buffer_u16);			// (BitsPerSample * Channels) / 8 - 1: 8 bit mono, 2:8 bit stereo/16 bit mono, 4: 16 bit stereo
	m.bps = buffer_peek(bu,t+34,buffer_u16);			// bits per sample
	m.datatag = buffer_word(bu,t+36);					// "data"
	m.datasize = buffer_peek(bu,t+40,buffer_u32);		// size of data section
	//trace(m);
	if m._channels == 2 then c = audio_stereo;
	if m._channels > 2 then c = audio_3D;
	s = audio_create_buffer_sound(bu,buffer_u8,m.samplerate,o,m.datasize,c);
	}
else 
	{
	if channels == 2 then c = audio_stereo;
	if channels > 2 then c = audio_3D;
	s = audio_create_buffer_sound(bu,buffer_u8,rate,0,size,c);
	}
return s;
}