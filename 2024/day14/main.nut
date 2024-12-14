dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local robots = []

//local glen = 11
//local gheight = 7
local glen = 101
local gheight = 103
local steps = 100

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local robot_cfg = []
	local current_cfg = []
	local text = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		switch(char)
		{
			case "\n":
			{
				current_cfg.append(text.tointeger())
				robot_cfg.append(current_cfg)
				robots.append(robot_cfg)
				robot_cfg = array(0)
				current_cfg = array(0)
				text = ""
				break
			}
			case ",":
			{
				current_cfg.append(text.tointeger())
				text = ""
				break
			}
			case " ":
			{
				current_cfg.append(text.tointeger())
				robot_cfg.append(current_cfg)
				current_cfg = array(0)
				text = ""
				break
			}
			case "-":
			case "0":
			case "1":
			case "2":
			case "3":
			case "4":
			case "5":
			case "6":
			case "7":
			case "8":
			case "9":
			{
				text += char
				break
			}
		}
	}
	fileblob.close();
}
else
	throw false

local grid_0 = 0
local grid_1 = 0
local grid_2 = 0
local grid_3 = 0

local len_mid = glen/2
local height_mid = gheight/2

foreach(robot in robots)
{
	local x = robot[0][0]
	local y = robot[0][1]
	local vx = robot[1][0]
	local vy = robot[1][1]

	local final_x = (steps*(glen + vx) + x) % glen
	local final_y = (steps*(gheight + vy) + y) % gheight
	//printl("Robot " + x + "," + y + " " + vx + "," + vy + " final pos: " + final_x + "," + final_y)
	if (final_x < len_mid)
	{
		if (final_y < height_mid)
		{
			grid_0++
		}
		else if (final_y > height_mid)
		{
			grid_1++
		}
	}
	else if (final_x > len_mid)
	{
		if (final_y < height_mid)
		{
			grid_2++
		}
		else if (final_y > height_mid)
		{
			grid_3++
		}

	}
}

p1_value = grid_0 * grid_1 * grid_2 * grid_3

//part 2 lolololol wtf
local i = 0
while(true)
{
	local coord_hashmap = {}
	local success = true
	foreach(robot in robots)
	{
		local x = robot[0][0]
		local y = robot[0][1]
		local vx = robot[1][0]
		local vy = robot[1][1]

		local final_x = (i*(glen + vx) + x) % glen
		local final_y = (i*(gheight + vy) + y) % gheight
		local coordstring = final_x + "," + final_y
		if (!(coordstring in coord_hashmap)) coord_hashmap[coordstring] <- 1
		else
		{
			success = false
			break
		}
	}
	if(success)
	{
		p2_value = i
		break
	}
	i++
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)