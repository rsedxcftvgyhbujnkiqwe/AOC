dofile("../lib/stdlib.nut")
local starttime = clock()

local p1_value = 0
local p2_value = 0

local data_file = "input"
// local data_file = "smallboy"

local initial_values = {}

local processed_values = {}

local operations = {}

::AND <- 0
::OR <- 1
::XOR <- 2

local z_values = {}

local fileblob = file("input/"+data_file+".txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	local key = ""
	local i = 0;
	for (i; i < size; i++) {
		local char = blobData[i].tochar();
		if(char == "\n")
		{
			if(text=="") break
			processed_values[key] <- text.tointeger()
			initial_values[key] <- text.tointeger()
			text = ""
			key = ""
		}
		else if(char == " ")
		{
			text = ""
		}
		else if(char == ":")
		{
			key = text
			text = ""
		}
		else
		{
			text += char
		}
	}
	text = ""
	local val1 = ""
	local op = ""
	local val2 = ""
	for (++i; i < size; i++) {
		local char = blobData[i].tochar();
		if(char == "\n")
		{
			local result = text
			operations[result] <- {v1=val1,v2=val2}
			switch(op)
			{
				case "XOR": {operations[result].op<-XOR;break}
				case "AND": {operations[result].op<-AND;break}
				case "OR": {operations[result].op<-OR;break}
			}
			if(result[0]=='z') z_values[result] <- 0
			val1 = ""
			op = ""
			val2 = ""
			text = ""
		}
		else if (char == " ")
		{
			if (val1=="") val1 = text
			else if (op=="") op = text
			else if (val2=="") val2 = text
			text = ""
		}
		else if (char == "-" || char == ">") {}
		else
		{
			text += char
		}
	}
	fileblob.close();
}
else
	throw false

function ProcessRegister(register)
{
	if(register in processed_values) return processed_values[register]
	local operation = operations[register]
	local v1 = operation.v1
	local v2 = operation.v2
	local op = operation.op
	if(!(v1 in processed_values)) ProcessRegister(v1)
	if(!(v2 in processed_values)) ProcessRegister(v2)
	local return_value = 0
	switch(op)
	{
		case XOR:
		{
			return_value = processed_values[v1] ^ processed_values[v2]
			break
		}
		case AND:
		{
			return_value = processed_values[v1] & processed_values[v2]
			break
		}
		case OR:
		{
			return_value = processed_values[v1] | processed_values[v2]
			break
		}
	}
	processed_values[register] <- return_value
	return return_value
}

function CalculateZ()
{
	processed_values = clone initial_values
	local result = 0
	foreach(z_val,_ in z_values)
	{
		local value = ProcessRegister(z_val)
		local z_bit_num = z_val.slice(1).tointeger()
		result += value << z_bit_num
	}
	return result
}

p1_value = CalculateZ()

/* Part 2
*/
function PrintRelationTree(register,depth,printed={})
{
	if(depth==5) return
	if(register in initial_values) return
	local operation = operations[register]
	local v1 = operation.v1
	local v2 = operation.v2
	local op = operation.op
	printl(multstr(depth*2," ") + register + ": " + v1 + " " + (op == 0 ? "AND" : (op == 1 ? "OR" : "XOR")) + " " + v2)
	PrintRelationTree(v1,depth+1)
	PrintRelationTree(v2,depth+1)
}


function SwapWires(wire1,wire2)
{

	local w1 = clone operations[wire1]
	local w2 = clone operations["z05"]
	operations[wire1] <- w2
	operations[wire2] <- w1
}

SwapWires("tst","z05")
SwapWires("sps","z11")
SwapWires("frt","z23")
SwapWires("cgh","pmd")

local x = 0
local y = 0
foreach(key,val in initial_values)
{
	local bit_num = key.slice(1).tointeger()
	if(key[0]=='x') x += val << bit_num
	else y += val << bit_num
}
local current = CalculateZ()
local target = x + y
local target_bits = IntToBinary(target)

while(current!=target)
{
	local cur_bits = IntToBinary(current)
	local i=cur_bits.len()-1
	for(i;i>-1;i--)
	{
		if(cur_bits[i]!=target_bits[i]) break
	}
	local bit_pos = cur_bits.len() - 1 -  i
	printl("Incongruity found at position " + bit_pos)
	break
}
/*
*/

//found by hand using commented prints above
local p2_values = ["tst","z05","sps","z11","frt","z23","cgh","pmd"]
p2_values.sort(@(a,b) a<=>b)
p2_value = p2_values[0]
for(local i=1;i<p2_values.len();i++) p2_value += "," + p2_values[i]

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)
printl("Took " + (clock() - starttime) + "s")