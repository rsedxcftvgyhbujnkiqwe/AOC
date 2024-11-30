import heapq
with open("input/input","r") as f:
    data = f.read().rstrip().split("\n")


graph = {}

max_height = len(data)-1
max_width = len(data[0])-1

def get_valid_neighbors(point):
    neighbors = []
    if point[0] > 0 and data[point[0]-1][point[1]] != "#" and data[point[0]][point[1]] not in "<>v":
        neighbors.append((point[0]-1,point[1]))
    if point[1] > 0 and data[point[0]][point[1]-1] != "#" and data[point[0]][point[1]] not in ">^v":
        neighbors.append((point[0],point[1]-1))
    if point[0] < max_height and data[point[0]+1][point[1]] != "#" and data[point[0]][point[1]] not in "<>^":
        neighbors.append((point[0]+1,point[1]))
    if point[1] < max_width and data[point[0]][point[1]+1] != "#" and data[point[0]][point[1]] not in "<v^":
        neighbors.append((point[0],point[1]+1))
    return neighbors

for i, row in enumerate(data):
    for j, val in enumerate(row):
        if val != "#":
            graph[(i,j)] = get_valid_neighbors((i,j))

def bfs(graph,start,end):
    
    queue = []
    heapq.heappush(queue,[0,start,[start]])
    longest_path = []
    while queue:
        steps,cur_node,path = heapq.heappop(queue)
        for neighbor in graph[cur_node]:
            if neighbor in path: continue
            new_path = list(path)
            new_path.append(neighbor)
            if neighbor == end:
                longest_path = new_path
                continue
            heapq.heappush(queue,[steps + 1, neighbor, new_path])
    return longest_path
    
answer = bfs(graph,(0,1),(max_height,max_width-1))

print(answer)
print(len(answer)-1)
