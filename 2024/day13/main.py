with open("input/input.txt","r") as f:
	data = f.read().rstrip().split("\n\n")

p1_value = 0
p2_value = 0

def SysEquationMin(A_x,A_y,B_x,B_y,Target_x,Target_y):
	A_count = (B_x*Target_y - B_y*Target_x)/(A_y*B_x - A_x*B_y)
	if(A_count%1==0):
		return A_count*3 + (Target_x - A_x*A_count)/B_x
	return 0

for value in data:
	lines = value.split("\n")
	A_x = int(lines[0].split("+")[1].split(",")[0])
	A_y = int(lines[0].split("+")[2])
	B_x = int(lines[1].split("+")[1].split(",")[0])
	B_y = int(lines[1].split("+")[2])
	Target_x = int(lines[2].split("=")[1].split(",")[0])
	Target_y = int(lines[2].split("=")[2])
	p1_value += int(SysEquationMin(A_x,A_y,B_x,B_y,Target_x,Target_y))
	p2_value += int(SysEquationMin(A_x,A_y,B_x,B_y,Target_x+10000000000000,Target_y+10000000000000))
print("Silver",p1_value)
print("Gold",p2_value)
