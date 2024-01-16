function get_filesize(myfile){
var f = file_bin_open(myfile, 0);
var size = file_bin_size(f);
file_bin_close(f);
return size;
}