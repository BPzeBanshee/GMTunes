/// @desc string_wordwrap_width(text,width,break,split)
/// @param {String} text_current
/// @param {Real} text_width
/// @param {String} [text_break]
/// @param {Bool} [text_split]
function string_wordwrap_width(text_current, text_width, text_break="\n", text_split=false) {
	//
	//  Returns a given string, word wrapped to a pixel width,
	//  with line break characters inserted between words.
	//  Uses the currently defined font to determine text width.
	//
	//      string      text to word wrap, string
	//      width       maximum pixel width before a line break, real
	//      break       line break characters to insert into text, string
	//      split       split words that are longer than the maximum, bool
	//
	/// GMLscripts.com/license
	var pos_space = -1;
	var pos_current = 1;
	if !is_string(text_break) then text_break = "\n";
	var text_output = "";
	while (string_length(text_current) >= pos_current) {
	    if (string_width(string_copy(text_current,1,pos_current)) > text_width) {
	        //if there is a space in this line then we can break there
	        if (pos_space != -1) {
	            text_output += string_copy(text_current,1,pos_space) + string(text_break);
	            //remove the text we just looked at from the current text string
	            text_current = string_copy(text_current,pos_space+1,string_length(text_current)-(pos_space));
	            pos_current = 1;
	            pos_space = -1;
	        } else if (text_split) {
	            //if not, we can force line breaks
	            text_output += string_copy(text_current,1,pos_current-1) + string(text_break);
	            //remove the text we just looked at from the current text string
	            text_current = string_copy(text_current,pos_current,string_length(text_current)-(pos_current-1));
	            pos_current = 1;
	            pos_space = -1;
	        }
	    }
	    if (string_char_at(text_current,pos_current) == " ") pos_space = pos_current;
	    pos_current += 1;
	}
	if (string_length(text_current) > 0) text_output += text_current;
	return text_output;
}