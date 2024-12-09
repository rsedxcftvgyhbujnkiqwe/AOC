dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

//p1
local block_array = array(0)
local empty_array = array(0)
//p2
local block_array_2 = array(0)
local block_size = array(0)
local empty_size = array(0)

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local data = true
	local pos = 0
	local id_store = -1
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char!="\n")
		{
			local value = char.tointeger()

			local id = id_store

			if(!data) {
				id = -1
				empty_size.append([pos,value])
			}
			else {
				if(value > 0)
				{
					id_store++
					id++
					block_size.append([pos,value,id])
				}
				else block_size.append([pos,0,-1])
			}
			for(local j = 0; j < value; j++)
			{
				block_array.append(id)
				if(!data) empty_array.append(pos+j)
			}
			data = !data
			pos += value
		}
	}
	fileblob.close();
}
else
	throw false

block_array_2 = clone block_array

//p1
local block_len = 0
for(local i=block_array.len()-1;i>=0;i--)
{
	if(empty_array.len()==0 || empty_array[0] > i) {block_len = i+1; break}
	local empty_index = empty_array[0]

	local val = block_array[i]
	if(val == -1) continue

	block_array[empty_index] = val
	empty_array.remove(0)
}
for(local i=0;i<block_len;i++)
{
	p1_value += block_array[i] * i
}

//p2
empty_size.append([0,0])
for(local i=block_size.len()-1;i>=0;i--)
{
	local b_pos = block_size[i][0]
	local b_len = block_size[i][1]
	local b_id = block_size[i][2]
	if(b_len==0) continue
	local moved = false
	local moved_index = 0
	for(local j=0;j<empty_size.len();j++)
	{
		local e_pos = empty_size[j][0]
		local e_len = empty_size[j][1]
		if (e_pos > b_pos) break
		if (b_len > e_len) continue
		for(local k=0;k < b_len;k++)
		{
			block_array_2[e_pos+k] = b_id
			block_array_2[b_pos+k] = -1
		}
		moved = true
		moved_index = j
		break
	}
	if(moved)
	{
		if(empty_size[moved_index][1] == b_len)
		{
			empty_size.remove(moved_index)
		}
		else{
			empty_size[moved_index][0] += b_len
			empty_size[moved_index][1] -= b_len
		}
	}
}
for(local i=0;i<block_array_2.len();i++)
{
	if(block_array_2[i]!=-1) p2_value += block_array_2[i] * i
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)