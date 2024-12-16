dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local initial_grid = []

local infinity = pow(2,256)

local start_pos = null
local end_pos = null

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local grid_row = array(0)
	local count1 = 0
	local count2 = 0
	for (local i = 0; i < size; i++) {
		local char = blobData[i];
		if (char=='\n')
		{
			initial_grid.append(grid_row)
			grid_row = array(0)
			count1=0
			count2++
		}
		else
		{
			if(char=='E') {end_pos = [count2,count1];grid_row.append('.')}
			else if(char=='S') {start_pos = [count2,count1];grid_row.append('.')}
			else grid_row.append(char)
			count1++
		}
	}
	fileblob.close();
}
else
	throw false

function print_grid(path)
{
	for(local height=0;height<initial_grid.len();height++)
	{
		for(local length=0;length<initial_grid[0].len();length++)
		{
			local key = height + "," + length;
			if (key in path) print("X")
			else
			{
				if(initial_grid[height][length]=='#') print(" ")
				else print(".")
			}
		}
		printl("")
	}
}

local directions = [[0,1],[1,0],[0,-1],[-1,0]]

local smallest_success = infinity

local valid_paths = {}

local start_key = start_pos[0] + "," + start_pos[1]
local end_key = end_pos[0] + "," + end_pos[1]

local distances={}

function IteratePath(cur_y,cur_x,current_direction,current_path,current_score,storage)
{
	local cur_key = cur_y + "," + cur_x
	if(cur_key in current_path) return
	local runs = 0
	for(local i=0;i<4;i++)
	{
		local vec_y = directions[i][0]
		local vec_x = directions[i][1]
		local new_y = cur_y+vec_y
		local new_x = cur_x+vec_x
		if((current_direction+2)%4==i) continue
		if(initial_grid[cur_y+vec_y][cur_x+vec_x]!='.') continue
		runs++
		local new_key = new_y + "," + new_x
		if(new_key in current_path) continue;


		local score = 1
		if (current_direction!=i) score = 1001
		local new_score = current_score + score;
		if(new_score > smallest_success) continue;
		if(!(new_key in distances)) distances[new_key] <- infinity
		if (new_score > distances[new_key])
		{
			continue
		}

		if (current_direction!=i)
		{
			distances[new_key] = new_score
		}
		current_path[cur_key] <- null
		storage.append(cur_key)
		if(new_key==end_key)
		{
			storage.append(new_key)
			if(new_score < smallest_success)
			{
				smallest_success = new_score
				valid_paths[new_score] <- [clone current_path]
			}
			else if (new_score == smallest_success)
			{
				valid_paths[new_score].append(clone current_path)
			}
			// print_grid(current_path)
			// printl("^ score " + new_score)
			delete current_path[cur_key]
			storage.pop()
			storage.pop()
			return
		}
		IteratePath(new_y,new_x,i,current_path,new_score,storage)
		delete current_path[cur_key]
		storage.pop()
	}
}

local current_path = {}
IteratePath(start_pos[0],start_pos[1],0,current_path,0,[])

p1_value = smallest_success
local path_cache = {}
foreach(valid in valid_paths[smallest_success])
{
	foreach(point,n in valid)
	{
		if (!(point in path_cache)) path_cache[point] <- null
	}
}
print_grid(path_cache)
p2_value = path_cache.len()+1

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)