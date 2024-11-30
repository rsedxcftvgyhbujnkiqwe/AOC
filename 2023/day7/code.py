import time
with open("input/input","r") as f:
    data = f.readlines()

type_ranks = {
    "five":6,
    "four":5,
    "house":4,
    "three":3,
    "two":2,
    "one":1,
    "high":0
}

def get_hand_list_p1(hand):
    hand_list = []
    hand_type = {}
    for card in hand:
        if card == "A":
            hand_list.append(14)
        elif card == "K":
            hand_list.append(13)
        elif card == "Q":
            hand_list.append(12)
        elif card == "J":
            hand_list.append(11)
        elif card == "T":
            hand_list.append(10)
        else:
            hand_list.append(int(card))
        cur_card = hand_list[-1]
        if cur_card in hand_type:
            hand_type[cur_card] += 1
        else:
            hand_type[cur_card] = 1
    type_list = sorted([hand_type[x] for x in hand_type],reverse=True)
    final_type = "high"
    if type_list[0] == 5:
        final_type = "five"
    elif type_list[0] == 4:
        final_type = "four"
    elif type_list[0] == 3:
        if type_list[1] == 2:
            final_type = "house"
        else:
            final_type = "three"
    elif type_list[0] == 2:
        if type_list[1] == 2:
            final_type = "two"
        else:
            final_type = "one"

    return hand_list, final_type

def compare_hands(hand1,hand2):
    for card in range(5):
        if hand1[card] > hand2[card]:
            return True
        elif hand1[card] == hand2[card]:
            continue
        else:
            return False
    return False
p1s = time.time()
def part1(data):
    card_data = {
        0:[],
        1:[],
        2:[],
        3:[],
        4:[],
        5:[],
        6:[]
    }
    first = [True]*7
    for line in data:
        sv = line.split(" ")
        hand = sv[0]
        bet = int(sv[1].rstrip())
        hand_list,hand_type = get_hand_list_p1(hand)
        type_num = type_ranks[hand_type]
        if first[type_num]:
            first[type_num] = False
            card_data[type_num].append([hand_list,bet])
        else:
            count = 0
            num_in_tier = len(card_data[type_num])
            for i in range(num_in_tier):
                if compare_hands(hand_list,card_data[type_num][i][0]):
                    if i == num_in_tier-1:
                        card_data[type_num].append([hand_list,bet])
                        break
                else:
                    card_data[type_num].insert(i,[hand_list,bet])
                    break

    winnings = 0
    ranks = 0
    for i in range(7):
        for j in range(len(card_data[i])):
            rank = j + 1 + ranks
            winadd = card_data[i][j][1]*rank
            winnings += winadd
        ranks += len(card_data[i])
    return winnings
print(f"Part 1: {part1(data)} ({time.time()-p1s})")

def get_hand_list_p2(hand):
    hand_list = []
    hand_type = {}
    jokers = 0
    for card in hand:
        if card == "A":
            hand_list.append(14)
        elif card == "K":
            hand_list.append(13)
        elif card == "Q":
            hand_list.append(12)
        elif card == "J":
            hand_list.append(-1)
        elif card == "T":
            hand_list.append(10)
        else:
            hand_list.append(int(card))
        cur_card = hand_list[-1]
        if card == "J":
            jokers +=1
        else:
            if cur_card in hand_type:
                hand_type[cur_card] += 1
            else:
                hand_type[cur_card] = 1
    type_list = sorted([hand_type[x] for x in hand_type],reverse=True)
    final_type = "high"
    if jokers == 0:
        if type_list[0] == 5:
            final_type = "five"
        elif type_list[0] == 4:
            final_type = "four"
        elif type_list[0] == 3:
            if type_list[1] == 2:
                final_type = "house"
            else:
                final_type = "three"
        elif type_list[0] == 2:
            if type_list[1] == 2:
                final_type = "two"
            else:
                final_type = "one"
    else:
        if jokers >= 4:
            final_type = "five"
        elif jokers == 3:
            if type_list[0] == 1:
                final_type = "four"
            else:
                final_type = "five"
        elif jokers == 2:
            if type_list[0] == 3:
                final_type = "five"
            elif type_list[0] == 2:
                final_type = "four"
            else:
                final_type = "three"
        else:
            if type_list[0] == 4:
                final_type = "five"
            elif type_list[0] == 3:
                final_type = "four"
            elif type_list[0] == 2:
                if type_list[1] == 2:
                    final_type = "house"
                else:
                    final_type = "three"
            else:
                final_type = "one"
    return hand_list, final_type
p2s = time.time()
def part2(data):
    card_data = {
        0:[],
        1:[],
        2:[],
        3:[],
        4:[],
        5:[],
        6:[]
    }
    first = [True]*7
    for line in data:
        sv = line.split(" ")
        hand = sv[0]
        bet = int(sv[1].rstrip())
        hand_list,hand_type = get_hand_list_p2(hand)
        type_num = type_ranks[hand_type]
        if first[type_num]:
            first[type_num] = False
            card_data[type_num].append([hand_list,bet])
        else:
            count = 0
            num_in_tier = len(card_data[type_num])
            for i in range(num_in_tier):
                if compare_hands(hand_list,card_data[type_num][i][0]):
                    if i == num_in_tier-1:
                        card_data[type_num].append([hand_list,bet])
                        break
                else:
                    card_data[type_num].insert(i,[hand_list,bet])
                    break

    winnings = 0
    ranks = 0
    for i in range(7):
        for j in range(len(card_data[i])):
            rank = j + 1 + ranks
            winadd = card_data[i][j][1]*rank
            winnings += winadd
            if -1 in card_data[i][j][0]:
                print(f"Joker card: {card_data[i][j][0]}, rank {rank} score {winadd}")
        ranks += len(card_data[i])
    return winnings
print(f"Part 2: {part2(data)} ({time.time() - p2s})")
