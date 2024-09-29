for (var xx=0;xx<array_length(bug);xx++)
	{
	for (var yy=0; yy < array_length(bug[xx]); yy++)
		{
		sprite_delete(bug[xx][yy].spr);// = load_bug_metadata(lists[xx][yy]);
		}
	}