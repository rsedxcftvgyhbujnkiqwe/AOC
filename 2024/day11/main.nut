dofile("../lib/stdlib.nut")
/*

SQUIRREL CANT HANDLE BIG NUMBERS
HAHAHAHAHA I WASTED 4 HOURS ON THIS STUPID SHIT DEBUGGING

*/
local p1_value = 0
local p2_value = 0

local stone_array = []

local fileblob = file("input/input.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n" || char == " ")
		{
			stone_array.append([text.tointeger(),0])
			text = ""
		}
		else
		{
			text += char
		}
	}
	fileblob.close();
}
else
	throw false

function split_multiply(number,odd_count)
{
	local multiplier = pow(2024,odd_count)
	local target_length = floor(log10(number) + log10(multiplier)+1)/2
	local factor = pow(10,ceil(intlen(number)/2))
	local left_half = (floor(number/factor)) * multiplier
	local right_half = (number % factor) * multiplier

	local left_len = intlen(left_half)
	local left_factor = pow(10,left_len - target_length)
	local left_final = floor(left_half/left_factor)
	local left_remainder = left_half % left_factor

	local right_init = right_half+(left_remainder*(factor))
	local right_factor = pow(10,target_length)
	local right_final = right_init % right_factor
	local right_remainder = floor(right_init/right_factor)
	left_final += right_remainder
	local fuck_this = number*multiplier
	return [left_final,right_final]
}

function PerformBlinks(stones,blink_count)
{
	for(local j=0;j<blink_count;j++)
	{
		local stone_num = stones.len()
		for(local i=0;i<stone_num;i++)
		{
			if(stones[i][0]==0) {stones[i][0] = 1; continue}
			local length = stones[i][1] > 0 ? (floor(log10(stones[i][0]) + log10(pow(2024,stones[i][1]))+1)) : intlen(stones[i][0])
			if(length%2 != 0) {stones[i][1]++; continue}
			local halves = split_multiply(stones[i][0],stones[i][1])
			stones[i][0] = halves[1]
			stones[i][1] = 0
			stones.insert(i,[halves[0],0])
			stone_num++
			i++
		}
	}
}

PerformBlinks(stone_array,25)

p1_value = stone_array.len()
printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)