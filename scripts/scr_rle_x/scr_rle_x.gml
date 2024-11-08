///@desc
/*function scr_rle_encode(input_array){
trace("W: {0}, H: {1}",array_length(input_array),array_length(input_array[0]));
var output_array = [];
var count_repeats = 0;
var count_uniques = 0;
var stack_uniques = [];
for (var yy=0;yy<array_length(input_array[0]);yy++)
	{
	for (var xx=0;xx<array_length(input_array);xx++)
		{
		var data = input_array[xx][yy];
		//trace(data);
		var data_next = -1;
		if xx+1 < array_length(input_array) data_next = input_array[xx+1][yy];
		if (data == data_next)
			{
			if count_uniques > 0
				{
				array_push(output_array,[count_uniques,stack_uniques]);
				stack_uniques = [];
				count_uniques = 0;
				}
			count_repeats++;
			if count_repeats > 127
				{
				array_push(output_array,[count_repeats,data]);
				count_repeats = 0;
				}
			}
		else
			{
			if count_repeats > 0
				{
				array_push(output_array,[count_repeats,data]);
				count_repeats = 0;
				}
			else // TODO: not sure if needed
				{
				count_uniques++;
				array_push(stack_uniques,data);
				}
			}
		}
	}
trace(output_array);
return output_array;
}*/

function scr_rle_encode(input_array){
trace("W: {0}, H: {1}",array_length(input_array),array_length(input_array[0]));
var output_array = [];
var count = 1;

// currently using 2d array for notes, increment through
for (var yy=0;yy<array_length(input_array[0]);yy++)
	{
	for (var xx=0;xx<array_length(input_array);xx++)
		{
		// get data
		var data = input_array[xx][yy];
		var data_next = -1;
		if xx+1 < array_length(input_array) data_next = input_array[xx+1][yy]
		else if yy+1 < array_length(input_array[0]) data_next = input_array[0][yy+1];
		
		// decide what to do with it
		if (data == data_next)
			{
			count++;
			if count > 127
				{
				array_push(output_array,[127+count,data]);
				count = 1;
				}
			}
		else
			{
			var result = count > 1 ? 128+count : count;
			array_push(output_array,[result,data]);
			count = 1;
			}
		}
	}
trace(output_array);
return output_array;
}