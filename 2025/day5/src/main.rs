use std::{cmp::max, fs::read_to_string};

fn main() {
    let raw_input = read_to_string("day5/input/input.txt").unwrap();
    let input = raw_input.trim();

    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let lines: Vec<&str> = input.split("\n").collect();

    let mut end = 0;

    let mut ranges: Vec<(i64, i64)> = Vec::new();

    for (i, line) in lines.iter().enumerate() {
        let range_vals: Vec<&str> = line.split("-").collect();
        if range_vals.len() == 1 {
            end = i;
            break;
        }
        ranges.push((
            range_vals[0].parse::<i64>().unwrap(),
            range_vals[1].parse::<i64>().unwrap(),
        ));
    }

    ranges.sort_by(|(a1, _), (a2, _)| a1.cmp(a2));

    let mut sorted_ranges: Vec<(i64, i64)> = Vec::new();

    for range in &ranges {
        let length = sorted_ranges.len();
        if (length == 0) || (range.0 > sorted_ranges[length - 1].1) {
            sorted_ranges.push(*range);
        } else {
            sorted_ranges[length - 1].1 = max(range.1, sorted_ranges[length - 1].1);
        }
    }

    for i in (end + 1)..lines.len() {
        let id = lines[i].parse::<i64>().unwrap();
        for range in &sorted_ranges {
            if id >= range.0 && id <= range.1 {
                silver += 1;
                break;
            }
        }
    }

    for range in &sorted_ranges {
        gold += range.1 - range.0 + 1;
    }

    println!("Silver: {silver}\nGold: {gold}");
}
