import math
import functools

silver = 0
gold = 0

with open("input/input.txt","r") as f:
	data = list(map(int,f.read().rstrip().split(" ")))

def intlen(number):
	return math.floor(math.log10(abs(number))) + 1

cache = {}

@functools.cache
def blink_stone(stone):
	if(stone==0):
		return [1]
	digits = math.floor(math.log10(stone))+1
	if(digits%2==1):
		return [stone*2024]
	factor = 10**(digits//2)
	left = stone // factor
	right = stone % factor
	return [left,right]

def blink():
	global cache
	new_cache = {}
	for stone,count in cache.items():
		vals = blink_stone(stone)
		for val in vals:
			if val not in new_cache:
				 new_cache[val] = count
			else:
				new_cache[val] += count
	cache = new_cache

for value in data:
	if value not in cache:
		cache[value] = 1
	else:
		cache[value] += 1

for _ in range(75):
	blink()
	if _ == 24:
		print("Silver",sum(cache.values()))
print("Gold",sum(cache.values()))