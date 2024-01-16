if !af
    {
    a -= 0.1;
    if a <= 0.1 then af = !af;
    }
else
    {
    a += 0.1;
    if a >= 0.9 then af = !af;
    }
//image_alpha = a;

if selected
    {
    if(mouse_check_button(mb_left))
        {
        var dx = (mouse_x - mouse_xprev);
        var dy = (mouse_y - mouse_yprev);
        x += dx;
        y += dy;
        }
    if keyboard_check_pressed(vk_delete) then instance_destroy();
    }
    
mouse_xprev = mouse_x;
mouse_yprev = mouse_y;

