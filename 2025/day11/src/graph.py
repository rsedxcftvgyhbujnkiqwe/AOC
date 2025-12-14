# Used for determining which lines to cut in modified input data for gold
from pyvis.network import Network

with open("day11/input/input.txt") as f:
	data = f.read().rstrip().split("\n")

relations = {}

for line in data:
	key = line.split(":")[0]
	values = line.split(" ")[1:]
	relations[key] = values

net = Network(directed=True)

for key in relations.keys():
	net.add_node(key)

net.add_node("out")

for key,relationships in relations.items():
	for relation in relationships:
		net.add_edge(key,relation)

print(net)

net.show_buttons(filter_=['interaction'])
net.show("graph.html")
