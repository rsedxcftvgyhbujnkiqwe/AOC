from functools import lru_cache
with open("input/input","r") as f:
    data = f.readlines()


def get_count(springs,groups):
    @lru_cache
    def iter(i,j):
        if j >= len(groups):
            return "#" not in springs[i:] 
        if i + groups[j] > len(springs):
            return 0
        char = springs[i]
        ways = 0
        if char == ".":
            ways += iter(i+1,j)
        else:
            if char == "?":
                ways += iter(i+1,j)
            
            springs_to_place = groups[j]
            
            built_str = "#"*springs_to_place + "."
            valid = True
            for ind in range(springs_to_place+1):
                if springs[ind+i] != "?" and built_str[ind] != springs[ind+i]:
                    valid = False
                    break
            if valid:
                ways += iter(i+springs_to_place+1,j+1)
        return ways

    return iter(0,0)
def solve(data):
    total1 = 0
    total2 = 0 
    rows = [x.rstrip().split(" ") for x in data]
    rows = [[x[0],[int(y) for y in x[1].split(",")]] for x in rows]
    for row in rows[:]:
        total1 += get_count(row[0]+".",row[1])
        total2 += get_count('?'.join([row[0]]*5)+".",row[1]*5)
    return total1,total2
print(solve(data))
