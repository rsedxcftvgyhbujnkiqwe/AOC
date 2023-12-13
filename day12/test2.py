import re
import itertools
from math import factorial as fac
from math import sqrt
from time import time
from functools import lru_cache
with open("input/input","r") as f:
    data = f.readlines()

@lru_cache
def C(x,y):
    return fac(x)/(fac(y)*fac(x-y))

@lru_cache
def get_grouping(group):
    tup = ()
    count = 0
    for char in group:
        if char == "." and count > 0:
            tup += (count,)
            count = 0
        elif char == "#":
            count += 1
    if count > 0:
        tup += (count,)
    return tup

@lru_cache
def is_valid_grp(group,nums,need,end):
    glen = len(group)
    if glen > len(nums): return False
    for j in range(glen-1):
        if group[j] != nums[j]: return False
    if group[glen-1] > nums[glen-1]: return False
    if end and group[-1] != nums[-1]: return False
    return True

def generate_combos2(comp_string,q_index,needed,nums):
    nums = tuple(nums)
    valid_combos = []
    comb_to_run = list(itertools.combinations(q_index,needed))
    i = 0
    nrange = range(needed)
    count = 0
    while i < len(comb_to_run):
        cur = i
        test_val = list(comp_string)
        for index in nrange:
            test_val[comb_to_run[i][index]] = "#"
            grp = get_grouping(tuple(test_val[0:comb_to_run[i][index]+1]))
            if not is_valid_grp(grp,nums,needed,False):
                for j in range(i,len(comb_to_run)):
                    if comb_to_run[j][index] != comb_to_run[i][index]:
                        i = j-1
                        break
                break
        if is_valid_grp(get_grouping(tuple(test_val)),nums,needed,True):
            valid_combos.append(comb_to_run[cur])
        i+=1
        count += 1
    print(f"Valid combos: {len(valid_combos)}")
    return valid_combos

def generate_combos():
    :q

    return

def test(data):
    total = 0
    lcount = 0
    for line in data[:]:
        nums = [int(x) for x in line.rstrip().split(" ")[1].split(",")]
        line = list(line.rstrip().split(" ")[0])
        print("\n")
        print(line)
        print(nums)
        q_index = [x for x,val in enumerate(line) if val == "?"]
        h_index = [x for x,val in enumerate(line) if val == "#"]
        print("q index",q_index)
        needed = sum(nums) - len(h_index)
        if needed == 0:
            continue

        comp_string = (''.join(line)).replace("?",".")
        valid_combos = generate_combos(comp_string,q_index,needed,nums)

        combototal = set([i for sub in valid_combos for i in sub])

        invalid_nums = []
        for q in q_index:
            if q not in combototal:
                invalid_nums.append(q)
        print("Invalid numbers",invalid_nums)

        new_line = '#'.join([''.join(line)]*2)
        ncomp_string = new_line.replace("?",".")
        nq_index = q_index + [x+len(line)+1 for x in q_index]
        nq_index = [x for x in nq_index if x not in invalid_nums]
        print("nq index",nq_index)
        nnums = nums*2
        nneeded = needed*2 - 1
        nvalid_combos = generate_combos(ncomp_string,nq_index,nneeded,nnums)

        lvc = len(valid_combos)
        lnvc = len(nvalid_combos) + lvc**2
        lcount += 1
        print(f"Iterated through {lcount} lines out of {len(data)}")

        additional_combinations = len(nvalid_combos)
        if additional_combinations == 0:
            total += len(valid_combos)**5
            continue
        total_combos = int(sqrt((lnvc**8)/(lvc**6)))
        total += total_combos
        print(f"Total combos: {total_combos}\n")


    return total
print(test(data))
