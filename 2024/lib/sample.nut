dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local fileblob = file("input/smallboy.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			//do something with the line
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