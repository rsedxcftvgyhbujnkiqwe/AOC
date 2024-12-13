dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0.0

local machine_config = []

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local config = array(0)
	local text = ""
	for (local i = 0; i < size; i++) {
		local char = blobData[i]
		if (char=='\n' || char == ',')
		{
			//do something with the line
			if(text == "") continue
			config.append(text.tointeger()/1.0)
			text = ""
			if(config.len()==6)
			{
				machine_config.append(config)
				config = array(0)
			}
		}
		else if (IsCharNumeric(char))
		{
			text += char.tochar()
		}
	}
	fileblob.close();
}
else
	throw false

function SysEquationMin(A_x,A_y,B_x,B_y,Target_x,Target_y)
{
	local A_count = (B_x*Target_y - B_y*Target_x)/(A_y*B_x - A_x*B_y)
	if(IsInteger(A_count))
	{
		return A_count*3 + (Target_x - A_x*A_count)/B_x
	}
	return 0
}

foreach(m in machine_config)
{
	p1_value += SysEquationMin(m[0],m[1],m[2],m[3],m[4],m[5])
	p2_value += SysEquationMin(m[0],m[1],m[2],m[3],m[4]+10000000000000,m[5]+10000000000000)
}


printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)