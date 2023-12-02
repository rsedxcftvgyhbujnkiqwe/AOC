with open("input/input","r") as f:
    data = f.readlines()

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

print(pow)    