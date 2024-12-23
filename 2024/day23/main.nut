dofile("../lib/stdlib.nut")
local starttime = clock()

local p1_value = 0
local p2_value = ""

local data_file = "input"
// local data_file = "smallboy"

local connections = {}

local pools = {}

local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local con1 = ""
	local text = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i].tochar();
		if (char=="\n")
		{
			connections[con1 + text] <- null
			connections[text + con1] <- null
			if(!(con1 in pools)) pools[con1] <- [text]
			else pools[con1].append(text)
			if(!(text in pools)) pools[text] <- [con1]
			else pools[text].append(con1)
			text = ""
			con1 = ""
		}
		else if (char == "-")
		{
			con1 = text
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

local data_groups = {}

local largest_size = 0
local largest_group = []

foreach(root,cons in pools)
{
	for(local i=0;i<cons.len()-1;i++)
	{
		local p1 = cons[i]
		local sub_cons = []
		for(local j=i+1;j<cons.len();j++)
		{
			local p2 = cons[j]
			if((p1+p2) in connections)
			{
				sub_cons.append(p2)
				local group = [root,p1,p2]
				group.sort(@(a,b) a<=>b)
				local key = group[0] + group[1] + group[2]
				if(!(key in data_groups))
				{
					local tf = (key[0]=='t') || (key[2]=='t')  || (key[4]=='t')
					data_groups[key] <- (tf)
					if(tf) p1_value++
				}
			}
		}
		for(local k=0;k<sub_cons.len()-1;k++)
		{
			local p3 = sub_cons[k]
			local safe=true
			for(local h=k+1;h<sub_cons.len();h++)
			{
				local p4 = sub_cons[h]
				if(!((p3 + p4) in connections))
				{
					safe=false
					break
				}
			}
			if(!safe)
			{
				sub_cons.remove(k)
				k--
			}
		}
		local len = sub_cons.len()
		if(len>largest_size)
		{
			largest_size = len
			largest_group = sub_cons.extend([root,p1])
		}
	}
}

largest_group.sort(@(a,b) a<=>b)
foreach(k in largest_group) p2_value += k + ","

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)
printl("Took " + (clock() - starttime) + "s")