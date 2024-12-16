dofile("../lib/stdlib.nut")

function sample()
{
	return [1,2]
}

local test1,test2 = sample()
print(test1 + "," + test2)