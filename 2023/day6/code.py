import math
with open("input/input","r") as f:
    data = f.readlines()

def solve_race(time,distance):
    quadratic_sqrt =  math.sqrt(time**2 - (4*(distance+1)))
    lower_bound = math.ceil((time - quadratic_sqrt)/2)
    upper_bound = math.floor((time + quadratic_sqrt)/2)
    return upper_bound - lower_bound + 1

def part1(data):
    times = data[0].rstrip().split(" ")[1:]
    times = [int(x) for x in times if x.isnumeric()]

    distances = data[1].rstrip().split(" ")[1:]
    distances = [int(x) for x in distances if x.isnumeric()]
    total = 1
    for i in range(len(times)):
        total *= solve_race(times[i],distances[i])

    return total
print(part1(data))

def part2(data):
    times = data[0].rstrip().split(" ")[1:]
    time = int(''.join([x for x in times if x.isnumeric()]))

    distances = data[1].rstrip().split(" ")[1:]
    distance = int(''.join([x for x in distances if x.isnumeric()]))

    return solve_race(time,distance)
print(part2(data))
