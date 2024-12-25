dofile("../lib/stdlib.nut")
local starttime = clock()

local p1_value = 0
local p2_value = 0

local data_file = "input"
// local data_file = "smallboy"

local keys = {}
local locks = {}

local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local block_data = [0,0,0,0,0]
	local count = 0;
	local count2 = 0;
	local lock = true
	for (local i = 0; i < size; i++) {
		local char = blobData[i];
		if (char=='\n')
		{
			if(count2==7)
			{
				local out = locks
				if(!lock) out = keys
				for(local i=0;i<5;i++)
				{
					local c = block_data[i] - 1
					if(!(c in out)) out[c] <- {}
					out = out[c]
				}
				block_data = [0,0,0,0,0]
				lock = true
				count2=0
			}
			else
			{
				count2++
			}
			count=0
		}
		else
		{
			if(char=='#') block_data[count]++
			else if (count2==0) lock = false
			count++
		}
	}
	fileblob.close();
}
else
	throw false

function VerifyKeyValue(keys,locks,keystore=[],lockstore=[])
{
	if(keys.len()==0)
	{
		return 1
	}
	local count = 0
	foreach(k,v in keys)
	{
		for(local j=0;j<6-k;j++)
		{
			keystore.append(k)
			lockstore.append(j)
			if(j in locks) count += VerifyKeyValue(v,locks[j],keystore,lockstore)
			keystore.pop()
			lockstore.pop()
		}
	}
	return count
}

p1_value = VerifyKeyValue(keys,locks)

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)
printl("Took " + (clock() - starttime) + "s")