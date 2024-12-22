dofile("../lib/stdlib.nut")
local starttime = clock()

local p1_value = 0
local p2_value = 0

local data_file = "input"
// local data_file = "smallboy"
local patterns = array(0)
local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local pattern = ""
	for (local i = 0; i < size; i++) {
		local char = blobData[i];
		if (char=='\n')
		{
			patterns.append(pattern)
			pattern = ""
		}
		else
		{
			pattern += char.tochar()
		}
	}
	fileblob.close();
}
else
	throw false

local numpad_grid = [
	"XXXXX",
	"X789X",
	"X456X",
	"X123X",
	"XX0AX",
	"XXXXX"
]
local numpad_map = {}
numpad_map['7'] <- [1,1]
numpad_map['8'] <- [1,2]
numpad_map['9'] <- [1,3]
numpad_map['4'] <- [2,1]
numpad_map['5'] <- [2,2]
numpad_map['6'] <- [2,3]
numpad_map['1'] <- [3,1]
numpad_map['2'] <- [3,2]
numpad_map['3'] <- [3,3]
numpad_map['0'] <- [4,2]
numpad_map['A'] <- [4,3]

local keypad_grid = [
	"XXXXX",
	"XX^AX",
	"X<v>X",
	"XXXXX"
]

local keypad_map = {}
keypad_map['^'] <- [1,2]
keypad_map['A'] <- [1,3]
keypad_map['<'] <- [2,1]
keypad_map['v'] <- [2,2]
keypad_map['>'] <- [2,3]

local dir_map = {}
dir_map['<'] <- [0,-1]
dir_map['v'] <- [1,0]
dir_map['>'] <- [0,1]
dir_map['^'] <- [-1,0]

local directions_numpad = ['v','>','^','<']
local directions_keypad = ['v','<','>','^']

local bfs_cache = {}

function numBFS(start,end)
{
	local path_key = start.tochar() + end.tochar()
	if(path_key in bfs_cache) return bfs_cache[path_key]
	if(start==end) return ["A"]
	local spos = numpad_map[start]
	local epos = numpad_map[end]
	local Q = [[start,"",{}]]
	Q[0][2]['X'] <- null
	Q[0][2][start] <- null
	local valid_paths = array(0)
	local length = 99
	while(Q.len()>0)
	{
		local cfg = Q.remove(0)
		local pos = numpad_map[cfg[0]]
		local y = pos[0]
		local x = pos[1]
		local path = cfg[1]
		local visited = clone cfg[2]
		foreach(dir in directions_numpad)
		{
			local dirvec = dir_map[dir]
			local new_y = dirvec[0] + y
			local new_x = dirvec[1] + x
			local val = numpad_grid[new_y][new_x]
			if(val in visited) continue
			if(val != end) visited[val] <- null
			local new_path = path + dir.tochar()
			Q.append([val,new_path,visited])
			if(val==end)
			{
				local new_len = new_path.len()
				if(new_len > length) continue
				length = new_len
				valid_paths.append(new_path + "A")
			}
		}
	}
	bfs_cache[path_key] <- valid_paths
	return valid_paths
}

function keyBFS(start,end)
{
	local path_key = start.tochar() + end.tochar()
	if(path_key in bfs_cache) return bfs_cache[path_key]
	if(start==end) return ["A"]
	local spos = keypad_map[start]
	local epos = keypad_map[end]
	local Q = [[start,"",{}]]
	Q[0][2]['X'] <- null
	Q[0][2][start] <- null
	local valid_paths = array(0)
	local length = 99
	while(Q.len()>0)
	{
		local cfg = Q.remove(0)
		local pos = keypad_map[cfg[0]]
		local y = pos[0]
		local x = pos[1]
		local path = cfg[1]
		local visited = clone cfg[2]
		foreach(dir in directions_keypad)
		{
			local dirvec = dir_map[dir]
			local new_y = dirvec[0] + y
			local new_x = dirvec[1] + x
			local val = keypad_grid[new_y][new_x]
			if(val in visited) continue
			if(val != end) visited[val] <- null
			local new_path = path + dir.tochar()
			Q.append([val,new_path,visited])
			if(val==end)
			{
				local new_len = new_path.len()
				if(new_len > length) continue
				length = new_len
				valid_paths.append(new_path + "A")
			}
		}
	}
	bfs_cache[path_key] <- valid_paths
	return valid_paths
}

local iter_cache = {}

function iterate(pattern,depth)
{
	local key = pattern + "," + depth
	if(key in iter_cache) return iter_cache[key]
	if (depth==0) return pattern.len()
	local working_pattern = "A" + pattern
	local total = 0
	for(local i=0;i<working_pattern.len()-1;i++)
	{
		local paths = keyBFS(working_pattern[i],working_pattern[i+1])
		local smallest = infinity
		foreach(path in paths)
		{
			local val = iterate(path,depth-1)
			if(val < smallest) smallest = val
		}
		total += smallest
	}
	iter_cache[key] <- total
	return total
}

//p1
foreach(pattern in patterns)
{
	local working_pattern = "A" + pattern
	local total = 0
	for(local i=0;i<working_pattern.len()-1;i++)
	{
		local paths = numBFS(working_pattern[i],working_pattern[i+1])
		local smallest = infinity
		foreach(path in paths)
		{
			local val = iterate(path,2)
			if(val < smallest) smallest = val
		}
		total += smallest
	}
	p1_value += total * pattern.slice(0,pattern.len()-1).tointeger()
}

//p2
local iter_cache = {}
foreach(pattern in patterns)
{
	local working_pattern = "A" + pattern
	local total = 0
	for(local i=0;i<working_pattern.len()-1;i++)
	{
		local paths = numBFS(working_pattern[i],working_pattern[i+1])
		local smallest = infinity
		foreach(path in paths)
		{
			local val = iterate(path,25)
			if(val < smallest) smallest = val
		}
		total += smallest
	}
	p2_value += total * pattern.slice(0,pattern.len()-1).tointeger()
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)
printl("Took " + (clock() - starttime) + "s")