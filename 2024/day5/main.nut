dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local nodes_forward = {}

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	local n1 = -1;
	local n2 = -1;
	local i = 0;
	for (i; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			if(text=="") break
			n2 = text

			if(!(n1 in nodes_forward)) nodes_forward[n1] <- [n2]
			else nodes_forward[n1].append(n2)
			text = ""
		}
		else if (char == "|")
		{
			n1 = text
			text = ""
		}
		else
		{
			text += char
		}
	}
	local line_values = array(0)
	local correct = true
	function verify_value(values,val)
	{
		if(val in nodes_forward)
		{
			local count = 0
			foreach(p_val in values)
			{
				if (nodes_forward[val].find(p_val)!=null)
				{
					return count
				}
				count++
			}
		}
		return null
	}
	for (++i; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			local bad_val = verify_value(line_values,text)
			if(bad_val==null) line_values.append(text)
			else
			{
				line_values.insert(bad_val,text)
				correct = false
			}

			if(correct)
			{
				p1_value += line_values[line_values.len()/2].tointeger()
			}
			else
			{
				p2_value += line_values[line_values.len()/2].tointeger()
			}
			text = ""
			line_values = array(0)
			correct = true
		}
		else if (char == ",")
		{
			local bad_val = verify_value(line_values,text)
			if(bad_val==null) line_values.append(text)
			else {
				line_values.insert(bad_val,text)
				correct = false
			}
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

