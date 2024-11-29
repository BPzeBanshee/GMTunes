///@desc Create buttons/array list
// First, array list
instance_create_depth(0,0,depth-1,obj_mouse_parent);
txta = []; obj = [];
array_push(txta,"TEXT/INFO (.BUG)");		array_push(obj,obj_decrypt_info);
array_push(txta,"RIFF (.BUG)");				array_push(obj,obj_decrypt_riff);
array_push(txta,"SHOW (.BUG)");				array_push(obj,obj_decrypt_show);
array_push(txta,"ANIM (.BUG)");				array_push(obj,obj_decrypt_anim);
array_push(txta,"STYL/LITE (.BUG)");		array_push(obj,obj_decrypt_lite);
array_push(txta,"BACK (.BAC)");		array_push(obj,obj_decrypt_back);
array_push(txta,"STP2 (.STP)");		array_push(obj,obj_decrypt_stp2);
array_push(txta,"VER5 (.TUN)");		array_push(obj,obj_decrypt_tun);
array_push(txta,"BM (.BMP)");		array_push(obj,obj_decrypt_bmp);
array_push(txta,"TUNERES.DAT");		array_push(obj,obj_decrypt_dat);
array_push(txta,"EXIT TO MAIN");

// Create buttons
for (var i=0; i<array_length(txta); i++)
    {
    button[i] = instance_create_depth(64,64+(32*i),0,obj_button);
    button[i].txt = txta[i];
    }