dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local warehouse = array(0)
local robot_moves = array(0)
local starting_position = null
local box_hashmap = {}

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local warehouse_row = array(0)
	local process_warehouse = true;
	local process_moves = false
	local count1 = 0;
	local count2 = 0;
	for (local i = 0; i < size; i++) {
		local char = blobData[i];
		if (char=='\n')
		{
			if(process_warehouse)
			{
				if(warehouse_row.len()==0)
				{
					process_warehouse = false
					process_moves = true
				}
				else
				{
					warehouse.append(warehouse_row)
					warehouse_row = array(0)
				}
				count1 = 0
				count2++
			}
		}
		else
		{
			if(process_warehouse) {
				warehouse_row.append(char)
				switch(char)
				{
					case 'O':
					{
						local cstring = count2 + "," + count1
						box_hashmap[cstring] <- [count2,count1]
						break
					}
					case '@':
					{
						starting_position = [count2,count1]
						break
					}
				}

				count1++
			}
			else robot_moves.append(char)
		}
	}
	fileblob.close();
}
else
	throw false

local current_position = clone starting_position

function print_grid(warehouse)
{
	for(local height=0;height<warehouse.len();height++)
	{
		local row_string = ""
		for(local length=0;length<warehouse[0].len();length++)
		{
			row_string += warehouse[height][length].tochar()
		}
		printl(row_string)
	}
}


//for part 2
local current_position_2 = null
local warehouse_2 = array(0)
local box_hashmap_2 = {}

for(local height=0;height<warehouse.len();height++)
{
	local row_array = array(0)
	for(local length=0;length<warehouse[0].len();length++)
	{
		switch(warehouse[height][length])
		{
			case '#':
			{
				row_array.extend(['#','#'])
				break
			}
			case 'O':
			{
				box_hashmap_2[(height) + "," + (length*2)] <- [height,length*2]
				row_array.extend(['[',']'])
				break
			}
			case '.':
			{
				row_array.extend(['.','.'])
				break
			}
			case '@':
			{
				current_position_2 = [height,length*2]
				row_array.extend(['@','.'])
				break
			}
		}
	}
	warehouse_2.append(row_array)
}

//part 1
function AttemptMove(cur_y,cur_x,mov_y,mov_x)
{
	local new_y = cur_y + mov_y
	local new_x = cur_x + mov_x
	switch(warehouse[new_y][new_x])
	{
		case 'O':
		{
			if(AttemptMove(new_y,new_x,mov_y,mov_x))
			{
				if(warehouse[cur_y][cur_x]=='O')
				{
					delete box_hashmap[cur_y + "," + cur_x]
					box_hashmap[new_y + "," + new_x] <- [new_y,new_x]
				}
				warehouse[new_y][new_x] = warehouse[cur_y][cur_x]
				warehouse[cur_y][cur_x] = '.'
				return true
			}
			return false
		}
		case '.':
		{
			if(warehouse[cur_y][cur_x]=='O')
			{
				delete box_hashmap[cur_y + "," + cur_x]
				box_hashmap[new_y + "," + new_x] <- [new_y,new_x]
			}
			warehouse[new_y][new_x] = warehouse[cur_y][cur_x]
			warehouse[cur_y][cur_x] = '.'
			return true
		}
		case '#': {
			return false;
		}
	}
}
foreach(move in robot_moves)
{
	local vec_y = 0;
	local vec_x = 0;
	switch(move)
	{
		case '<': {vec_x--; break;}
		case '^': {vec_y--; break;}
		case '>': {vec_x++; break;}
		case 'v': {vec_y++; break;}
	}
	local y = current_position[0]
	local x = current_position[1]
	if(AttemptMove(y,x,vec_y,vec_x))
	{
		current_position = [y+vec_y,x+vec_x]
	}
}

foreach(box in box_hashmap)
{
	p1_value += 100*(box[0]) + box[1]
}

//part 2
function CanMove(cur_y,cur_x,mov_y,mov_x,side_check=true)
{
	local new_y = cur_y + mov_y
	local new_x = cur_x + mov_x
	switch(warehouse_2[cur_y][cur_x])
	{
		case '[':
		case ']':
		{
			local half_y = cur_y;
			local half_x = cur_x + (warehouse_2[cur_y][cur_x]=='[' ? 1 : -1);
			if(side_check && mov_y!=0 && !CanMove(half_y,half_x,mov_y,mov_x,false)) return false
		}
	}
	switch(warehouse_2[new_y][new_x])
	{
		case '#': return false
		case '.': return true
		case '[':
		case ']': return CanMove(new_y,new_x,mov_y,mov_x,true)
	}
}

function PerformMove(cur_y,cur_x,mov_y,mov_x,moved_cache)
{
	if((cur_y + "," + cur_x) in moved_cache) return
	moved_cache[cur_y + "," + cur_x] <- null

	local new_y = cur_y + mov_y
	local new_x = cur_x + mov_x
	local update_cache = warehouse_2[cur_y][cur_x]=='['
	switch(warehouse_2[new_y][new_x])
	{
		case '.':
		{
			warehouse_2[new_y][new_x] = warehouse_2[cur_y][cur_x]
			warehouse_2[cur_y][cur_x] = '.'
			break
		}
		case '[':
		case ']':
		{
			local half_y = new_y;
			local half_x = new_x + (warehouse_2[new_y][new_x]=='[' ? 1 : -1);

			if(mov_y!=0)
			{
				PerformMove(half_y,half_x,mov_y,mov_x,moved_cache)
			}
			PerformMove(new_y,new_x,mov_y,mov_x,moved_cache)

			warehouse_2[new_y][new_x] = warehouse_2[cur_y][cur_x]
			warehouse_2[cur_y][cur_x] = '.'
			break
		}
	}
	if(update_cache)
	{
		delete box_hashmap_2[cur_y + "," + cur_x]
		box_hashmap_2[new_y + "," + new_x] <- [new_y,new_x]
	}
}

foreach(move in robot_moves)
{
	local vec_y = 0;
	local vec_x = 0;
	switch(move)
	{
		case '<': {vec_x--; break;}
		case '^': {vec_y--; break;}
		case '>': {vec_x++; break;}
		case 'v': {vec_y++; break;}
	}
	local y = current_position_2[0]
	local x = current_position_2[1]
	if(CanMove(y,x,vec_y,vec_x,true))
	{
		local move_cache = {}
		PerformMove(y,x,vec_y,vec_x,move_cache)
		current_position_2 = [y+vec_y,x+vec_x]
	}
}
foreach(box in box_hashmap_2)
{
	p2_value += 100*(box[0]) + box[1]
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)