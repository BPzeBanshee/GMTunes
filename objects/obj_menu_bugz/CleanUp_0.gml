for (var xx=0;xx<array_length(bug);xx++)
	{
	for (var yy=0; yy < array_length(bug[xx]); yy++)
		{
		// Delete 'show' portrait
		sprite_delete(bug[xx][yy].show);
		
		// Delete sprite previews (function loads all sizes despite us only using size 1)
		for (var zz=0; zz < array_length(bug[xx][yy].spr); zz++) 
			{
			for (var aa=0; aa < array_length(bug[xx][yy].spr[zz]); aa++)
				{
				sprite_delete(bug[xx][yy].spr[zz][aa]);
				}
			}
		}
	}