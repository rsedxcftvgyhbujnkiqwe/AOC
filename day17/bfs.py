import heapq
with open("input/ex","r") as f:
    data = f.read().rstrip().split("\n")

for line in data:
    print(line)

graph = {}

max_height = len(data)-1
max_width = len(data[0])-1

def get_valid_neighbors(point):
    neighbors = {}
    if point[0] > 0: 
        neighbors[(point[0]-1,point[1])] = int(data[point[0]-1][point[1]])
    if point[1] > 0:
        neighbors[(point[0],point[1]-1)] = int(data[point[0]][point[1]-1])
    if point[0] < max_height:
        neighbors[(point[0]+1,point[1])] = int(data[point[0]+1][point[1]])
    if point[1] < max_width:
        neighbors[(point[0],point[1]+1)] = int(data[point[0]][point[1]+1])
    return neighbors


for i, row, in enumerate(data):
    for j, val in enumerate(row):
        graph[(i,j)] = get_valid_neighbors((i,j))


print(graph)

def node_diff(n1,n2):
    return (n1[0]-n2[0],n1[1]-n2[1])

def fourth_in_line(n1,path):
    if len(path) < 5: return False
    n2 = path[-1]
    n3 = path[-2]
    n4 = path[-3]
    n5 = path[-4]
    n1d = node_diff(n1,n2)
    n2d = node_diff(n2,n3)
    n3d = node_diff(n3,n4) 
    n4d = node_diff(n4,n5)
    if n1d == n2d == n3d == n4d: return True 
    return False

def BFS(graph,start,end):
    queue = []
    explored = []
    queue.append([start,0,[start]])
    ending_points = []
    while queue:
        cur_node,dist,path = queue.pop(0)
        explored.append(cur_node)
        for neighbor,neighbor_dist in graph[cur_node].items():
            if neighbor in path: continue
            if fourth_in_line(neighbor,path): continue
            new_path = list(path)
            new_path.append(neighbor)
            queue.append([neighbor,dist+neighbor_dist,new_path])
            if neighbor == end:
                ending_points.append([dist+neighbor_dist,new_path])
    print(explored)
    return ending_points

possibilities = BFS(graph,(0,0),(max_height,max_width))

for possibility in possibilities:
    print(possibility[0])

    dlines = [list(x) for x in data]
    for point in possibility[1]:
        dlines[point[0]][point[1]] = "."
    for line in dlines:
        print(''.join(line))
