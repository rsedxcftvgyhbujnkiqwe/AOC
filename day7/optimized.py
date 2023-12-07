import time
with open("input/biginput","r") as f:
    data = f.readlines()

card_map = {"A":"E","K":"D","Q":"C","J":"B","T":"A","9":"9","8":"8","7":"7","6":"6","5":"5","4":"4","3":"3","2":"2"}
card_map_joker = {"A":"E","K":"D","Q":"C","J":"1","T":"A","9":"9","8":"8","7":"7","6":"6","5":"5","4":"4","3":"3","2":"2"}

def get_hand_type(hand,part):
    hand_type = {}
    jokers = 0
    for card in hand:
        if card == "J":
            jokers += 1
        if card in hand_type:
            hand_type[card] += 1
        else:
            hand_type[card] = 1
    type_list = hand_type.values()
    if 5 in type_list:
        return 6
    elif 4 in type_list:
        if part == 2 and jokers > 0:
            return 6
        return 5
    elif 3 in type_list:
        if 2 in type_list:
            if part == 2 and jokers > 1:
                return 6
            return 4
        elif part == 2 and jokers > 0:
            return 5
        return 3
    elif 2 in type_list:
        if len(type_list) == 3:
            if part == 2:
                if jokers == 2:
                    return 5
                elif jokers == 1:
                    return 4
            return 2
        else:
            if part == 2 and jokers > 0:
                return 3
            else:
                return 1
    if part == 2 and jokers == 1:
        return 1
    return 0

def fixup_hand(hand,cmap):
    fixed_hand = ""
    for i in range(5):
        fixed_hand += cmap[hand[i]]
    return fixed_hand

def solve(data,part):
    card_data = [[],[],[],[],[],[],[]]
    data = list(map(lambda x: [x[0],int(x[1])],map(lambda x: x.rstrip().split(" "),data)))
    cmap = card_map_joker if part == 2 else card_map
    for line in data:
        hand = line[0]
        bet = line[1]
        hand_type = get_hand_type(hand,part)
        card_data[hand_type].append([fixup_hand(hand,cmap),hand,bet])
    winnings = 0
    ranks = 0
    for i in range(7):
        card_data[i] = sorted(card_data[i])
        for j in range(len(card_data[i])):
            rank = j + 1 + ranks
            winadd = card_data[i][j][2]*rank
            winnings += winadd
        ranks += len(card_data[i])
    return winnings

p1s = time.time()
solution = solve(data,1)
timediff = time.time()-p1s
print(f"Part 1: {solution} ({timediff})\n")


p2s = time.time()
solution = solve(data,2)
timediff = time.time()-p2s
print(f"Part 1: {solution} ({timediff})\n")
