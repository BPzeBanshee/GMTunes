/// @desc  Shorthand for clearing an array like ds_grid_set_region
/// @param {array} array Description
/// @param {real} xx Description
/// @param {real} yy Description
/// @param {real} w Description
/// @param {real} h Description
/// @param {any*} value Description
/// @returns {real} Description
function array_clear(array,xx,yy,w,h,value){
for (var nx=0;nx<w;nx++)
for (var ny=0;ny<h;ny++)
	{
	array[xx+nx][yy+ny] = value;
	}
return 0;
}

/// @desc thanks to FrostyCat
/// (https://github.com/dicksonlaw583/gmsugar/blob/master/Array2.gml)
/// 
/// Array2(width,height, ...)
// Row-major interpretation of 2D array contents
function Array2(width,height,init=int64(0)){

var array2;
for (var yy = height-1; yy >= 0; yy--) {
	for (var xx = width-1; xx >= 0; xx--) {
		array2[xx,yy] = init;
	}
}
return array2;
}

function Array1(length,init=int64(0)){
var array;
for (var i=length-1;i>=0;i--) array[i] = init;
return array;
}