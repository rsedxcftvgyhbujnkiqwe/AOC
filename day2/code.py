with open("input/input","r") as f:
    data = f.readlines()

def part1(data):
    ids = 0
    for i in range(len(data)):
        game = i+1
        sets = list(map(str.strip,map(str.rstrip,data[i].split(":")[1].split(";"))))
        possible = True
        npc = ""
        npv = 0
        for set in sets:
            red = 0
            green = 0
            blue = 0
            cubes = map(str.strip,set.split(","))
            for pull in cubes:
                vals = pull.split(" ")
                if vals[1] == "red" and int(vals[0]) > 12:
                    possible = False
                    npc = "red"
                    npv = int(vals[0])
                elif vals[1] == "blue" and int(vals[0]) > 14:
                    possible = False
                    npc = "blue"
                    npv = int(vals[0])
                elif vals[1] == "green" and int(vals[0]) > 13:
                    possible = False
                    npc = "green"
                    npv = int(vals[0])
        if possible:
            ids += game
    return ids

def part2(data):
    pow = 0
    for i in range(len(data)):
        game = i+1
        sets = list(map(str.strip,map(str.rstrip,data[i].split(":")[1].split(";"))))
        red = 0
        green = 0
        blue = 0
        for set in sets:
            cubes = map(str.strip,set.split(","))
            for pull in cubes:
                vals = pull.split(" ")
                value = int(vals[0])
                if vals[1] == "red":
                    if value > red:
                        red = value
                elif vals[1] == "blue":
                    if value > blue:
                        blue = value
                elif vals[1] == "green":
                    if value > green:
                        green = value
        pow += red * green * blue
    return pow


print(part1(data))
print(part2(data))