from functools import lru_cache

with open("input/input","r") as f:
    data = f.read()

@lru_cache(maxsize=None)
def get_line_diff(line1,line2):
    if line1 == line2: return 0,[]
    count = 0
    diffs = []
    for i in range(len(line1)):
        if line1[i] != line2[i]:
            count += 1
            diffs.append(i)
    return count,diffs

def get_matches(lines):
    linelen = len(lines)
    matches = []
    for i in range(1,linelen,2):
        if lines[0] == lines[i]:
            if lines[0:i+1] == lines[0:i+1][::-1]:
                matches.append((0,i,))

    for i in range(linelen-2,-1,-2):
        if lines[i] == lines[linelen-1]:
            if lines[i:linelen] == lines[i:linelen][::-1]:
                matches.append((i,linelen-1,))
    return matches


def solve(data):
    total1 = 0
    total2 = 0
    sections = [x.split("\n") for x in data.split("\n\n")]
    for k,section in enumerate(sections):
        rows = [list(row.rstrip()) for row in section if row.rstrip() != ""]
        transposed = [list(row) for row in zip(*rows)]
        columns = [list(row) for row in transposed]
        
        row_matches = get_matches(rows)
        
        column_matches = get_matches(columns)
        
        all_reflects = 0
        for match in row_matches:
            row_val = (match[0] + match[1]+1)/2
            all_reflects += row_val*100
        for match in column_matches:
            col_val = (match[0] + match[1] + 1)/2
            all_reflects += col_val
        total1 += all_reflects


        row_collide = []
        for i in range(len(rows)):
            for j in range(i+1,len(rows),2):
                rowdiff,index = get_line_diff(tuple(rows[i]),tuple(rows[j]))
                if rowdiff == 1:
                    row_collide.append([i,j,index[0]])
        
        col_collide = []
        for i in range(len(columns)):
            for j in range(i+1,len(columns),2):
                coldiff,index = get_line_diff(tuple(columns[i]),tuple(columns[j]))
                if coldiff == 1:
                    col_collide.append([i,j,index[0]])


        new_row_matches = []
        new_col_matches = []
        for collide in row_collide:
            new_rows = [x.copy() for x in  rows]
            new_rows[collide[0]][collide[2]] = "#"
            new_rows[collide[1]][collide[2]] = "#"
            new_row_matches += get_matches(new_rows)
        
            new_columns = [x.copy() for x in columns]
            new_columns[collide[2]][collide[1]] = "#"
            new_columns[collide[2]][collide[0]] = "#"
            new_col_matches += get_matches(new_columns)
        for collide in  col_collide:
            new_rows = [x.copy() for x in rows]
            new_rows[collide[2]][collide[0]] = "#"
            new_rows[collide[2]][collide[1]] = "#"
            new_row_matches += get_matches(new_rows)
            
            new_columns = [x.copy() for x in columns]
            new_columns[collide[0]][collide[2]] = "#"
            new_columns[collide[1]][collide[2]] = "#"
            new_col_matches += get_matches(new_columns)

        new_row_matches = [x for x in set(new_row_matches) if x not in row_matches]
        new_col_matches = [x for x in set(new_col_matches) if x not in column_matches]

        for match in new_row_matches:
            total2 += (match[0] + match[1] + 1)*50
        for match in new_col_matches:
            total2 += (match[0] + match[1] + 1)/2
    return total1,total2
solution = solve(data)
print(f"Part 1: {solution[0]}\nPart 2: {solution[1]}")
