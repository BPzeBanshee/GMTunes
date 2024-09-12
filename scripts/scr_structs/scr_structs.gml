///@desc
function bug_struct() constructor {
	filename = "";
	dir = 0; //0-3, 0: up, 1: right, etc
	gear = 4;
	pos = [0,0]; //[x,y,dir]
	paused = false; //true/false
	volume = 128; //0-128 in increments of 16
	}
	
function playfield_struct() constructor {
	version = -1;
	name = "";
	author = "";
	desc = "";
	preview_image = "";
	background = "";
	
	camera_pos = [-1,-1];
	pixelsize = -1; // SimTunes uses pixelsize 4,8,16, simplify here to 0-2
	warp_list = [[-1,-1,-1,-1]]; //[xfrom,yfrom,xto,yto]
	flag_list = [[-1,-1,-1]]; //[x,y,dir]
	note_list = -1; //ds_grid_write //[note,x,y]
	ctrl_list = -1; //ds_grid_write
	bugz = {
		yellow: new bug_struct(),
		green: new bug_struct(),
		blue: new bug_struct(),
		red: new bug_struct()
		}
	}