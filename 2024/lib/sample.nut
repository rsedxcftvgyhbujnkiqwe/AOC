dofile("../lib/stdlib.nut")
local starttime = clock()

local p1_value = 0
local p2_value = 0

//local data_file = "input"
local data_file = "smallboy"

local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
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
printl("Took " + (clock() - starttime) + "s")