dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local grid = []

local start_pos = null;
local end_pos = null;

local min_saved = 100
local data_file = "input"
// local min_saved = 50
// local data_file = "smallboy"

local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local line_array = array(0)
	local count1 = 0;
	local count2 = 0;
	for (local i = 0; i < size; i++) {
		local char = blobData[i];
		if (char=='\n')
		{
			grid.append(line_array)
			line_array = array(0)
			count1 = 0;
			count2++;
		}
		else
		{
			if(char=='S') {start_pos = [count2,count1];line_array.append('.')}
			else if (char=='E') {end_pos = [count2,count1];line_array.append('.')}
			else line_array.append(char)
			count1++;
		}
	}
	fileblob.close();
}
else
	throw false

local grid_height = grid.len()-1
local grid_length = grid[0].len()-1

local c_pos = start_pos

local path_map = {}

local directions = [[0,1],[1,0],[0,-1],[-1,0]]

local current_dir = 0

local ekey = end_pos[0] + "," + end_pos[1]

local path_points = []

local count = 0;
while (true)
{
	local y = c_pos[0]
	local x = c_pos[1]
	local ckey = y + "," + x
	path_points.append(c_pos)
	path_map[ckey] <- {block_dirs=[0,1,2,3],index=count}
	if(count>0) path_map[ckey].block_dirs.remove(path_map[ckey].block_dirs.find((current_dir + 2)%4))
	if(ckey==ekey) break
	for(local _=0;_<4;_++)
	{
		local dir = directions[current_dir]
		local new_y = y + dir[0]
		local new_x = x + dir[1]
		if(grid[new_y][new_x]!='#')
		{
			local ind = path_map[ckey].block_dirs.find(current_dir)
			if(ind==null) {
				current_dir = (current_dir+1)%4
				continue
			}
			path_map[ckey].block_dirs.remove(ind)
			c_pos = [new_y,new_x]

			count++
			break
		}
		current_dir = (current_dir+1)%4
	}
}

grid[end_pos[0]][end_pos[1]] = '.'

function InBounds(y,x)
{
	return y > -1 && x > -1 && y < grid_height && x < grid_length
}

local cheats = {}

local cheats_20 = {}
local total = path_points.len()
for(local p = 0; p < path_points.len()-1; p++)
{
	printl("checked " + p + "/" + total)
	local point = path_points[p]
	local y = point[0]
	local x = point[1]
	local ckey = y + "," + x
	for (local n=p+1;n<path_points.len();n++)
	{
		local n_y = path_points[n][0]
		local n_x = path_points[n][1]
		local n_key = n_y + "," + n_x
		local distance = abs(n_y-y) + abs(n_x-x)
		local path_dist = path_map[n_key].index - path_map[ckey].index
		if(distance<2 || distance > 22) continue
		if(distance<=path_dist)
		{
			local saved = path_dist-distance
			if(distance<3) //2 len skip
			{
				if(!(saved in cheats)) cheats[saved] <- [[ckey,n_key]]
				else cheats[saved].append([ckey,n_key])
			}
			if(distance<21) //20 len skip
			{
				if(!(saved in cheats_20)) cheats_20[saved] <- [[ckey,n_key]]
				else cheats_20[saved].append([ckey,n_key])
			}
		}
	}
}

foreach(k,v in cheats)
{
	if(k >= min_saved)
	{
		p1_value += v.len()
	}
}

foreach(k,v in cheats_20)
{
	if(k >= min_saved)
	{
		p2_value += v.len()
	}
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)