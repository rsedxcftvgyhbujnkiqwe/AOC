dofile("../lib/stdlib.nut")
local p1_value = 0
local p2_value = 0
local start_time = time()
function IsEnabled(base_index,enabled_indices,disabled_indices)
{
	local closest_enabled = 0
	local closest_disabled = -1
	foreach(index in enabled_indices)
	{
		local diff = base_index - index
		if (diff > 0) closest_enabled = index
		else break
	}
	foreach(index in disabled_indices)
	{
		local diff = base_index - index
		if (diff > 0) closest_disabled = index
		else break
	}
	return closest_enabled > closest_disabled
}

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local possible_starts = []
	local possible_conditions = []
	local count = 0
	local line = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char!="\n")
		{
			line += char
			if(char == "m") possible_starts.append(count)
			else if(char == "d") possible_conditions.append(count)
			count++
		}
	}
	local enabled_index = []
	local disabled_index = []
	//calculate possible conditionals first
	foreach(start_index in possible_conditions)
	{
		if (line.len() - start_index > 3 && line.slice(start_index,start_index+4) == "do()") enabled_index.append(start_index)
		else if (line.len() - start_index > 6 && line.slice(start_index,start_index+7) == "don't()") disabled_index.append(start_index)
	}
	foreach(start_index in possible_starts)
	{
		local num_start = start_index+4
		if (line.slice(start_index,num_start) == "mul(") //valid start
		{
			local num1 = null
			local num2 = null
			local text = ""
			local valid = true
			local final_index = -1
			for(local j=num_start;j<line.len();j++)
			{
				local line_char = line[j]
				final_index = j
				if(IsCharNumeric(line_char)) text += line_char.tochar()
				else if (line_char==',')
				{
					if(text=="" || num1 != null)
					{
						valid = false
						break
					}
					num1 = text.tointeger()
					text = ""
				}
				else if (line_char==')')
				{
					if(text=="" || num1 == null)
					{
						valid = false
						break
					}
					num2 = text.tointeger()
					break
				}
				else
				{
					valid = false
					break
				}
			}
			if (valid)
			{
				p1_value += num1 * num2
				if(IsEnabled(start_index,enabled_index,disabled_index)){
					p2_value += num1 * num2
				}
			}
		}
	}
	fileblob.close();
}
else
	throw false

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)
printl("Total time: " + (time() - start_time) + "s")