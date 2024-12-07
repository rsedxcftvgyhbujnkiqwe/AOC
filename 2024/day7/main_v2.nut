dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

function check_line(test_value,line_array,len,index,p2)
{
	local cval = line_array[len - index]
	if(index==len)
	{
		if(test_value==cval) return true
		return false
	}
	index++
	if(check_line(test_value-cval,line_array,len,index,p2)) return true
	if(test_value % cval==0 && check_line(test_value/cval,line_array,len,index,p2)) return true
	if(p2)
	{
		local tstring = test_value.tostring()
		local cstring = cval.tostring()
		local tlen = tstring.len()
		local clen = cstring.len()
		if(tlen >= clen && tstring.slice(tlen-clen)==cstring)
		{
			if (check_line(tstring.slice(0,tlen-clen).tointeger(),line_array,len,index,p2)) return true
		}
	}
	return false
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
			if(check_line(test_value,int_array,int_array.len()-1,0,false))
			{
				p1_value += test_value
				p2_value += test_value
			}
			else if(check_line(test_value,int_array,int_array.len()-1,0,true))
			{
				p2_value += test_value
			}
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

