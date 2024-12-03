//iterate over a file

local fileblob = file("input/smallboy.txt", "rb");
local text = "";
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
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