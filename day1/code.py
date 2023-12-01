import time
start = time.time()

# with open("input","r") as f:
#     data = f.readlines()
with open("biginput","r") as f:
    data = f.readlines()

num_vals = {
    "one":"1",
    "two":"2",
    "three":"3",
    "four":"4",
    "five":"5",
    "six":"6",
    "seven":"7",
    "eight":"8",
    "nine":"9"
}

numbers = [
    "1","2","3","4","5","6","7","8","9","one","two","three","four","five","six","seven","eight","nine"
]

def get_number(line):
    min = 100
    minv = ""
    max = 0
    maxv = ""
    for num in numbers:
        pos = 0
        while True:
            pos = line.find(num,pos)
            if pos == -1:
                break
            if pos <= min:
                min = pos
                minv = num
            if pos >= max:
                max = pos
                maxv = num
            pos +=1
    first_num = num_vals[minv] if minv in num_vals else minv
    second_num = num_vals[maxv] if maxv in num_vals else maxv

    return int(first_num + second_num)

final = list(map(get_number,data))
print(sum(final))

print(time.time() - start)