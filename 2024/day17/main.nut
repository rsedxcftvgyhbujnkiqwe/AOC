dofile("../lib/stdlib.nut")

local p1_value = ""
local p2_value = ""

local reg_A = null
local reg_B = null
local reg_C = null

local program = array(0)

local fileblob = file("input/smallboy.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	for (local i = 0; i < size; i++) {
		local char = blobData[i];
		if (char=='\n' || char==',')
		{
			if(text=="") continue
			if(reg_A==null) reg_A = text.tointeger()
			else if(reg_B==null) reg_B = text.tointeger()
			else if(reg_C==null) reg_C = text.tointeger()
			else program.append(text.tointeger())
			text = ""
		}
		else
		{
			if(IsCharNumeric(char))
			text += char.tochar()
		}
	}
	fileblob.close();
}
else
	throw false

function ProcessOperation(pointer,output_store)
{
	local opcode = program[pointer]
	local operand = program[pointer+1]
	switch(opcode)
	{
		case 0:
		case 2:
		case 5:
		case 6:
		case 7:
		{
			switch(operand)
			{
				case 4:
				{
					operand = reg_A
					break
				}
				case 5:
				{
					operand = reg_B
					break
				}
				case 6:
				{
					operand = reg_C
					break
				}
			}
			break
		}
	}
	switch (opcode)
	{
		case 0:
		{
			reg_A = floor(reg_A/(pow(2,operand)))
			break
		}
		case 1:
		{
			reg_B = (reg_B.tointeger())^operand
			break
		}
		case 2:
		{
			reg_B = operand%8
			break
		}
		case 3:
		{
			if(reg_A!=0) return operand
			break
		}
		case 4:
		{
			reg_B = reg_B^(reg_C.tointeger())
			break
		}
		case 5:
		{
			print("op",operand)
			output_store.append(operand%8)
			break
		}
		case 6:
		{
			reg_B = floor(reg_A/(pow(2,operand)))
			break
		}
		case 7:
		{
			reg_C = floor(reg_A/(pow(2,operand)))
			break
		}
	}
	return pointer+2
}

function RunProgram(A,B,C)
{
	local program_pointer = 0
	local num_instructions = program.len()
	local result = ""
	local output_store = array(0)
	reg_A = A
	reg_B = B
	reg_C = C
	while (program_pointer < num_instructions)
	{
		program_pointer = ProcessOperation(program_pointer,output_store)
	}

	return output_store
}

local p1_out = RunProgram(reg_A,reg_B,reg_C)

foreach(output in p1_out)
{
	p1_value += output + ","
}

/*

	the facts:
	-reg_A = 0 will end the program if at the end of it
	-reg_A must be set to zero
	-program will stop if final 0 opcode -> log2(reg_A) < operand
	-true if:
		if operand 4-6:
			if reg_A-C > log2(reg_A) -> stops

*/

local final = ""
foreach(c in program)
{
	final += c + ","
}

for(local i=0;i<1000000;i++)
{
	local output = RunProgram(i*1000000000,0,0)
	printl(i*1000000 + " " + output.len())
	local test = ""
	foreach(c in output)
	{
		test += c + ","
	}
	if(test==final)
	{
		printl(i)
		break
	}
	//printl((i*100000) +"_A len " + out_len.len())
}

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)