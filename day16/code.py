from functools import lru_cache
with open("input/input","r") as f:
    data = f.read().rstrip().split("\n")

#directions:
#up = 0
#right = 1
#down = 2
#left= 3

split_chars = ["-","|","-","|"]
clockwise_mirrors = ["/","\\","/","\\"]
counterclockwise_mirrors = ["\\","/","\\","/"]
dir_arrow = ["^",">","v","<"]

grid_width = len(data[0])-1
grid_height = len(data)-1


def visualize_position(grid,point,direction):
    glines = [list(line) for line  in grid]
    glines[point[0]][point[1]] = dir_arrow[direction]
    for line in glines:
        print(''.join(line))

def visualize_positions(grid,points):
    glines = [list(line) for line in grid]
    for point in points:
        glines[point[0][0]][point[0][1]] = "#"
    for line in glines:
        print(''.join(line))
    
@lru_cache
def would_go_off_grid(position,direction):
    if direction == 0:
        return position[0] == 0
    elif direction == 1:
        return position[1] == grid_width
    elif direction == 2:
        return position[0] == grid_height
    elif direction == 3:
        return position[1] == 0
@lru_cache
def move_point(position,direction):
    if direction == 0:
        return (position[0]-1,position[1],)
    elif direction == 1:
        return (position[0],position[1]+1,)
    elif direction == 2:
        return (position[0]+1,position[1],)
    elif direction == 3:
        return (position[0],position[1]-1,)

memo = {}

def move_laser(grid,starting_point):
    
    energized_points = [starting_point]
    points_visited = []

    def iterate_beam(position,direction,energized_points):
        if (position,direction,) in memo:
            return memo[(position,direction,)]

        points = []
        while not would_go_off_grid(position,direction):
            new_pos = move_point(position,direction)
            grid_char = grid[new_pos[0]][new_pos[1]]
            new_dir = direction
            
            if grid_char == clockwise_mirrors[direction]:
                new_dir = (direction + 1) % 4
            elif grid_char == counterclockwise_mirrors[direction]:
                new_dir = (direction - 1) % 4
            elif grid_char == split_chars[direction]:
                new_dir = (direction + 1) % 4
            
            if (new_pos,new_dir,) in points_visited:
                return points
            
            points.append((new_pos,new_dir,))
            points_visited.append((new_pos,new_dir,))

            if grid_char == split_chars[direction]:
                points_visited.append((new_pos, (direction - 1) % 4,))
                points += iterate_beam(new_pos, (direction - 1) % 4,energized_points)
            
            position = new_pos
            direction = new_dir
        memo[(position,direction,)] = points
        return points

    return iterate_beam(starting_point[0],starting_point[1],energized_points)

def part1(data):
    energized_points = move_laser(data,((0,-1),1,))
    points_only = [x[0] for x in energized_points]
    return len(set(points_only))

print(part1(data))

def part2(data):
    top_points = [((-1,x,),2) for x in range(grid_width+1)]
    bottom_points = [((grid_height+1,x,),0) for x in range(grid_width+1)]
    left_points = [((x,-1,),1) for x in range(grid_height+1)]
    right_points = [((x,grid_width+1,),3) for x in range(grid_height+1)]
    points_to_iterate = top_points + bottom_points + left_points + right_points
    total_points = len(points_to_iterate) 
    top_score = 0
    count = 0
    for point in points_to_iterate:
        count += 1
        print("Running iteration",count,"/",total_points,end="\r")
        energized_points = move_laser(data,point)
        points_only = [x[0] for x in energized_points]
        unique_points = len(set(points_only))
        if unique_points > top_score:
            top_score = unique_points
    return top_score
print(part2(data))
