import heapq
with open("input/input","r") as f:
    data = f.read().rstrip().split("\n")


graph = {}

max_height = len(data)-1
max_width = len(data[0])-1

fork_nodes = [(0,1),(max_height,max_width-1)]

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
        if val != "#":
            graph[(i,j)] = get_valid_neighbors((i,j))
            if len(graph[(i,j)]) > 2:
                fork_nodes.append((i,j))

print("Fork nodes",fork_nodes)

better_graph = {}

for node in fork_nodes:
    better_graph[node] = {}
    for neighbor in graph[node]:
        steps = 0
        visited = [node,neighbor]
        cur_node = neighbor
        while cur_node not in fork_nodes:
            steps += 1
            for n_node in graph[cur_node]:
                if n_node not in visited:
                    visited.append(n_node)
                    cur_node = n_node
                    break
        if cur_node in better_graph[node] and steps < better_graph[node][cur_node]: continue
        better_graph[node][cur_node] = steps
print("New graph",better_graph)

def dijkstra(graph,start,end):
    queue = [(0,start,[start])]
    largest = 0
    solution = []
    while queue:
        distance,cur_node,path = heapq.heappop(queue)
        for neighbor,neighbor_dist in graph[cur_node].items():
            if neighbor in path: continue
            total_dist = distance - neighbor_dist
            new_path = list(path)
            new_path.append(neighbor)
            print(new_path)
            if neighbor == end:
                if total_dist < largest:
                    largest = total_dist
                    solution = new_path
                continue
            heapq.heappush(queue,(total_dist,neighbor,new_path))
    return largest,solution

answer = dijkstra(better_graph,(0,1),(max_height,max_width-1))
print(answer[0] - len(answer[1]) + 1)
print(answer[1])
