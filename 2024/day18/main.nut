dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local falling_bytes = []
::kilobyte_hashmap <- {}

local grid_size = 71
local num_bytes_dropped = 1024
local data_file = "input"
// local grid_size = 7
// local num_bytes_dropped = 12
// local data_file = "smallboy"

local final_key = (grid_size-1) + "," + (grid_size-1)

local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	local count=0
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			if(count < num_bytes_dropped) kilobyte_hashmap[text] <- count
			else
			{
				falling_bytes.append(text)
			}
			count++
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

function InBounds(y,x)
{
	return y > -1 && y < grid_size && x > -1 && x < grid_size
}

local directions = [[0,1],[1,0],[0,-1],[-1,0]]

function BFS(start,return_fail=false)
{
	local Q = []
	local visited = {}
	local start_key = start[1] + "," + start[0]
	local init_path = {}
	init_path[start_key] <- null
	Q.append(start.append(init_path))
	visited[start_key] <- null
	local longest = {}
	while (Q.len() > 0)
	{
		local node = Q.remove(0)
		local y = node[0]
		local x = node[1]
		local path = node[2]
		for(local i=0;i<4;i++)
		{
			local new_x = directions[i][0] + x
			local new_y = directions[i][1] + y
			if (InBounds(new_y,new_x))
			{
				local new_key = new_x + "," + new_y
				if(new_key in kilobyte_hashmap) continue
				if(!(new_key in visited)) visited[new_key] <- null
				else continue
				path[new_key] <- null
				local new_path = clone path
				delete path[new_key]
				Q.append([new_y,new_x,new_path])
				if(new_key==final_key) return new_path
				if(return_fail && (new_path.len() > longest.len())) longest = new_path
			}
		}
	}
	return longest
}

function print_path(path)
{
	for (local i=0;i<grid_size;i++)
	{
		for (local j=0;j<grid_size;j++)
		{
			local c_key = (j + "," + i)
			if(c_key in kilobyte_hashmap) print("#")
			else if (c_key in path) print("O")
			else print(".")
		}
		printl("")
	}
}

local result_path = BFS([0,0])
p1_value = result_path.len() - 1

::p <- result_path
foreach(byte in falling_bytes)
{
	if(byte in kilobyte_hashmap) continue
	kilobyte_hashmap[byte] <- 0
	if(!(byte in p)) continue
	else
	{
		local new_try = BFS([0,0])
		if(new_try.len()==0)
		{
			p2_value = byte
			break
		}
		p = new_try
	}
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)