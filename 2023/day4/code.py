with open("input/input","r") as f:
    data = f.readlines()

def part1(data):
    total = 0
    for line in data:
        number_data = line.split(":")[1].split("|")
        winning_numbers = number_data[0].strip().split(" ")
        available_numbers = number_data[1].strip().split(" ")
        wins = [x for x in available_numbers if x in winning_numbers and x.isnumeric()]
        val = 0
        if len(wins) > 0:
            val = 2**(len(wins)-1)
        total += val
    return total

print(part1(data))

def part2(data):
    card_data = []
    for i in range(len(data)):
        number_data = data[i].split(":")[1].split("|")
        winning_numbers = number_data[0].strip().split(" ")
        available_numbers = number_data[1].strip().split(" ")
        wins = [x for x in available_numbers if x in winning_numbers and x.isnumeric()]
        card_data.append([i,len(wins),1])
    total_cards = len(card_data)
    for cardnum in range(len(card_data)):
        for winnum in range(min(card_data[cardnum][1],total_cards-cardnum)):
            card_data[cardnum+winnum+1][2] += card_data[cardnum][2]
    num_cards = [x[2] for x in card_data]
    return sum(num_cards)
print(part2(data))
