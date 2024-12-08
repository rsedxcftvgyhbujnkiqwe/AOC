dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local node_graph = {}
local unique_antinodes_p1 = []
local unique_antinodes_p2 = []

local grid_height = 0
local grid_length = 0

function InBounds(y,x)
{
	return (x>=0  && x <= grid_length && y >= 0 && y <= grid_height)
}

function GetAntinodes(c1,c2)
{
	local y1 = c1[0]
	local x1 = c1[1]
	local y2 = c2[0]
	local x2 = c2[1]
	local delta_x = x1-x2
	local delta_y = y1-y2
	local antinodes = [array(0),array(0)]
	//left
	local anode_y = y1+delta_y
	local anode_x = x1+delta_x
	while(InBounds(anode_y,anode_x))
	{
		antinodes[0].append([anode_y,anode_x])
		anode_y += delta_y
		anode_x += delta_x
	}
	//right
	local anode_y = y2-delta_y
	local anode_x = x2-delta_x
	while(InBounds(anode_y,anode_x))
	{
		antinodes[1].append([anode_y,anode_x])
		anode_y -= delta_y
		anode_x -= delta_x
	}
	return antinodes
}

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local count1 = 0
	local count2 = 0
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			if (grid_length==0) grid_length = count1 - 1
			count1 = -1
			count2++
		}
		else if (char != ".")
		{
			if(!(char in node_graph)) node_graph[char] <- []
			node_graph[char].append([count2,count1])
		}
		count1++
	}
	grid_height = count2 - 1
	fileblob.close();
}
else
	throw false

foreach(node_key,node_coords in node_graph)
{
	local num_coords = node_coords.len()
	if (num_coords == 1) continue

	for (local i1=0;i1<num_coords-1;i1++)
	{
		for(local i2=i1+1;i2<num_coords;i2++)
		{
			local c1 = node_coords[i1]
			local c2 = node_coords[i2]
			local antinodes = GetAntinodes(c1,c2)
			for (local direction=0;direction<antinodes.len();direction++)
			{
				local antinode_coords = antinodes[direction]
				for(local i=0;i<antinode_coords.len();i++)
				{
					local nodestring = antinode_coords[i][0] + "," +  antinode_coords[i][1]
					if(i==0 && unique_antinodes_p1.find(nodestring)==null) unique_antinodes_p1.append(nodestring)
					if(unique_antinodes_p2.find(nodestring)==null) unique_antinodes_p2.append(nodestring)
				}
			}
			local c1string = c1[0] + "," + c1[1]
			if(unique_antinodes_p2.find(c1string)==null) unique_antinodes_p2.append(c1string)
			local c2string = c2[0] + "," + c2[1]
			if(unique_antinodes_p2.find(c2string)==null) unique_antinodes_p2.append(c2string)
		}
	}
}

p1_value = unique_antinodes_p1.len()
p2_value = unique_antinodes_p2.len()

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)