dofile("../lib/stdlib.nut")
local starttime = clock()

local p1_value = 0
local p2_value = 0

local data_file = "input"
// local data_file = "smallboy2"

local starting_values = array(0)

local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			starting_values.append(text.tointeger())
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

function IterateSecret(num)
{
	num = ((num*64)^num)%16777216
	num = (num/32).tointeger()^num
	num = ((num*2048)^num)%16777216
	return num
}

local diff_map = {}

foreach(val in starting_values)
{
	local cur_diffmap = {}
	local diffs = []
	for(local i = 0;i<2000;i++)
	{
		local newval = IterateSecret(val)
		local diff = newval%10-val%10
		diffs.append(diff)
		if(i>2)
		{
			local diff_key =diffs[i-3] + "" + diffs[i-2] + "" + diffs[i-1] + "" + diffs[i]
			if(!(diff_key in cur_diffmap)) cur_diffmap[diff_key] <- newval%10
		}
		val = newval
	}
	foreach(k,v in cur_diffmap)
	{
		if(!(k in diff_map)) diff_map[k] <- v
		else diff_map[k] += v
	}
	p1_value += val
}

local highest = 0
local highest_key = null
foreach(k,v in diff_map)
{
	if (v > highest)
	{
		highest = v
		highest_key = k
	}
}

printl("Highest banana count: " + highest + " with pattern " + highest_key)

p2_value = highest

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)
printl("Took " + (clock() - starttime) + "s")