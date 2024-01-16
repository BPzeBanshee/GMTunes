/// @description  CONSOLE TEXT FORMATTING
txt = global.debug_text;
while string_height((txt)) > window_get_height()
    {
    txt = string_delete(txt,1,string_pos("\n",txt));
    }