import heapq

with open("input/input","r") as f:
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

def fourth_in_line(n1,n2,previous):
    n3 = previous[n2]
    if not n3: return False
    n4 = previous[n3]
    if not n4: return False
    n5 = previous[n4]
    if not n5: return False
    n1d = node_diff(n1,n2)
    n2d = node_diff(n2,n3)
    n3d = node_diff(n3,n4) 
    n4d = node_diff(n4,n5)
    if n1d == n2d == n3d == n4d: return True 
    return False

def dijkstra(graph, start, end):
    distances = {node: float('infinity') for node in graph}
    distances[start] = 0
    previous = {node: None for node in graph}
    priority_queue = [(0,start)]

    while priority_queue:
        cur_distance, cur_node = heapq.heappop(priority_queue)
        if cur_node == end:
            break
        for neighbor,neighbor_dist in graph[cur_node].items():
            if fourth_in_line(neighbor,cur_node,previous): continue
            total_dist = cur_distance + neighbor_dist
            if total_dist < distances[neighbor]:
                distances[neighbor] = total_dist
                previous[neighbor] = cur_node
                heapq.heappush(priority_queue,(total_dist,neighbor))
    return distances,previous

dij_distances, dij_previous = dijkstra(graph,(0,0,),(max_height,max_width))
print("Calculated dijkstra")
print(dij_distances)
node_path = [(max_height,max_width)]
prev = dij_previous[node_path[0]]
while prev:
    node_path.append(prev)
    prev = dij_previous[prev]

dlines = [list(x) for x in data]

for node in node_path:
    dlines[node[0]][node[1]] = "."

for line in dlines:
    print(''.join(line))
print(dij_distances[(max_height,max_width)])
