with open("input/input","r") as f:
    data = f.readlines()

def contains_symbol(row,max_data_row,min_col,max_col,max_data_col):
    min_coord = [max(row-1,0),max(min_col-1,0)]
    max_coord = [min(row+1,max_data_row),min(max_col+1,max_data_col)]
    symbols = "!@#$%^&*()_+-=[]{}\\|;:\"\',<>/?`~"
    for i in range(min_coord[0],max_coord[0]+1):
        for j in range(min_coord[1],max_coord[1]+1):
            if data[i][j] in symbols:
                return True
    return False

def part1(data):
    total = 0
    max_row = len(data)-1
    for i in range(len(data)):
        max_col = len(data[i])-1
        j = 0
        start = 0
        end = 0
        while j <= max_col:
            if data[i][j].isnumeric():
               start = j
               for k in range(j,max_col):
                    if not data[i][k].isnumeric():
                        break
                    end = k
               if contains_symbol(i,max_row,start,end,max_col):
                    total += int(data[i][start:end+1])
               j = end + 1
            else:
                j += 1
    return total
print(part1(data))

def get_num_locations(data):
    locations = []
    for i in range(len(data)):
        j = 0
        start = 0
        end = 0
        max_col = len(data[i]) - 1
        while j <= max_col:
            if data[i][j].isnumeric():
                coords = []
                start = j
                for k in range(j,max_col):
                    if not data[i][k].isnumeric():
                        break
                    end = k
                    coords.append([i,k])
                locations.append([int(data[i][start:end+1]),coords])
                j = end + 1
            else:
                j += 1
    return locations

def part2(data):
    locations = get_num_locations(data)
    ast_coords = []
    total = 0
    for i in range(len(data)):
        for j in range(len(data)):
            if data[i][j] == "*":
                ast_coords.append([i,j])
    
    for coord in ast_coords:
        coords_to_check = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,0],[0,1],[1,-1],[1,0],[1,1]]
        coords_to_check = [[x[0] + coord[0],x[1] + coord[1]] for x in coords_to_check]
        found_locations = []
        for location in locations:
            for check in coords_to_check:
                if check in location[1] and location not in found_locations:
                    found_locations.append(location)
                    break
        
        if len(found_locations) == 2:
            total += found_locations[0][0] * found_locations[1][0]
    return total

print(part2(data))
