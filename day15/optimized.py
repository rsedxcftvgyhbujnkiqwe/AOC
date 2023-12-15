import time
from functools import lru_cache
with open("input/biginput","r") as f:
    data = f.read().rstrip().split(",")

@lru_cache
def get_string_value(string):
    value = 0
    for character in string:
        value = get_value(value,character)
    return value

@lru_cache
def get_value(current_value,character):
    return ((current_value+ord(character))*17)%256

def part1(data):
    total = 0
    for val in data:
        total += get_string_value(val)
    return total

print(part1(data))

def box_sum(box_index,box):
    run = []
    total = 0
    skip = 0
    for i,slot in enumerate(box):
        if slot[0] in run:
            skip += 1
            continue
        total += (box_index+1) * (i+1-skip) * slot[1]
        run.append(slot[0])
    return total

def part2(data):
    total = 0
    boxes = [[] for _ in range(256)]
    ignore_label = []
    max_vals = {}
    for val in data[::-1]:
        if val[-1] == "-":
            label = val[:-1]
            if label not in ignore_label:
                ignore_label.append(label)
        else:
            label = val[:-2]
        if label in ignore_label:
            continue
        lens = val[-1]
        box = get_string_value(label)
        if label not in max_vals:
            max_vals[label] = int(lens)
        boxes[box].insert(0,[label,int(lens)])
        boxes[box][0][1] = max_vals[label]
    total = sum([box_sum(i,box) for i,box in enumerate(boxes)])
    return total
p3s = time.time()
print(part2(data),time.time()-p3s)
