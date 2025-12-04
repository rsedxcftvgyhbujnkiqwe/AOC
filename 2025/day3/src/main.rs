use std::fs::read_to_string;

fn main() {
    let raw_input = read_to_string("day3/input/input.txt").unwrap();
    let input = raw_input.trim();

    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let input_vec: Vec<&str> = input.split("\n").collect();

    for bank in input_vec {
        let int_bank: Vec<u8> = bank.chars().map(|char| char as u8 - '0' as u8).collect();
        let two_jolt = get_bank_joltage(&int_bank, 0, 2, int_bank.len());
        let twelve_jolt = get_bank_joltage(&int_bank, 0, 12, int_bank.len());
        silver += two_jolt;
        gold += twelve_jolt;
    }
    println!("Silver: {silver}\nGold: {gold}");
}

fn get_bank_joltage(bank: &Vec<u8>, start: i32, size: usize, length: usize) -> i64 {
    // iteration range: start -> bank.len() - (size - 1)
    let mut largest_num: u8 = 0;
    let mut largest_ind = 0;
    for (i, x) in bank[start as usize..(length - size + 1)].iter().enumerate() {
        if *x > largest_num {
            largest_num = *x;
            largest_ind = i;
        }
    }

    if size == 1 {
        return largest_num as i64;
    }
    let value = largest_num as i64 * 10_i64.pow((size - 1) as u32);
    return value + get_bank_joltage(bank, start + largest_ind as i32 + 1, size - 1, length);
}
