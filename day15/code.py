with open("input/input","r") as f:
    data = f.read().rstrip().split(",")

def get_string_value(string):
    value = 0
    for character in string:
        value = get_value(value,character)
    return value

def get_value(current_value,character):
    return ((current_value+ord(character))*17)%256

def part1(data):
    total = 0
    for val in data:
        total += get_string_value(val)
    return total

print(part1(data))

memo = {}
def get_box(label):
    if label in memo:
        return memo[label]
    else:
        return get_string_value(label)

def part2(data):
    total = 0
    boxes = [[] for _ in range(256)]
    for val in data[:]:
        if val[-1] == "-":
            label = val[:-1]
            add = False
        else:
            label = val[:-2]
            add = True
        lens = val[-1]
        box = get_box(label)
        lens_index = -1
        if len(boxes[box]) != 0:
            for i,val in enumerate(boxes[box]):
                if val[0] == label:
                    lens_index = i
                    break
        if add:
            if lens_index > -1:
                boxes[box][lens_index][1] = int(lens)
            else:
                boxes[box].append([label,int(lens)])
        else:
            if lens_index > -1:
                boxes[box].pop(lens_index)
    total = sum([sum([(i+1)*(j+1)*slot[1] for j,slot in enumerate(box)]) for i,box in enumerate(boxes)])
    return total
print(part2(data))
