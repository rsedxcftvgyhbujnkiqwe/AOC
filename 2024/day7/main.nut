dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local size_cache = {}

function generate_op_combinations(length,num,current_combo,result_array)
{
	if (length == current_combo.len())
	{
		result_array.append(clone current_combo)
		return
	}

	for(local i=0;i<num;i++)
	{
		current_combo.append(i)
		generate_op_combinations(length,num,current_combo,result_array)
		current_combo.pop()
	}
}

function get_op_combinations(num,count)
{
	local op_array = array(0)
	generate_op_combinations(count,num,[],op_array)
	return op_array
}

function determine_operators(test_val,input_vals,num)
{
	//brute force!!
	local operators = null
	local val_size =  input_vals.len()-1
	if(val_size in size_cache) operators = size_cache[val_size]
	else operators = get_op_combinations(num,val_size)
	local successful_combinations = 0
	foreach(op_array in operators)
	{
		local result_val = input_vals[0]
		local i=0
		for(i;i<val_size;i++)
		{
			if(op_array[i]==2)
			{
				result_val = (result_val.tostring() + input_vals[i+1].tostring()).tointeger()
			}
			else if(op_array[i]==1)
			{
				result_val *= input_vals[i+1]
			}
			else
			{
				result_val += input_vals[i+1]
			}
		}
		if (result_val == test_val) {
			successful_combinations++
		}
	}
	return successful_combinations
}

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local test_value = 0
	local int_array = array(0)
	local text = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			int_array.append(text.tointeger())
			if(determine_operators(test_value,int_array,2))
			{
				p1_value += test_value
				p2_value += test_value
			}
			else if(determine_operators(test_value,int_array,3)) p2_value += test_value
			text = ""
			test_value = 0
			int_array = array(0)
		}
		else if (char==":")
		{
			test_value = text.tointeger()
			text = ""
		}
		else if (char == " ")
		{
			if (text != "")
			{
				int_array.append(text.tointeger())
				text = ""
			}
		}
		else
		{
			text += char
		}
	}
	fileblob.close();
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)