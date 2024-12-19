dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local data_file = "input"
// local data_file = "smallboy"

local cache = {}

local patterns = []

local design_array = array(0)

local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	local designs = false;
	for (local i = 0; i < size; i++) {
		local c = blobData[i];
		local char = c.tochar();
		if (char=="\n")
		{
			if(designs)
			{
				design_array.append(text)
			}
			else
			{
				if (text=="")
				{
					designs=true;
					continue
				}
				patterns.append(text)
			}
			text = ""
		}
		else if (char == ",")
		{
			patterns.append(text)
			text = ""
		}
		else
		{
			if(char != " ") text += char
		}
	}
	fileblob.close();
}
else
	throw false

::pattern_map <- {}

foreach(pattern in patterns)
{
	local map = pattern_map
	for(local i=0;i<pattern.len();i++)
	{
		local c = pattern[i]
		if(!(c in map)) map[c] <- {}
		map = map[c]
	}
	map[0] <- {}
}

function CheckDesign(design,map)
{
	if(design in cache) return cache[design]
	else cache[design] <- 0

	local start_key = design[0]
	if(!(start_key in map))
	{
		cache[design] <- 0
		return 0
	}

	local break_points = array(0)
	local temp_map = map
	local end=-1
	for(local i=0;i<design.len();i++)
	{
		local key = design[i]
		if (0 in temp_map) break_points.insert(0,i)
		if (!(key in temp_map))
		{
			end=i
			break
		}
		temp_map = temp_map[key]
	}

	if(end==-1 && (0 in temp_map)) cache[design]++

	foreach(bp in break_points)
	{
		local removed = design.slice(0,bp)
		cache[design] += CheckDesign(design.slice(bp),pattern_map)
	}
	return cache[design]
}

local count=0
foreach(design in design_array)
{
	local total = CheckDesign(design,pattern_map)
	if(total)
	{
		p1_value++
		p2_value += total
	}
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)