event_inherited();

if keyboard_check_pressed(vk_up) then surf_scale += 1;
if keyboard_check_pressed(vk_down) && surf_scale > 0 then surf_scale -= 1;