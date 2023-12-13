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

@lru_cache(maxsize=None)
def is_valid_grp(group,nums,need,end):
    glen = len(group)
    if glen > len(nums): return False
    for j in range(glen-1):
        if group[j] != nums[j]: return False
    if group[glen-1] > nums[glen-1]: return False
    if end and group[-1] != nums[-1]: return False
    return True

def is_valid_group(springs,grouping):
    gidx = 0
    idx = 0
    cg = 0
    while idx < len(springs) and gidx < len(grouping):
        if springs[idx] == "#":
            cg += 1
            if cg > grouping[gidx]: return False
        elif springs[idx] != "#" and cg > 0:
            gidx += 1
            cg = 0
#        print(cg,idx,gidx)
        idx += 1
    return True


@lru_cache(maxsize=None)
def safe_slice(tup,left=None,right=None):
    return tup[slice(left,right)]

def generate_combinations(spring_string,num_list):
    print(spring_string)
    print(num_list)
    q_index = [i for i,val in enumerate(spring_string) if val == "?"]
    h_index = [i for i,val in enumerate(spring_string) if val == "#"]
    ind_len = len(q_index)
    needed = sum(num_list) - len(h_index)
    spring_string = tuple(spring_string)
    def recurse_combinations(depth,c_ind,prev_ind,springs,count):
        for ind in range(prev_ind+c_ind,ind_len-needed+depth+1):
            mod_springs = safe_slice(springs,None,q_index[ind]) + ("#",) + safe_slice(spring_string,q_index[ind]+1,None)
#            print(mod_springs)
            if is_valid_group(mod_springs,num_list):
                print("Valid  ",mod_springs)
                count += 1
            else:
                print("Invalid",mod_springs)
                continue
            if depth < needed-1:
                count = recurse_combinations(depth+1,ind,prev_ind+1,mod_springs,count)
        return count
    return recurse_combinations(0,0,0,spring_string,0)

def test(data):
    rows = [x.rstrip().split(" ") for x in data]
    rows = [[x[0],[int(y) for y in x[1].split(",")]] for x in rows]
    for row in rows:
        generate_combinations(row[0],row[1])
    return 0
print(test(data))
