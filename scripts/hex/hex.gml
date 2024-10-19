/// @desc  Converts a real to a hex string
/// @param {real} val Description
/// @returns {string} Description
function hex(val){
	// Setting c_hex :
	var c_hex; // could be set up initially as a globalvar instead of here
	for(var i=0; i<10; i++)  c_hex[i]=string(i);
	for(var i=10; i<16; i++) c_hex[i]=chr(55+i);

	// Preparing variables :
	var s="";

	// Extracting hex value :
	do
	{
	    s = c_hex[ val mod 16 ] + s;
	    val = val div 16;
	} until (val==0);

	// Returning result :
	return s;
	}
	
function hex_array(arr){
	var str = "[ ";
	for (var i=0;i<array_length(arr);i++)
		{
		str += hex(arr[i]);
		if i < array_length(arr)-1 str += ",";
		}
	str += " ]";
	return str;
}