event_inherited();
if !selected then exit;
if keyboard_check_pressed(vk_up) then surf_scale += 1.0;
if keyboard_check_pressed(vk_down) && surf_scale > 1.0 then surf_scale -= 1.0;
if keyboard_check_pressed(vk_left) then direction += 90;
if keyboard_check_pressed(vk_right) then direction -= 90;