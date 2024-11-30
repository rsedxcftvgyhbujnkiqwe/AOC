import os
import heapq
with open("input/ex2","r") as f:
    data = f.read().rstrip().split("\n")

for line in data:
    print(line + line + "\n" + line + line)


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


#print(graph)

def node_diff(n1,n2):
    return (n1[0]-n2[0],n1[1]-n2[1])

def fourth_in_line(n1,path):
    if len(path) < 4: return False
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

def print_graph(path):
    dlines = [list(x) for x in data]
    for point in path:
        dlines[point[0]][point[1]] = "."
    for line in dlines:
        print(''.join(line))

def BFS(graph,start,end):
    queue = []
    heapq.heappush(queue,[0,0,start,[start]])
    ending_points = []
    distances = {node: float('infinity') for node in graph}
    distances[start] = 0
    total_steps = {node: -float('infinity') for node in graph}
    total_steps[start] = 0
    explored = {node: [(0,[(0,0)])] for node in graph}
    count = 0 
    while queue:
        dist,steps,cur_node,path = heapq.heappop(queue)
        count += 1
        for neighbor,neighbor_dist in graph[cur_node].items():
            in_path = neighbor in path
            is_fourth =  fourth_in_line(neighbor,path)
            total_dist = dist + neighbor_dist
            if in_path or is_fourth: continue
            if (total_dist,path[-4:]) in explored[neighbor]: continue
            if total_dist <= distances[neighbor] or steps > total_steps[neighbor]:
                new_path = list(path)
                new_path.append(neighbor)
                distances[neighbor] = total_dist
                total_steps[neighbor] = steps - 1
                heapq.heappush(queue,[total_dist,steps - 1, neighbor, new_path])
                explored[neighbor].append((total_dist,path[-4:]))
                if neighbor == end:
                    print("Total iterations",count)
                    return total_dist,new_path
    return -1,[]

answer = BFS(graph,(0,0),(max_height,max_width))
print_graph(answer[1])
print(answer[0])
