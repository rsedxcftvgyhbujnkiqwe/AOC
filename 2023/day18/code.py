from functools import lru_cache
with open("input/ex3","r") as f:
    data = f.read().rstrip().split("\n")

vertices = [(0,0)]
edge = 0
move_info = [x.split(" ") for x in data]
edge_points = []

for movement in move_info:
    direction = movement[0]
    magnitude = int(movement[1])
    
    if direction == "U":
        start_point = vertices[-1]
        end_point = (start_point[0]-magnitude,start_point[1])
        vertices.append(end_point)
        for i in range(magnitude-1):
            edge_points.append((start_point[0]-1-i,start_point[1]))
    elif direction == "D":
        start_point = vertices[-1]
        end_point = (start_point[0]+magnitude,start_point[1])
        vertices.append(end_point)
        for i in range(magnitude-1):
            edge_points.append((start_point[0]+1+i,start_point[1]))
    elif direction == "L":
        start_point = vertices[-1]
        end_point = (start_point[0],start_point[1]-magnitude)
        vertices.append(end_point)
        for i in range(magnitude-1):
            edge_points.append((start_point[0],start_point[1]-1-i))
    elif direction == "R":
        start_point = vertices[-1]
        end_point = (start_point[0],start_point[1]+magnitude)
        vertices.append(end_point)
        for i in range(magnitude-1):
            edge_points.append((start_point[0],start_point[1]+1+i))
x_vals = [x[1] for x in vertices]
y_vals = [x[0] for x in vertices]
xmin = min(x_vals)
xmax = max(x_vals)
ymin = min(y_vals)
ymax = max(y_vals)

@lru_cache
def raycast(point,dv,ignore):
    count = 0
    verts = 0
    next_point = (point[0]+dv[0],point[1]+dv[1])
    if next_point in edge_points and not ignore:
        count += 1
    elif next_point in vertices:
        ignore = not ignore
        verts += 1
    if next_point[0] > ymax or next_point[0] < ymin or next_point[1] > xmax or next_point[1] < xmin:
        return count,verts
    rv = raycast(next_point,dv,ignore)

    return count+rv[0],verts+rv[1]

print_graph = [list("."*(xmax-xmin+1)) for x in range(ymax-ymin+1)]
for point in vertices+edge_points:
    print_graph[point[0]][point[1]] = "#"

def printpoint(point):
    new_graph = [list(x) for x in print_graph]
    new_graph[point[0]][point[1]] = "@"
    for line in new_graph:
        print(''.join(line))


def part1(data):
    total = 0
    for y in range(ymin,ymax+1):
        for x in range(xmin,xmax+1):
            point = (y,x)
            if point in vertices or point in edge_points:
                continue
            val = 0
            u_in,u_v = raycast(point,(-1,0),False)
            u_in -= u_v > 0
            if u_in > 0:
                val += u_in % 2

            r_in,r_v = raycast(point,(0,1),False)
            r_in -= r_v > 0
            if r_in > 0:
                val += r_in % 2

            d_in,d_v = raycast(point,(1,0),False)
            d_in -= d_v > 0
            if d_in > 0:
                val += d_in % 2
            
            l_in,l_v = raycast(point,(0,-1),False)
            l_in -= l_v > 0
            if l_in > 0:
                val += l_in % 2
            if val > 0:
                total += 1
            printpoint(point)
            print("  ",u_in)
            print("",l_in,u_in+r_in+d_in+l_in,r_in)
            print("  ",d_in)
            print("Value:",val)
            print("\n")
    return (total,len(vertices + edge_points) - 1)
print(part1(data))
