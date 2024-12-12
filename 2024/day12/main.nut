dofile("../lib/stdlib.nut")

local p1_value = 0
local p2_value = 0

local garden = []

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local count1 = 0
	local count2 = 0
	local garden_row = array(0)
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			garden.append(garden_row)
			garden_row = array(0)
		}
		else
		{
			garden_row.append(char)
		}
	}
	fileblob.close();
}
else
	throw false


local garden_len = garden[0].len()
local garden_height = garden.len()

local garden_areas = {}
local garden_edges = {}
local garden_edge_dirs = {}

local garden_regions = []

local processed_plots = []

local directions = [[0,-1],[-1,0],[0,1],[1,0]]
local direction_map = {}
local dc = 0
foreach(direction in directions)
{
	local index = direction[0] * 1 + direction[1] * 2
	direction_map[index] <- dc++
}

function InBounds(y,x)
{
	return (y >= 0 && y < garden_height && x >= 0 && x < garden_len)
}

function ProcessGardenPlot(y,x,region,unique_edges,edge_dirs)
{
	local current_type = garden[y][x]
	local current_key = y + "," + x
	region.append(current_key)
	local free_sides = 4
	foreach(direction in directions)
	{
		local next_y = y + direction[0]
		local next_x = x + direction[1]
		if (InBounds(next_y,next_x))
		{
			local next_type = garden[next_y][next_x]
			local next_key = next_y + "," + next_x
			if(next_type!=current_type)
			{
				unique_edges.append(current_key)
				edge_dirs.append(direction_map[direction[0] * 1 + direction[1] * 2])
				continue
			}
			free_sides--
			if (region.find(next_key)!=null) continue
			free_sides += ProcessGardenPlot(next_y,next_x,region,unique_edges,edge_dirs)
		}
		else
		{
			unique_edges.append(current_key)
			edge_dirs.append(direction_map[direction[0] * 1 + direction[1] * 2])
		}
	}
	return free_sides
}

//naive solution
for(local y = 0; y < garden_height; y++)
{
	for(local x = 0; x < garden_len; x++)
	{
		local plot_key = y + "," + x
		if (processed_plots.find(plot_key)!=null) continue
		local region = array(0)
		local edge_plots = array(0)
		local edge_dirs = array(0)
		local free_sides = ProcessGardenPlot(y,x,region,edge_plots,edge_dirs)
		local area = region.len()
		local price = area * free_sides
		p1_value += price
		processed_plots.extend(region)
		garden_regions.append(region)
		garden_areas[plot_key] <- area
		garden_edges[plot_key] <- edge_plots
		garden_edge_dirs[plot_key] <- edge_dirs
	}
}

//better one
local processed_plots_2 = []
local palvadis_start_cache = []
function PalvidisProcess(y,x,boundary,starting_pixel,start,direction,type)
{
	boundary.append([y,x])
	local turns = 0
	while(turns<4)
	{
		turns++
		local dir_vector = directions[direction]
		local next_y = y + dir_vector[0]
		local next_x = x + dir_vector[1]
		if(!InBounds(next_y,next_x))
		{
			palvadis_start_cache.append(y + "," + x + "," + direction)
			direction = (direction + 1) % 4
			continue
		}
		local next_type = garden[next_y][next_x]
		if (next_type == type)
		{
			local new_direction = (direction + 3) % 4
			if(!starting_pixel)
			{
				if (next_y == start[0] && next_x == start[1]) {
					local dir_vector = directions[new_direction]
					local fs_y = next_y + dir_vector[0]
					local fs_x = next_x + dir_vector[1]
					if(!InBounds(fs_y,fs_x) || garden[fs_y][fs_x]!=type)
					{
						palvadis_start_cache.append(next_y + "," + next_x + "," + new_direction)
						break
					}
				}
			}
			PalvidisProcess(next_y,next_x,boundary,false,start,new_direction,type)
			break
		}
		else
		{
			palvadis_start_cache.append(y + "," + x + "," + direction)
		}
		direction = (direction + 1) % 4
	}
}

function PlotSurrounded(y,x)
{
	local type = garden[y][x]
	local count = 0
	foreach(direction in directions)
	{
		local next_y = y + direction[0]
		local next_x = x + direction[1]
		if(!InBounds(next_y,next_x)) continue
		if (type == garden[next_y][next_x]) count++
	}
	return count == 4
}

function GetBoundarySides(boundary)
{
	if(boundary.len() == 1) return 4
	local sides = 0
	local bound_len = boundary.len()

	//starting direction
	local last_dir = [boundary[0][0] - boundary[bound_len-1][0],boundary[0][1] - boundary[bound_len-1][1]]
	boundary.append(boundary[0])
	for(local i=0;i<bound_len;i++)
	{
		local dir_y = boundary[i+1][0] - boundary[i][0]
		local dir_x = boundary[i+1][1] - boundary[i][1]
		if(dir_y != last_dir[0] || dir_x != last_dir[1])
		{
			local last_index = last_dir[0] * 1 + last_dir[1] * 2
			local cur_index = dir_y * 1 + dir_x * 2
			last_dir = [dir_y,dir_x]
			local turned = (direction_map[cur_index] - direction_map[last_index]+4)%4
			sides += ((turned+1) % 2) + 1
		}
	}
	boundary.pop()
	return sides
}

for(local y = 0; y < garden_height; y++)
{
	for(local x = 0; x < garden_len; x++)
	{
		local plot_key = y  + "," + x
		if (processed_plots_2.find(plot_key)!=null) continue
		if (PlotSurrounded(y,x)) continue
		local total_sides = 0
		local processed = []
		local eplots = garden_edges[plot_key]
		local edirs = garden_edge_dirs[plot_key]
		for(local i = 0;i<eplots.len();i++)
		{
			local p = split(eplots[i],",")
			local y = p[0].tointeger()
			local x = p[1].tointeger()
			local edge_key = y + "," + x
			if(palvadis_start_cache.find(edge_key + "," + edirs[i])!=null) continue
			local bound = array(0)
			PalvidisProcess(y,x,bound,true,[y,x],edirs[i],garden[y][x])
			foreach(plot in bound)
			{
				processed_plots_2.append(plot[0] + "," + plot[1])
				processed.append(plot[0] + "," + plot[1])
			}
			local sides = GetBoundarySides(bound)
			total_sides += sides
		}
		local test = garden[y][x]
		local area = garden_areas[plot_key]
		p2_value += total_sides * area
	}
}


printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)