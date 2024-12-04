dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local fileblob = file("input/input.txt", "rb");
local grid = array(0);
local x_values = array(0);
local a_values = array(0);
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local line = array(0)
	local count1 = 0
	local count2 = 0
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			if (line.len() > 0) grid.append(line)
			line = array(0)
			count1++
			count2 = 0
		}
		else
		{
			line.append(char)
			if (char=="X") x_values.append([count1,count2])
			if (char=="A") a_values.append([count1,count2])
			count2++
		}
	}
	fileblob.close();
}
else
	throw false

local grid_len = grid[0].len()
local grid_height = grid.len()

local min_x_len = 3
local max_x_len = grid_len - 4
local min_x_height = 3
local max_x_height = grid_height - 4

UP_LEFT <- 0
LEFT <- 3
DOWN_LEFT <- 5
UP <- 1
UP_RIGHT <- 2
RIGHT <- 4
DOWN_RIGHT <- 7
DOWN <- 6

function validate_xmas(y,x,direction)
{
	switch(direction)
	{
		case UP_LEFT: if(grid[y-1][x-1]=="M" && grid[y-2][x-2]=="A" && grid[y-3][x-3]=="S") return true; break;
		case LEFT: if(grid[y][x-1]=="M" && grid[y][x-2]=="A" && grid[y][x-3]=="S") return true; break;
		case DOWN_LEFT: if(grid[y+1][x-1]=="M" && grid[y+2][x-2]=="A" && grid[y+3][x-3]=="S") return true; break;
		case UP: if(grid[y-1][x]=="M" && grid[y-2][x]=="A" && grid[y-3][x]=="S") return true; break;
		case UP_RIGHT: if(grid[y-1][x+1]=="M" && grid[y-2][x+2]=="A" && grid[y-3][x+3]=="S") return true; break;
		case RIGHT: if(grid[y][x+1]=="M" && grid[y][x+2]=="A" && grid[y][x+3]=="S") return true; break;
		case DOWN_RIGHT: if(grid[y+1][x+1]=="M" && grid[y+2][x+2]=="A" && grid[y+3][x+3]=="S") return true; break;
		case DOWN: if(grid[y+1][x]=="M" && grid[y+2][x]=="A" && grid[y+3][x]=="S") return true; break;
	}
	return false
}

foreach(x_coord in x_values)
{
	local left = false
	local right = false
	local up = false
	local down = false
	local y = x_coord[0]
	local x = x_coord[1]
	if(x >= min_x_len) left = true
	if(x <= max_x_len) right = true
	if(y >= min_x_height) up = true
	if(y <= max_x_height) down = true
	if(left)
	{
		if(validate_xmas(y,x,LEFT)) p1_value++
		if(up && validate_xmas(y,x,UP_LEFT)) p1_value++
		if(down && validate_xmas(y,x,DOWN_LEFT)) p1_value++
	}
	if(up && validate_xmas(y,x,UP)) p1_value++
	if(right)
	{
		if(validate_xmas(y,x,RIGHT)) p1_value++
		if(up && validate_xmas(y,x,UP_RIGHT)) p1_value++
		if(down && validate_xmas(y,x,DOWN_RIGHT)) p1_value++
	}
	if(down && validate_xmas(y,x,DOWN)) p1_value++
}

local min_a_len = 1
local max_a_len = grid_len - 2
local min_a_height = 1
local max_a_height = grid_height - 2

function validate_x_mas(y,x)
{
	local m = 0
	local s = 0
	local l = 0
	local r = 0
	local u = 0
	local d = 0
	switch(grid[y-1][x-1])
	{
		case "M": m++;l++;u++; break;
		case "S": s++;l--;u--; break;
	}
	switch(grid[y+1][x+1])
	{
		case "M": m++;r++;d++; break;
		case "S": s++;r--;d--; break;
	}
	switch(grid[y+1][x-1])
	{
		case "M": m++;l++;d++; break
		case "S": s++;l--;d--; break
	}
	switch(grid[y-1][x+1])
	{
		case "M": m++;r++;u++; break
		case "S": s++;r--;u--; break
	}
	return (m==2)&&(s==2) && ((l==2||l==-2)||(r==2||r==-2)||(u==2||u==-2)||(d==2||d==-2))
}

foreach(a_coord in a_values)
{
	local y = a_coord[0]
	local x = a_coord[1]
	if (y >= min_a_height && y <= max_a_height && x >= min_a_len && x <= max_a_len)
	{
		if(validate_x_mas(y,x)) p2_value++
	}
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)