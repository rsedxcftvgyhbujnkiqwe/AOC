with open("input/input","r") as f:
    data = f.readlines()

def seq_dif(input_list):
    return [input_list[i+1]-input_list[i] for i in range(len(input_list)-1)]

def abs_sum(input_list):
    return sum(abs(number) for number in input_list)

def part1(data):
    total = 0
    data = [x.rstrip().split(" ") for x in data]
    for line in data:
        line_set = [[int(x) for x in line]]
        cur_line = line_set[0]
        while abs_sum(cur_line) != 0:
            cur_line = seq_dif(cur_line)
            line_set.append(cur_line)
        for i in range(len(line_set)-1,0,-1):
            line_set[i-1].append(line_set[i-1][-1] + line_set[i][-1])
        total += line_set[0][-1]
    return total


print(part1(data))


def part2(data):
    total = 0
    data = [x.rstrip().split(" ") for x in data]
    for line in data:
        line_set = [[int(x) for x in line]]
        cur_line = line_set[0]
        while abs_sum(cur_line) != 0:
            cur_line = seq_dif(cur_line)
            line_set.append(cur_line)
        for i in range(len(line_set)-1,0,-1):
            line_set[i-1].insert(0,line_set[i-1][0] - line_set[i][0])
        print(line_set)
        total += line_set[0][0]
    return total


print(part2(data))

