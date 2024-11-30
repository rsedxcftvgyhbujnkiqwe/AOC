from time import time
with open("input/biginput","r") as f:
    data = f.read()

start1 = time()
def part1(data):
    sections = list(map(str.rstrip,data.split("\n\n")))
    seeds = [int(x) for x in sections[0].split(" ")[1:]]
    seed_conv_dict = {}
    for section in sections[1:]:
        sec_lines = section.split("\n")
        sec_type = sec_lines[0].split(" ")[0].split("-to-")
        seed_conv_dict[sec_type[1]] = []
        for line in sec_lines[1:]:
            conv_data = line.split(" ")
            drs = int(conv_data[0])
            srs = int(conv_data[1])
            r = int(conv_data[2])
            seed_conv_dict[sec_type[1]].append([drs-srs,srs,srs+r-1])
    conversions = ["seed","soil","fertilizer","water","light","temperature","humidity","location"]
    for conv_index in range(1,len(conversions)):
        dest = conversions[conv_index]
        conv_data = seed_conv_dict[dest]
        for seedindex in range(len(seeds)):
            seed = seeds[seedindex]
            for conv in conv_data:
                if seed >= conv[1] and seed <= conv[2]:
                    seed += conv[0]
                    break
            seeds[seedindex] = seed
    
    return min(seeds)

print(f"Part 1: {part1(data)} - {time() - start1}s")

start2 = time()
def part2(data):
    sections = list(map(str.rstrip,data.split("\n\n")))
    seeds = [int(x) for x in sections[0].split(" ")[1:]]
    seed_range = []
    for i in range(len(seeds)//2):
        s = i*2
        seed_range.append([seeds[s],seeds[s]+seeds[s+1]-1])
    seed_conv_dict = {}
    for section in sections[1:]:
        sec_lines = section.split("\n")
        sec_type = sec_lines[0].split(" ")[0].split("-to-")
        seed_conv_dict[sec_type[1]] = []
        for line in sec_lines[1:]:
            conv_data = line.split(" ")
            drs = int(conv_data[0])
            srs = int(conv_data[1])
            r = int(conv_data[2])
            seed_conv_dict[sec_type[1]].append([drs-srs,srs,srs+r-1])
    conversions = ["seed","soil","fertilizer","water","light","temperature","humidity","location"]
    for conv_index in range(1,len(conversions)):
        dest = conversions[conv_index]
        conv_data = seed_conv_dict[dest]
        count = 0
        for seed_data in seed_range:
            for conv in conv_data:
                if (seed_data[0] >= conv[1] and seed_data[0] <= conv[2]) or (seed_data[1] >= conv[1] and seed_data[1] <= conv[2]):
                    if seed_data[0] >= conv[1]:
                        start = seed_data[0]
                    else:
                        start = conv[1]
                    if seed_data[1] <= conv[2]:
                        end = seed_data[1]
                    else:
                        end = conv[2]

                    if start > seed_data[0]:
                        sliced = [seed_data[0],start-1]
                        seed_range.append(sliced)
                    if end < seed_data[1]:
                        sliced = [end+1,seed_data[1]]
                        seed_range.append(sliced)
                    final_range = [start+conv[0],end+conv[0]]
                    seed_range[count] = final_range
                    break
            count += 1
        count = 1
        for seed_data in seed_range:
            sd = seed_data
            count2 = count
            for seed_data_2 in seed_range[count:]:
                sd2 = seed_data_2
                if (sd[0] >= sd2[0]-1 and sd[0] <= sd2[1]+1) or (sd[1] <= sd2[1]+1 and sd[1] >= sd2[0]-1):
                    new = [min(sd[0],sd2[0]),max(sd[1],sd2[1])]
                    seed_range.pop(count2)
                    sd = new
                    seed_range[count-1] = new
                    count2 -= 1
                count2 += 1
            count +=1 
    low = [x[0] for x in seed_range]
    return min(low)
print(f"Part 2: {part2(data)} - {time() - start2}s")