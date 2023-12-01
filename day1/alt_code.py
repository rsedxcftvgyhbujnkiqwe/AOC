import time
import re
start = time.time()
# with open("input","r") as f:
#     data = f.read()
with open("biginput","r") as f:
    data = f.read()

data = data.replace("one","o1e").replace("two","t2o").replace("three","t3e").replace("four","f4r").replace("five","f5e").replace("six","s6x").replace("seven","s7n").replace("eight","e8t").replace("nine","n9e").rstrip()

data = data.split("\n")

set1 = map(lambda x: re.search(r"\d",x)[0],data)
set2 = map(lambda x: re.findall(r"\d",x)[-1],data)

final = [int(x + y) for x,y in zip(set1,set2)]

print(sum(final))

print(time.time() - start)