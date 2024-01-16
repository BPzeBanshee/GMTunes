// Feather disable GM2016

#region bit_io
// Output one bit (bit = 0,1)
PutBit = function(bit){
	//static unsigned int  buffer = 0, mask = 128;
	//buffer = 0;
	//mask = 128;
	
	if (bit) buffer |= mask;
	mask = mask >> 1;
	//>>=
	if ((mask) == 0) 
		{
		//if !file_text_eof(f) then file_text_write_string(f,string(buffer));
		if buffer_tell(bu_out) == buffer_get_size(bu_out) 
		then trace("Write Error")
		else buffer_write(bu_out,buffer_u8,buffer);
		//if (putc(buffer, outfile) == EOF) Error("Write Error");
		buffer = 0;  mask = 128;  codesize++;
		}
}

//Send remaining bits
FlushBitBuffer = function(){
	for (var i = 0; i < 7; i++) PutBit(0);
}
// Get one bit (0 or 1)
GetBit = function(){
	//static unsigned int  buffer, mask = 0;
	//buffer = 0;
	//mask = 0;
	mask = mask >> 1;
	if ((mask) == 0) 
		{
		buffer = buffer_read(bu_in,buffer_u8);//getc(infile);  
		mask = 128;
		}
	var result = (buffer & mask) != 0;
	//trace(string("GetBit: {0}",result));
	return (result);
}
#endregion

// Initialize model
StartModel = function(){
	var ch, sym, i;
	
	sym_cum[N_CHAR] = 0;
	for (sym = N_CHAR; sym >= 1; sym--) 
		{
		ch = sym - 1;
		char_to_sym[ch] = sym;  sym_to_char[sym] = ch;
		sym_freq[sym] = 1;
		sym_cum[sym - 1] = sym_cum[sym] + sym_freq[sym];
		}
	sym_freq[0] = 0;  /* sentinel (!= sym_freq[1]) */
	position_cum[N] = 0;
	for (i = N; i >= 1; i--) position_cum[i - 1] = floor(position_cum[i] + 10000 / (i + 200));
			/* empirical distribution function (quite tentative) */
			/* Please devise a better mechanism! */
}

UpdateModel = function(sym){
	var i, c, ch_i, ch_sym;
	
	if (sym_cum[0] >= MAX_CUM) 
		{
		c = 0;
		for (i = N_CHAR; i > 0; i--) 
			{
			sym_cum[i] = c;
			c += (sym_freq[i] = (sym_freq[i] + 1) >> 1);
			}
		sym_cum[0] = c;
		}
	for (i = sym; sym_freq[i] == sym_freq[i - 1]; i--) {};
	if (i < sym) 
		{
		ch_i = sym_to_char[i];    ch_sym = sym_to_char[sym];
		sym_to_char[i] = ch_sym;  sym_to_char[sym] = ch_i;
		char_to_sym[ch_i] = sym;  char_to_sym[ch_sym] = i;
		}
	sym_freq[i]++;
	while (--i >= 0) sym_cum[i]++;
}

BinarySearchSym = function(xx){
	//1      if xx >= sym_cum[1],
	//N_CHAR if sym_cum[N_CHAR] > xx,
	//i such that sym_cum[i - 1] > xx >= sym_cum[i] otherwise
	var i, j, k;
	i = 1;  
	j = N_CHAR;
	while (i < j) 
		{
		k = floor((i + j) / 2);
		if (sym_cum[k] > xx) i = k + 1 else j = k;
		}
	return i;
}

BinarySearchPos = function(xx){
	//0 if xx >= position_cum[1],
	//N - 1 if position_cum[N] > xx,
	//i such that position_cum[i] > xx >= position_cum[i + 1] otherwise
	var i, j, k;
	i = 1;  
	j = N;
	while (i < j) 
		{
		k = floor((i + j) / 2);
		if (position_cum[k] > xx) then i = k + 1 else j = k;
		}
	return i - 1;
}

//void StartDecode(void)
StartDecode = function(){
	for (var i = 0; i < M + 2; i++) value = 2 * value + GetBit();
}

//int DecodeChar(void)
DecodeChar = function(){
	var sym, ch;
	var range = 0;
	
	range = high - low;
	//sym = BinarySearchSym((unsigned int)(((value - low + 1) * sym_cum[0] - 1) / range));
	var f = floor(((value - low + 1) * sym_cum[0] - 1) / range);
	//trace(string("f: {0}",f));
	sym = BinarySearchSym(f);
	//trace(string("sym: {0}",sym));
	high = low + floor((range * sym_cum[sym - 1]) / sym_cum[0]);
	low +=       floor((range * sym_cum[sym    ]) / sym_cum[0]);
	//for ( ; ; ) {
	while true 
		{
		if (low >= Q2) 
			{
			value -= Q2;  
			low -= Q2;  
			high -= Q2;
			} 
		else if (low >= Q1 && high <= Q3) 
			{
			value -= Q1;  
			low -= Q1;  
			high -= Q1;
			} 
		else if (high > Q2) break;
		low += low;  
		high += high;
		value = 2 * value + GetBit();
		}
	ch = sym_to_char[sym];
	UpdateModel(sym);
	return ch;
}

//int DecodePosition(void)
DecodePosition = function(){
	var position;
	var range = 0;
	
	range = high - low;
	//position = BinarySearchPos((unsigned int)(((value - low + 1) * position_cum[0] - 1) / range));
	position = BinarySearchPos(floor(((value - low + 1) * position_cum[0] - 1) / range));
	high = low + floor((range * position_cum[position    ]) / position_cum[0]);
	low +=      floor((range * position_cum[position + 1]) / position_cum[0]);
	//for ( ; ; ) {
	while true 
		{
		if (low >= Q2) 
			{
			value -= Q2;  
			low -= Q2;  
			high -= Q2;
			} 
		else if (low >= Q1 && high <= Q3) 
			{
			value -= Q1;  
			low -= Q1;  
			high -= Q1;
			} 
		else if (high > Q2) break;
		low += low;  
		high += high;
		value = 2 * value + GetBit();
		}
	return position;
}

Decode = function(){
	var i, j, k, r, c;
	var count = 0;

	if infile != ""
		{
		if !file_exists(infile) then return -1;
		buffer_load_ext(bu_in,infile,0);
		}
	if buffer_get_size(bu_in) == 0 then return -2;
	//if (fread(&textsize, sizeof textsize, 1, infile) < 1)
	//	trace("Read Error");  /* read size of text */
	//if (textsize == 0) return;
	buffer_seek(bu_in,buffer_seek_start,0);
	buffer_seek(bu_out,buffer_seek_start,0);
	textsize = buffer_get_size(bu_in);
	trace(string("textsize: {0}",textsize));
	trace(string("expected output: {0}",buffer_get_size(bu_out)));
	//f = file_text_open_write(outfile);
	StartDecode();  
	StartModel();
	for (i = 0; i < N - F; i++) text_buf[i] = "";
	
	r = N - F;
	for (count = 0; count < textsize; count++) 
		{
		c = DecodeChar();
		trace(string("DecodeChar: {0}",c));
		
		if (c < 256) 
			{
			//file_text_write_string(f,c);
			buffer_write(bu_out,buffer_text,c);//putc(c, outfile);  
			text_buf[r++] = c;
			r &= (N - 1);  
			count++;
			} 
		else 
			{
			i = (r - DecodePosition() - 1) & (N - 1);
			j = c - 255 + THRESHOLD;
			for (k = 0; k < j; k++) 
				{
				c = text_buf[(i + k) & (N - 1)];
				//file_text_write_string(f,c);
				buffer_write(bu_out,buffer_text,c);//putc(c, outfile);  
				text_buf[r++] = c;
				r &= (N - 1);  
				count++;
				}
			}
		if (count > printcount) 
			{
			trace(string("printcount: {0}\r", count));  
			printcount += 1024;
			}
		}
	//file_text_close(f);
	buffer_save(bu_out,outfile);
	//trace(string("{0}\n", count));
}