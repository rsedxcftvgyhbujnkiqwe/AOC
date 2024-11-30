import time

with open("input/input","r") as f:
    data = f.readlines()

def print_galaxy(gal,maxrow,maxcol):
    gal_up = [x[:2] for x in gal]
    for i in range(maxrow):
        for j in range(maxcol):
            pv = ","
            if [i,j] in gal_up:
                pv = "#"
            print(pv,end="")
        print()

def generate_galaxy(input_data):
    galaxies = []
    galaxy_cols = []
    galaxy_rows = []
    count = 0
    for i in range(len(input_data)):
        for j in range(len(input_data[i])):
            if data[i][j] == "#":
                galaxies.append([i,j,count])
                galaxy_cols.append(j)
                galaxy_rows.append(i)
                count += 1
    
    galaxy_cols = sorted(set(galaxy_cols))
    galaxy_rows = sorted(set(galaxy_rows))
    
    max_cols = len(data)-1
    max_rows = len(data[0])
    
    empty_cols = []
    empty_rows = []

    for i in range(max_cols):
        if i not in galaxy_cols:
            empty_cols.append(i)
    for i in range(max_rows):
        if i not in galaxy_rows:
            empty_rows.append(i)
    return galaxies,empty_cols,empty_rows

def get_distance(point1,point2):
    xdist = abs(point2[0] - point1[0])
    ydist = abs(point2[1] - point1[1])
    return xdist + ydist

def expand_galaxy(gal,empty_cols,empty_rows,amount):
    exp_gal = sorted(gal,key=lambda x: x[1])
    skipped_cols = 0
    for i,galaxy in enumerate(exp_gal):
        if skipped_cols < len(empty_cols) and galaxy[1] > empty_cols[skipped_cols]:
            for j,val in enumerate(empty_cols):
                if val > galaxy[1]:
                    skipped_cols = j
                    break
                elif galaxy[1] > val and skipped_cols+1 == len(empty_cols):
                    skipped_cols += 1
                    break
        exp_gal[i][1] += skipped_cols*max(0,amount-1)
    new_cols = exp_gal[-1][1]

    exp_gal = sorted(exp_gal,key=lambda x: x[0])
    skipped_rows = 0
    for i,galaxy in enumerate(exp_gal):
        if skipped_rows < len(empty_rows) and galaxy[0] > empty_rows[skipped_rows]:
            for j,val in enumerate(empty_rows):
                if val > galaxy[0]:
                    skipped_rows = j
                    break
                elif galaxy[0] > val and skipped_rows+1 == len(empty_rows):
                    skipped_rows += 1
                    break
        exp_gal[i][0] += skipped_rows*max(0,amount-1)
    new_rows = exp_gal[-1][0]

    exp_gal = sorted(exp_gal,key=lambda x: x[2])
#    print_galaxy(exp_gal,new_rows+1,new_cols+1)
    return exp_gal

def part1(data):
    gal,empty_cols,empty_rows = generate_galaxy(data)
    exp_gal = expand_galaxy(gal,empty_cols,empty_rows,2)
    total = 0
    gal_len = len(exp_gal)
    for i,galaxy in enumerate(exp_gal[:-1]):
        for j in range(i+1,gal_len):
            dist = get_distance(galaxy,exp_gal[j])
            total += dist
    return total

def part2(data):
    gal,empty_cols,empty_rows = generate_galaxy(data)
    exp_gal = expand_galaxy(gal,empty_cols,empty_rows,1000000)
    total = 0
    gal_len = len(exp_gal)
    for i,galaxy in enumerate(exp_gal[:-1]):
        for j in range(i+1,gal_len):
            dist = get_distance(galaxy,exp_gal[j])
            total += dist

    return total

p1s = time.time()
print(f"Part1: {part1(data)} - {time.time()-p1s}")

p2s = time.time()
print(f"Part2: {part2(data)} - {time.time()-p2s}")
