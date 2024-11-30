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
    elif point[0] == 0 and data[max_height][point[1]] != "#":
        neighbors.append((max_height,point[1]))

    if point[1] > 0 and data[point[0]][point[1]-1] != "#":
        neighbors.append((point[0],point[1]-1))
    elif point[1] == 0 and data[point[0]][max_width] != "#":
        neighbors.append((point[0],max_width))

    if point[0] < max_height and data[point[0]+1][point[1]] != "#":
        neighbors.append((point[0]+1,point[1]))
    elif point[0] == max_height and data[0][point[1]] != "#":
        neighbors.append((0,point[1]))

    if point[1] < max_width and data[point[0]][point[1]+1] != "#":
        neighbors.append((point[0],point[1]+1))
    elif point[1] == max_width and data[point[0]][max_width] != "#":
        neighbors.append((point[0],max_width))
    return neighbors

for i, row in enumerate(data):
    for j, val in enumerate(row):
        if val == "." or val == "S":
            valid_nodes.append((i,j))
            neighbors[(i,j)] = get_valid_neighbors((i,j))
        if val == "S":
            start_node = (i,j)
#print(neighbors)

def get_neighbor_nodes(nodes):
    total_neighbors = {}
    for node,occurances in nodes.items():
        for neighbor in neighbors[node]:
            if neighbor in total_neighbors:
                total_neighbors[neighbor] += occurances
            else:
                total_neighbors[neighbor] = occurances
    return total_neighbors

for i in range(1,5):

    nodes = {start_node:1}
    for _ in range(i):
        nodes = get_neighbor_nodes(nodes)
    
    print(i,nodes)
