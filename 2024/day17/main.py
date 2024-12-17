#big numbers, womp womp
import math

p1_value = ""
p2_value = ""

reg_A = None
reg_B = None
reg_C = None

program = []

with open("input/input.txt","r") as f:
	data = f.read().rstrip().split("\n")

reg_A = int(data[0].split(" ")[2])
reg_B = int(data[1].split(" ")[2])
reg_C = int(data[2].split(" ")[2])
program = list(map(int,data[4].split(" ")[1].split(",")))


def ProcessOperation(A,B,C,pointer,output_store):
	opcode = program[pointer]
	operand = program[pointer+1]
	if (opcode == 0 or
		opcode == 2 or
		opcode == 5 or
		opcode == 6 or
		opcode == 7):
		if(operand==4):
			operand = A
		elif(operand==5):
			operand = B
		elif(operand==6):
			operand = C
	if(opcode==0):
		A = math.floor(A/(2**operand))
	elif(opcode==1):
		B = (int(B))^operand
	elif(opcode==2):
		B = operand%8
	elif(opcode==3):
		if(A!=0):
			return operand,A,B,C,output_store
	elif(opcode==4):
		B = B^(int(C))
	elif(opcode==5):
		output_store.append(operand%8)
	elif(opcode==6):
		B = math.floor(A/(2**operand))
	elif(opcode==7):
		C = math.floor(A/(2**operand))
	return pointer+2,A,B,C,output_store

def RunProgram(A,B,C):
	program_pointer = 0
	num_instructions = len(program)
	result = ""
	output_store = []
	while (program_pointer < num_instructions):
		pack = ProcessOperation(A,B,C,program_pointer,output_store)
		program_pointer,A,B,C,output_store = pack
	return output_store

p1_out = RunProgram(reg_A,reg_B,reg_C)

for output in p1_out:
	p1_value += str(output) + ","

final = ""
for c in program:
	final += str(c) + ","

cycle = []

for i in range(1024):
	p = RunProgram(i,0,0)
	value = p[0]
	cycle.append(value)

def get_lowest_int(program):
	length = len(program)
	minimum = 0
	for i in range(length):
		value = program[-1 - i]
		program_index = (length-i-1)
		ind_mult = 8**program_index
		search = (minimum//ind_mult)%1024
		remainder = (minimum//ind_mult)//1024
		first_ind = cycle.index(value,search)
		minimum = max((first_ind+remainder*1024)*ind_mult,ind_mult)
	return minimum

p2_value = get_lowest_int(program)

print("Part 1:")
print(p1_value)
print("Part 2:")
print(p2_value)