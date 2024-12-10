dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local trail_grid = [array(0),[-1]]
local trailheads = array(0)
local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local count1 = 1
	local count2 = 1
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			trail_grid[count2].append(-1)
			trail_grid.append([-1])
			count1 = 1
			count2++
		}
		else
		{
			local val = char.tointeger()
			trail_grid[count2].append(val)
			if(val == 0) trailheads.append([count2,count1])
			count1++
		}
	}
	fileblob.close();
}
else
	throw false

//pad with -1 to avoid excessive calculations and bounds checking
local temp_arr = array(0)
for(local i = 0; i<trail_grid[1].len();i++)
{
	temp_arr.append(-1)
}
trail_grid[0] = temp_arr
trail_grid[trail_grid.len()-1] = temp_arr

local directions = [[-1,0],[1,0],[0,-1],[0,1]]
local print_trail = true
function GetNumTrailEnds(head,current,current_val,end_points)
{
	local success = 0
	foreach(direction in directions)
	{
		local next = [current[0]+direction[0],current[1]+direction[1]]
		local next_val = trail_grid[next[0]][next[1]]
		if(next_val == current_val+1)
		{
			local coordstring = next[0] + "," + next[1]
			//optimization - don't follow trails that have already been traced
			if(next_val == 9)
			{
				success++
				if(end_points.find(coordstring)==null) end_points.append(coordstring)
				continue
			}
			success += GetNumTrailEnds(head,next,next_val,end_points)
		}
	}
	return success
}

foreach(head in trailheads)
{
	local unique_ends = array(0)
	local total_paths = GetNumTrailEnds(head,clone head,0,unique_ends)
	p1_value += unique_ends.len()
	p2_value += total_paths
	print_trail = false
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)