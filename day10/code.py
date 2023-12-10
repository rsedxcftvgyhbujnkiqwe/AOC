with open("input/input","r") as f:
    data = f.read()

lines = data.split("\n")[:-1]

top = [-1,0,"F7|"]
right = [0,1,"J7-"]
down = [1,0,"JL|"]
left = [0,-1,"FL-"]

letter_checks = {
    "7":[down,left],
    "F":[right,down],
    "J":[top,left],
    "L":[top,right],
    "-":[right,left],
    "|":[top,down],
    "S":[top,right,down,left]
}



max_lines = len(lines)-1
max_len = len(lines[0])-1

def find_next_path(previous,current):
    current_letter = lines[current[0]][current[1]]
    checks = letter_checks[current_letter]
    next_point = [-1,-1]
    found_check = [-1,-1]
    for check in checks:
        check_pos = [current[0] + check[0],current[1]+check[1]]
        if check_pos[0] < 0 or check_pos[0] > max_lines or check_pos[1] < 0 or check_pos[1] > max_len:
            continue
        check_letter = lines[check_pos[0]][check_pos[1]]
        if check_letter != "." and check_pos != previous and (check_letter in check[2] or check_letter == "S"): 
            next_point = check_pos
            found_check = check
            break
    return current,next_point,found_check[0:2]

def generate_path(starting_point):
    path = [starting_point]
    path_dirs = [[[-1,-1],[-1,-1]]]
    previous = [-1,-1]
    current = starting_point
    previous,current,came_from = find_next_path(previous,current)
    count = 1
    while current != starting_point:
        path.append(current)
        path_dirs.append([[came_from[0]*-1,came_from[1]*-1],[-1,-1]])
        path_dirs[count-1][1] = came_from
        previous,current,came_from = find_next_path(previous,current)
        count += 1
    return path,path_dirs

def visualize_path(path):
    for i in range(len(lines)):
        for j in range(len(lines[i])):
            pval = "."
            if [i,j] not in path:
                pval = "X"
            print(pval,end="")
        print("")

linelen = len(lines[0])
s_pos = [-1,-1]
for i in range(len(lines)):
    for j in range(linelen):
        if lines[i][j] == "S":
            s_pos = [i,j]
            break
    if s_pos != [-1,-1]:
        break 
path,path_dirs = generate_path(s_pos)

#fixup last 2
final_dir = [path[-1][0] - path[0][0],path[-1][1] - path[0][1]]
path_dirs[0][0] = final_dir
path_dirs[-1][1] = [final_dir[0]*-1,final_dir[1]*-1]

def part1():
    total_steps = len(path)
    return total_steps//2 + (total_steps % 2 > 0)
print(part1())

p2_upscale = []
for i in range(len(lines)*3):
    p2_upscale.append([])
    for j in range(len(lines[0])*3):
        p2_upscale[i].append(".")

max_lines_up = len(lines)*3 -1
max_len_up = len(lines[0])*3 - 1


def flood_fill(coords):
    filled = []
    for coord in coords:
        for direction in [top,right,down,left]:
            check_pos = [direction[0] + coord[0], direction[1] + coord[1]]
            if check_pos[0] < 0 or check_pos[0] > max_lines_up or check_pos[1] < 0 or check_pos[1] > max_len_up:
                continue
            check_letter = p2_upscale[check_pos[0]][check_pos[1]]
            if check_letter == ".":
                p2_upscale[check_pos[0]][check_pos[1]] = "O"
                filled.append(check_pos)
    return filled

def part2():
    for i in range(len(path)):
        up_coord = [path[i][0]*3 + 1,path[i][1]*3 + 1]
        p2_upscale[up_coord[0]][up_coord[1]] = "_"
        for j in range(2):
            p2_upscale[up_coord[0] + path_dirs[i][j][0]][up_coord[1] + path_dirs[i][j][1]] = "_"
    to_fill = flood_fill([[0,0]])
    while to_fill != []:
        to_fill = flood_fill(to_fill)
    count = 0
    for i in range(len(lines)):
        for j in range(len(lines[0])):
            if p2_upscale[i*3 + 1][j*3 + 1] == ".":
                count += 1
    return count
print(part2())
