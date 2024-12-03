dofile("../lib/stdlib.nut")
local start_time = time()
local fileblob = file("input/bigboy.txt", "rb");
local p1_value = 0
local p2_value = 0

function IsLineSafe(line_array)
{
	local increasing = null
	for(local j=1;j<line_array.len();j++)
	{
		local diff = line_array[j] - line_array[j-1]
		local adiff = abs(diff)
		local increase = diff > 0
		if(increasing == null) increasing = increase
		local unsafe = adiff < 1 || adiff > 3 || (increasing != increase)
		if (unsafe) return false
	}
	return true
}

if (fileblob) {
	local text = "";
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local line_array = array(0)

	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char == "\n" && line_array.len() > 0)
		{
			line_array.append(text.tointeger())
			local safe = IsLineSafe(line_array)
			if(safe)
			{
				p1_value++
				p2_value++
			}
			else
			{
				for(local j = 0; j < line_array.len();j++)
				{
					local removed = line_array.remove(j)
					local safe = IsLineSafe(line_array)
					if (safe)
					{
						p2_value++
						break
					}
					line_array.insert(j,removed)
				}
			}
			text = ""
			line_array = array(0)
		}
		else if (char == " ")
		{
			line_array.append(text.tointeger())
			text = ""
		}
		else
		{
			text += char
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
printl("Runtime: " + (time() - start_time) + "s")