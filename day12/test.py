import re
import itertools
from math import factorial as fac
from math import sqrt
from time import time
from functools import lru_cache
with open("input/ex","r") as f:
    data = f.readlines()

@lru_cache
def C(x,y):
    return fac(x)/(fac(y)*fac(x-y))

@lru_cache
def list_comp(vals,nums):
    v = ()
    for val in vals:
        v += (len(val),)
    if v == nums: return True
    return False

@lru_cache
def is_valid_cache(springs,nums):
    vals = re.findall(r"#+",springs)
    return list_comp(tuple(vals),nums)

def generate_combos(comp_string,q_index,needed,nums):
    valid_combos = []
    comb_to_run = list(itertools.combinations(q_index,needed))
    print(f"Iterating over {len(comb_to_run)} combos")
    for combo in comb_to_run:
        test_val = list(comp_string)
        for s in combo:
            test_val[s] = "#"
        if is_valid_cache(''.join(test_val),tuple(nums)):
            valid_combos.append(combo)
    print(f"Valid combos: {len(valid_combos)}")
    return valid_combos

def test(data):
    total = 0
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
        invalid_nums += [x+len(line)+1 for x in invalid_nums]
        print("Invalid numbers",invalid_nums)

        new_line = '#'.join([''.join(line)]*2)
        ncomp_string = new_line.replace("?",".")
        nq_index = q_index + [x+len(line)+1 for x in q_index]
        print("nq index",nq_index)
        nnums = nums*2
        nneeded = needed*2 - 1
        nvalid_combos = generate_combos(ncomp_string,nq_index,nneeded,nnums)

        lvc = len(valid_combos)
        lnvc = len(nvalid_combos) + lvc**2

        additional_combinations = len(nvalid_combos)
        if additional_combinations == 0:
            total += len(valid_combos)**5
            continue
        total_combos = int(sqrt((lnvc**8)/(lvc**6)))
        total += total_combos
        print(f"Total combos: {total_combos}\n")


    return total
print(test(data))