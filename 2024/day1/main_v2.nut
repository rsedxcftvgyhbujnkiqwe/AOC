dofile("../lib/stdlib.nut")
local start_time = time()

local left_col = []
local right_col = []
local p1_value = 0
local p2_value = 0
local left_count = {}
local right_count = {}

function processline(line)
{
	local nums = split(line," ")

	local l_int = nums[0].tointeger()
	left_col.append(l_int)
	if(!(l_int in left_count)) left_count[l_int] <- 1
	else left_count[l_int]++

	local r_int = nums[3].tointeger()
	right_col.append(r_int)
	if(!(r_int in right_count)) right_count[r_int] <- 1
	else right_count[r_int]++

	if (r_int in left_count) p2_value += r_int * left_count[r_int]
	if (l_int in right_count) p2_value +=  l_int * right_count[l_int]
	if (r_int == l_int) p2_value -= r_int
}

local fileblob = file("input/bigboy.txt", "rb");
if (fileblob) {
	local text = "";
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			processline(text)
			text = ""
		}
		else
		{
			text += char
		}
	}
	if(text != "") processline(text)
	fileblob.close();
}
else
	throw false

left_col.sort(@(a,b) a <=> b)
right_col.sort(@(a,b) a <=> b)

for(local i=0;i<left_col.len();i++)
{
	p1_value += abs(left_col[i] - right_col[i])
}

printl("Part 1")
printl(p1_value)

printl("Part 2")
printl(p2_value)

printl("Total runtime: " + (time() - start_time) + "s")