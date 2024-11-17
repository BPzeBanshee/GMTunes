///@desc Free sprite
if is_struct(mystruct)
	{
	sprite_delete(mystruct.show);
	sprite_delete(mystruct.back);
	delete mystruct;
	mystruct = -1;
	}