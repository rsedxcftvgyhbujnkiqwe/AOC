import math

with open("input/input","r") as f:
    data = f.read()


def part1(data):
    
    lines =  data.split("\n")
    instructions = lines[0]
    lsplit = {x[0:3]:[x[7:10],x[12:15]] for x in lines[2:-1]}
    
    instr_list = []
    for i in instructions:
        instr_list.append(0 if i == "L" else 1)
    
    instr_len = len(instr_list)

    current = "AAA"
    steps = 0
    while current != "ZZZ":
        current = lsplit[current][instr_list[steps % instr_len]]
        steps += 1
    return steps

def part2(data):
    lines = data.split("\n")
    lsplit = {x[0:3]:[x[7:10],x[12:15]] for x in lines[2:-1]}

    instructions = lines[0]
    instr_list = []
    for i in instructions:
        instr_list.append(0 if i == "L" else 1)
    starting_points = [x for x in lsplit if x[2]=="A"]
    instr_len = len(instr_list)
    steps = []
    for i,start in enumerate(starting_points):
        steps.append(0)
        while start[2] != "Z": 
            start = lsplit[start][instr_list[steps[i] % instr_len]]
            steps[i] += 1

    return math.lcm(*steps)
print(part2(data))
