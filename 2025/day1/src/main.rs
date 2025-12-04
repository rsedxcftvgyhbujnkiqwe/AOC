use std::fs::read_to_string;

fn main() {
    let input = read_to_string("day1/input/input.txt").unwrap();

    let mut base = 50;
    let mut silver = 0;
    let mut gold = 0;
    let dial_size = 100;

    let instructions: Vec<&str> = input.trim().split("\n").collect();

    for inst in instructions {
        let mut iter = inst.chars();
        let turn_value: i32 = match iter.next().unwrap() {
            'R' => iter.collect::<String>().parse::<i32>().unwrap(),
            _ => iter.collect::<String>().parse::<i32>().unwrap() * -1,
        };
        let num_rotations: i32 = turn_value / dial_size;
        gold += num_rotations.abs();

        let raw = turn_value % dial_size;

        if (base + raw > dial_size) || ((base != 0) && (base + raw < 0)) {
            gold += 1;
        }

        let new_pos = pos_modulo(base + turn_value, dial_size);
        if new_pos == 0 {
            silver += 1;
            gold += 1;
        }

        base = new_pos;
    }
    println!("Silver: {silver}\nGold: {gold}");
}

fn pos_modulo(x: i32, y: i32) -> i32 {
    (x % y + y) % y
}
