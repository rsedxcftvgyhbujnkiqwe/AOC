dofile("../lib/stdlib.nut")
local start_time = time()
local p1_value = 0
local p2_value = 0

local obstacle_rows = array(0)
local obstacle_cols = array(0)
local guard_position = array(0)
local safe_coords = array(0)

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local col = 0
	local row = 0
	local current_row = array(0)
	local gen_cols = true
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			obstacle_rows.append(current_row)
			current_row = array(0)
			row++
			col = 0
			gen_cols = false
			continue
		}
		else
		{
			if(gen_cols) obstacle_cols.append(array(0))
			if (char=="#")
			{
				current_row.append(col)
				obstacle_cols[col].append(row)
			}
			else if (char == "^")
			{
				guard_position = [row,col]
			}
			else
			{
				safe_coords.append([row,col])
			}
			col++
		}
	}
	fileblob.close();
}
else
	throw false

//for safe keeping
local init_guard_row = guard_position[0]
local init_guard_col = guard_position[1]

UP <- 0
RIGHT <- 1
DOWN <- 2
LEFT <- 3

function progress_guard(dir,position)
{
	local row = position[0]
	local col = position[1]
	local closest_obj = -1
	switch(dir)
	{
		case UP:
		{
			foreach(obstacle in obstacle_cols[col])
			{
				if(obstacle > row) break
				closest_obj = obstacle
			}
			if(closest_obj==-1) return -1
			else return row - closest_obj - 1
		}
		case RIGHT:
		{
			foreach(obstacle in obstacle_rows[row])
			{
				if(obstacle > col) {
					closest_obj = obstacle
					break
				}
			}
			if(closest_obj==-1) return -1
			else return closest_obj - col - 1
		}
		case DOWN:
		{
			foreach(obstacle in obstacle_cols[col])
			{
				if(obstacle > row)
				{
					closest_obj = obstacle
					break
				}
			}
			if(closest_obj==-1) return -1
			else return closest_obj - row - 1
		}
		case LEFT:
		{
			foreach(obstacle in obstacle_rows[row])
			{
				if(obstacle > col) break
				closest_obj = obstacle
			}
			if(closest_obj==-1) return -1
			else return col - closest_obj - 1
		}
	}
}

local dir = UP
local unique_coords = array(0)
local num_rows = obstacle_rows.len()
local num_cols = obstacle_cols.len()
local left_grid = false
local full_path = [[guard_position[0],guard_position[1],dir]]
while(!left_grid)
{
	local distance = progress_guard(dir,guard_position)
	if(distance == -1)
	{
		switch(dir)
		{
			case UP: { distance = guard_position[0]; break}
			case RIGHT: { distance = num_cols - guard_position[1] - 1; break}
			case DOWN: { distance = num_rows - guard_position[0] - 1; break}
			case LEFT: { distance = guard_position[1]; break}
		}
		left_grid = true
	}
	local iter_row = 0
	local iter_col = 0
	switch(dir)
	{
		case UP: { iter_row = -1; break}
		case RIGHT: { iter_col = 1; break}
		case DOWN: { iter_row = 1; break}
		case LEFT: { iter_col = -1; break}
	}
	for(local i = 0; i < distance; i++)
	{
		guard_position[0] += iter_row
		guard_position[1] += iter_col
		local coord_string = guard_position[0] + "," + guard_position[1]
		if(unique_coords.find(coord_string)==null) unique_coords.append(coord_string)
		full_path.append([guard_position[0],guard_position[1],dir])
	}
	dir = (++dir)%4
}

p1_value = unique_coords.len()

function PrintGraph()
{
	for(local i = 0; i < obstacle_rows.len();i++)
	{
		local rowstring = ""
		for(local j=0; j < obstacle_cols.len();j++)
		{
			if (obstacle_rows[i].find(j)==null) rowstring += "."
			else rowstring += "#"
		}
		printl(rowstring)
	}
}

function CheckInfiniteLoop(path_index)
{
	local g_row = init_guard_row
	local g_col = init_guard_col
	local g_dir = UP
	local g_string = g_row + "," + g_col + "," + g_dir

	local obs = full_path[path_index]
	local o_row = obs[0]
	local o_col = obs[1]
	local o_string = o_row + "," + o_col
	local start_position = [g_row,g_col,g_dir]
	local g_position = [g_row,g_col]

	//construct our obstacle arrays, insert into the right place
	local col_ind = 0
	for(local i=0;i<obstacle_rows[o_row].len();i++)
	{
		if(obstacle_rows[o_row][i] > o_col) break
		col_ind++
	}
	obstacle_rows[o_row].insert(col_ind,o_col)

	local row_ind = 0
	for(local i=0;i<obstacle_cols[o_col].len();i++)
	{
		if(obstacle_cols[o_col][i] > o_row) break
		row_ind++
	}
	obstacle_cols[o_col].insert(row_ind,o_row)

	local left_grid = false
	local inf_loop = false
	local dir = g_dir
	local c = 0
	local corners = [g_string]
	while(!left_grid && !inf_loop)
	{
		local distance = progress_guard(dir,g_position)
		if(distance == -1)
		{
			switch(dir)
			{
				case UP: { distance = g_position[0]; break}
				case RIGHT: { distance = num_cols - g_position[1] - 1; break}
				case DOWN: { distance = num_rows - g_position[0] - 1; break}
				case LEFT: { distance = g_position[1]; break}
			}
			left_grid = true
		}
		local iter_row = 0
		local iter_col = 0
		switch(dir)
		{
			case UP: { iter_row = -1; break}
			case RIGHT: { iter_col = 1; break}
			case DOWN: { iter_row = 1; break}
			case LEFT: { iter_col = -1; break}
		}
		g_position[0] += iter_row * distance
		g_position[1] += iter_col * distance

		local c_string = g_position[0] + "," + g_position[1] + "," + dir

		if(corners.find(c_string))
		{
			inf_loop = true;
			break
		}
		corners.append(c_string)
		dir = (++dir)%4
	}
	obstacle_rows[o_row].remove(col_ind)
	obstacle_cols[o_col].remove(row_ind)

	return inf_loop
}

local unique_blockers = []

for(local i = 1; i < full_path.len();i++)
{
	if(CheckInfiniteLoop(i))
	{
		local b_string = full_path[i][0] + "," + full_path[i][1]
		if(unique_blockers.find(b_string)==null) unique_blockers.append(b_string)
	}
}

p2_value = unique_blockers.len()

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)
printl("Run time: " + (time() - start_time) + "s")