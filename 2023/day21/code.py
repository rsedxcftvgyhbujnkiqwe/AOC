with open("input/input","r") as f:
    data = f.read().rstrip().split("\n")


start_node = (-1,-1)

valid_nodes = []

neighbors = {}

max_height = len(data)-1
max_width = len(data[0])-1

def get_valid_neighbors(point):
    neighbors = []
    if point[0] > 0 and data[point[0]-1][point[1]] != "#":
        neighbors.append((point[0]-1,point[1]))
    if point[1] > 0 and data[point[0]][point[1]-1] != "#":
        neighbors.append((point[0],point[1]-1))
    if point[0] < max_height and data[point[0]+1][point[1]] != "#":
        neighbors.append((point[0]+1,point[1]))
    if point[1] < max_width and data[point[0]][point[1]+1] != "#":
        neighbors.append((point[0],point[1]+1))
    return neighbors

for i, row in enumerate(data):
    for j, val in enumerate(row):
        if val == "." or val == "S":
            valid_nodes.append((i,j))
            neighbors[(i,j)] = get_valid_neighbors((i,j))
        if val == "S":
            start_node = (i,j)
print(neighbors)

def get_neighbor_nodes(nodes):
    cur_neighbors = []
    for node in nodes:
        cur_neighbors += neighbors[node]
    return list(set(cur_neighbors))

for i in range(1,65):

    nodes = [start_node]
    for _ in range(i):
        nodes = get_neighbor_nodes(nodes)
    
    print(i,len(nodes))
