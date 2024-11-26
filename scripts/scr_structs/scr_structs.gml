// TODO: rename to something more technically accurate (it's Bug instance data, not Bug file data)
function bug_struct() constructor {
	filename = "";
	bugztype = 0; // Not used in .tun file except in error codes. used in .bug
	dir = 0; //0-3, 0: up, 1: right, etc
	gear = 4;
	pos = [0,0]; //[x,y,dir]
	ctrl = [-1,-1];
	paused = false; //true/false
	volume = 128; //0-128 in increments of 16
	}
	
function playfield_struct() constructor {
	version = 1;
	name = "";
	author = "";
	desc = "";
	preview_image = "";
	background = "";
	camera_pos = [0,0];
	pixelsize = 4; // SimTunes uses pixelsize 4,8,16
	camera_zoom = 0; // SimTunes uses 0-2
	warp_list = []; //[xfrom,yfrom,xto,yto] //[-1,-1,-1,-1]
	flag_list = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]]; //[x,y,dir]
	note_list = Array2(160,104);//[note,x,y]
	ctrl_list = Array2(160,104);
	bugz = {
		yellow: new bug_struct(),
		green: new bug_struct(),
		blue: new bug_struct(),
		red: new bug_struct()
		}
	}
	
function default_playfield() : playfield_struct() constructor {
	version = 1;
	name = "New user";
	author = "New author";
	desc = "This is a new playfield.";
	background = "BACK01.BAC"; // I personally like 03GP4BT.BAC but SimTunes defaults to this
	bugz.yellow.filename = "YELLOW00.BUG";
	bugz.yellow.pos = [576,1280];
	bugz.yellow.dir = 0;
	bugz.green.filename = "GREEN00.BUG";
	bugz.green.pos = [1920,384];
	bugz.green.dir = 180;
	bugz.blue.filename = "BLUE00.BUG";
	bugz.blue.pos = [1920,1280];
	bugz.blue.dir = 90;
	bugz.red.filename = "RED00.BUG";
	bugz.red.pos = [576,384];
	bugz.red.dir = 270;
	}