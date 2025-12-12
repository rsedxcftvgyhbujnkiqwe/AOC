// washed with help from reading some anons code and learning new tricks
use std::{fs::read_to_string, time::Instant};

fn main() {
    let input = read_to_string("day7/input/input.txt").unwrap();

    let start = Instant::now();

    let (silver, gold) = solve(input);

    let duration = start.elapsed();

    println!("Silver: {silver}\nGold: {gold}\nElapsed: {:?}", duration);
}

fn solve(input: String) -> (i64, i64) {
    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let width = input.find('\n').unwrap();
    let length = width + 1;
    let start = input.find('S').unwrap();

    let mut running_count: Vec<i64> = vec![0; width];

    running_count[start] = 1;

    let rows = input.len() / length;

    let bytes = input.as_bytes();

    for y in (2..rows).step_by(2) {
        let row = &bytes[y * length..y * length + width];
        let spread = y / 2;
        let min_x = start.saturating_sub(spread);
        let max_x = (start + spread).min(width);
        for x in min_x..max_x {
            if row[x] == b'^' {
                let count = running_count[x];
                if count > 0 {
                    silver += 1;
                    running_count[x - 1] += count;
                    running_count[x + 1] += count;
                    running_count[x] = 0;
                }
            }
        }
    }

    gold += running_count.iter().sum::<i64>();

    (silver, gold)
}
