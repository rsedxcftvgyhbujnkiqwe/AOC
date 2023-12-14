with open("input/input","r") as f:
    data =  f.read().rstrip().split("\n")


def count_grid(grid):
    total = 0
    row_vals = [x+1 for x in reversed(range(len(grid)))]
    for i,row in enumerate(grid):
        for j,val in enumerate(row):
            if val == "O":
                total += row_vals[i]
    return total

def shift_up(grid):
    top_rocks = [-1 for x in range(len(grid[0]))]
    for i,row in enumerate(grid):
        for j,val in enumerate(row):
            if val == "#":
                top_rocks[j] = i
            elif val == "O":
                grid[i][j] = "."
                grid[top_rocks[j]+1][j] = "O"
                top_rocks[j] += 1
    return grid

def rotate_grid(grid):
    return [ [*r][::-1] for r in zip(*grid) ]


def cycle(grid):
    grid = [[x for x in y] for y in grid]
    for _ in range(4):
        grid = shift_up(grid)
        grid = rotate_grid(grid)
    return grid

def part1(data):
    data = [list(x) for x in data]
    return count_grid(shift_up(data))

print(part1(data))

def to_line(grid):
    return [''.join([''.join(x) for x in grid])]

def part2(data):
    total = 0
    row_vals = [x+1 for x in reversed(range(len(data)))]
    data = [list(x) for x in data]
    grids = [data]
    grid_cache = [to_line(data)]
    target_num = 1000000000
    for i in range(target_num):
        cycled_grid = cycle(grids[-1])
        cycled_cache = to_line(cycled_grid)
        if cycled_cache in grid_cache:
            index = grid_cache.index(cycled_cache)
            return count_grid(grids[((target_num-index) % (i-index+1)) + index])
        grids.append(cycled_grid)
        grid_cache.append(cycled_cache)
print(part2(data))
