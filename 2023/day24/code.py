with open("input/input","r") as f:
    data = f.read().rstrip().split("\n")

data = [line.split(" @ ") for line in data]
data = [[line[0].split(", "),line[1].split(", ")] for line in data]
data = [[tuple(map(int,line[0])),tuple(map(int,line[1]))] for line in data]

def get_equation_values(px,py,vx,vy):
    slope = vy/vx
    intercept = py - slope*(px)
    return slope,intercept

for i,stone in enumerate(data):
    m,b = get_equation_values(stone[0][0],stone[0][1],stone[1][0],stone[1][1])
    data[i] += [m,b]

def solve_equation(m1,b1,m2,b2):
    x = (b2-b1)/(m1-m2)
    return x,x*m1+b1

def sign(integer):
    return 1 if integer < 0 else 0

total = 0
#min_val = 7
#max_val = 27
min_val = 200000000000000
max_val = 400000000000000

for i,stone in enumerate(data[:-1]):
    px1,py1,pz1 = stone[0]
    vx1,vy1,vz1 = stone[1]
    
    sx1 = sign(vx1)
    sy1 = sign(vy1)

    m1 = stone[2]
    b1 = stone[3]
    
    for j,stone2 in enumerate(data[i+1:]):
        px2,py2,pz2 = stone2[0]
        vx2,vy2,vz2 = stone2[1]
        
        sx2 = sign(vx2)
        sy2 = sign(vy2)

        m2 = stone2[2]
        b2 = stone2[3]
        
        if m1 == m2:
            if b1 == b2: total += 1
            else: continue
        
        x,y = solve_equation(m1,b1,m2,b2)
        
        if x >= min_val and y >= min_val and x <= max_val and y <= max_val:
            dx1 = sign(x - px1)
            dy1 = sign(y - py1)

            dx2 = sign(x - px2)
            dy2 = sign(y - py2)

            if sx1 == dx1 and sy1 == dy1 and sx2 == dx2 and sy2 == dy2:
                total += 1        
print(total)

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def tup2add(t1,t2):
    return (t1[0]+t2[0],t1[1]+t2[1],t1[2]+t2[2])

def scale_vector(vector,scalar):
    return tuple(scalar*x for x in vector)

def set_axes_equal(ax):
    x_limits = ax.get_xlim3d()
    y_limits = ax.get_ylim3d()
    z_limits = ax.get_zlim3d()

    x_range = abs(x_limits[1] - x_limits[0])
    x_middle = np.mean(x_limits)
    y_range = abs(y_limits[1] - y_limits[0])
    y_middle = np.mean(y_limits)
    z_range = abs(z_limits[1] - z_limits[0])
    z_middle = np.mean(z_limits)

    # The maximum range will determine the plot size, and all axes will be scaled equally
    max_range = max(x_range, y_range, z_range)

    ax.set_xlim3d([x_middle - max_range / 2, x_middle + max_range / 2])
    ax.set_ylim3d([y_middle - max_range / 2, y_middle + max_range / 2])
    ax.set_zlim3d([z_middle - max_range / 2, z_middle + max_range / 2])

points = []
for i,stone in enumerate(data):
    points.append([stone[0],tup2add(stone[0],scale_vector(stone[1],1000000000000))])

fig = plt.figure()

ax = fig.add_subplot(111, projection='3d')
for start,end in points[:]:
    ax.plot3D([start[0], end[0]], [start[1], end[1]], [start[2], end[2]])

ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

ax.set_xlim((min_val,max_val))
ax.set_ylim((min_val,max_val))
ax.set_zlim((min_val,max_val))

plt.show()
