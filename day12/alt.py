import re
with open("input/ex","r") as f:
    data = f.readlines()

def get_spring_groups(springs):
    groups = [[[],[]]]
    prev = ""
    for spring in springs:
        if prev == "" or prev == ".":
            groups.append([[],[]])


def part2(data):
    for line in data:
        nums = line.rstrip().split(" ")[1].split(",")*5
        line = '?'.join([line.rstrip().split(" ")[0]]*5)




    return
print(part2(data))