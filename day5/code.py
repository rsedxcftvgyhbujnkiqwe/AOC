with open("input/input","r") as f:
    data = f.read()

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

print(part1(data))

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
            # range, source range start, source range end, dest range start, dest range end
            seed_conv_dict[sec_type[1]].append([drs-srs,srs,srs+r-1])
            if srs < drs:
                print(f"Negative conversion found: {line}. Created conv record {seed_conv_dict[sec_type[1]][-1]}")
    print(f"\nAvailable seed conversions:")
    for k in seed_conv_dict:
        print(f"{k}: {seed_conv_dict[k]}")
    conversions = ["seed","soil","fertilizer","water","light","temperature","humidity","location"]
    for conv_index in range(1,len(conversions)):
        print("\n=====\n")
        print(f"Preparing {conversions[conv_index-1]}-to-{conversions[conv_index]} conversion\n")
        print(f"Current seed data: {seed_range}")
        dest = conversions[conv_index]
        conv_data = seed_conv_dict[dest]
        count = 0
        for seed_data in seed_range:
            #seed_data: [start,end]
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
                        print(f"Appending {sliced} due to {seed_data} with conv {conv}")
                    if end < seed_data[1]:
                        sliced = [end+1,seed_data[1]]
                        seed_range.append(sliced)
                        print(f"Appending {sliced} due to {seed_data} with conv {conv}")
                    final_range = [start+conv[0],end+conv[0]]
                    seed_range[count] = final_range
                    if final_range[0] == 0:
                        print(f"Calculated start of 0 for {seed_data} with conv {conv}")
                    break
            count += 1

        print(f"\nUpdated seed data: {seed_range}")
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
        print(f"Consolidated seed data: {seed_range}")
    low = [x[0] for x in seed_range]
    return min(low)
print(part2(data))