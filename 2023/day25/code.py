with open("input/input","r") as f:
    data = f.read().rstrip().split("\n")

wire_graph = {}

for line in data:
    wire = line[:3]
    connections = line[5:].split(" ")
    if wire in wire_graph:
        wire_graph[wire] += connections
    else:
        wire_graph[wire] = connections
    for connection in connections:
        if connection in wire_graph:
            wire_graph[connection] += [wire]
        else:
            wire_graph[connection] = [wire]

print(wire_graph)


def stoer_wagner(graph):
    vertices = list(graph.keys())
    subset = set([vertices[0]])
    subset_neighbors = set(graph[vertices[0]])
    
    max_size = len(vertices)
    vertices = set(vertices[1:])
    while vertices:
        neighbors = []
        total_weight = 0
        for neighbor in subset_neighbors:
            neighbor_weight = 0
            for connection in graph[neighbor]:
                if connection in subset:
                    neighbor_weight += 1
            neighbors.append([neighbor_weight,neighbor])
            total_weight += neighbor_weight
        neighbors = sorted(neighbors)
        if total_weight == 3:
            return len(vertices) *  len(subset)
            #connections = []
            #for _,neighbor in neighbors:
            #    connections.append([neighbor] + [x for x in graph[neighbor] if x in subset])
            #return connections

        stiffest = neighbors[-1][1]
        subset.add(stiffest)
        subset_neighbors.remove(stiffest)
        subset_neighbors.update([x for x in graph[stiffest] if x not in subset])
        vertices.remove(stiffest)
    return False

solution = stoer_wagner(wire_graph)
print(solution)
