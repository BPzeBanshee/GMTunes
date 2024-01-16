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
var t = buffer_tell(bu);
var c = audio_mono;
var s;
if has_metadata && buffer_word(bu,t)=="RIFF"
	{
	var o = 44;
	var m = {
		wavetag: buffer_word(bu,t+8) + buffer_word(bu,t+12), // always gonna be 'WAVEfmt '
		wavetag_length: buffer_peek(bu,t+16,buffer_u32),	 // therefore this will be same
		format: buffer_peek(bu,t+20,buffer_u16),			// 1: PCM
		_channels: buffer_peek(bu,t+22,buffer_u16),		// number of channels
		samplerate: buffer_peek(bu,t+24,buffer_u32),		// samples per second (hz)
		samplerate2: buffer_peek(bu,t+28,buffer_u32),	// (Sample Rate * BitsPerSample * Channels) / 8
		bps2: buffer_peek(bu,t+32,buffer_u16),			// (BitsPerSample * Channels) / 8 - 1: 8 bit mono, 2:8 bit stereo/16 bit mono, 4: 16 bit stereo
		bps: buffer_peek(bu,t+34,buffer_u16),			// bits per sample
		datatag: buffer_word(bu,t+36),				// "data"
		datasize: buffer_peek(bu,t+40,buffer_u32)		// size of data section
		}
	trace(string(m));
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