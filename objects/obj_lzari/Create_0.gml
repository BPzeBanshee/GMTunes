N = int64(4096);			// size of ring buffer
F = int64(60);				// upper limit for match_length
THRESHOLD = int64(2);		// encode string into position and length if match_length is greater than this
NIL = int64(N);			// index for root of binary search trees

M = int64(15);
Q1 = int64(32768);//((1) << M);
Q2 = int64(2 * Q1);
Q3 = int64(3 * Q1);
Q4 = int64(4 * Q1);
MAX_CUM = int64(Q1 - 1);
N_CHAR = int64(256 - THRESHOLD + F);
low = int64(0);
high = int64(Q4);
value = int64(0);
shifts = int64(0); // counts for magnifying low and high around Q2
char_to_sym = array_create(N_CHAR,int64(0));
sym_to_char = array_create(N_CHAR+1,int64(0));
sym_freq = array_create(N_CHAR+1,int64(0)); // frequency for symbols
sym_cum = array_create(N_CHAR+1,int64(0)); // cumulative freq for symbols
position_cum = array_create(N+1,int64(0)); // cumulative freq for positions

// ring buffer of size N, with extra F-1 bytes to facilitate string comparison
//unsigned char  
text_buf = array_create(N+F-1," ");
	
// of longest match.  These are set by the InsertNode() procedure.
match_position = int64(0); 
match_length = int64(0);  
		
// left & right children & parents -- These constitute binary search trees.
lson = array_create(N+1,int64(0));
rson = array_create(N+257,int64(0));
dad = array_create(N+1,int64(0));

// misc local variables
mask = 0;
buffer = 0;
textsize = 0; 
codesize = 0;
printcount = 0;

infile = "";
outfile = ""; //environment_get_variable("USERPROFILE")+"/Desktop/
bu_in = buffer_create(8,buffer_grow,1);
bu_out = buffer_create(8,buffer_grow,1);

// Method calls
event_user(0);