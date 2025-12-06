use std::fs::read_to_string;

#[derive(Debug)]
enum Operation {
    Add,
    Multiply,
}

fn main() {
    let raw_input = read_to_string("day6/input/input.txt").unwrap();
    let input = raw_input.trim_end_matches("\n");

    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let mut silver_ints: Vec<Vec<i64>> = Vec::new();

    let lines: Vec<&str> = input.split("\n").collect();

    for i in 0..(lines.len() - 1) {
        let line = lines[i];
        let nums: Vec<i64> = line
            .split(" ")
            .filter_map(|s| {
                if s.is_empty() {
                    None
                } else {
                    Some(s.parse::<i64>().unwrap())
                }
            })
            .collect();
        for (j, num) in nums.iter().enumerate() {
            if i == 0 {
                silver_ints.push(vec![*num]);
            } else {
                silver_ints[j].push(*num);
            }
        }
    }

    let silver_operations: Vec<Operation> = lines[lines.len() - 1]
        .split(" ")
        .filter_map(|s| {
            if s.is_empty() {
                None
            } else {
                match s {
                    "*" => Some(Operation::Multiply),
                    "+" => Some(Operation::Add),
                    _ => None,
                }
            }
        })
        .collect();

    for (i, operation) in silver_operations.iter().enumerate() {
        match operation {
            Operation::Add => {
                silver += silver_ints[i].iter().sum::<i64>();
            }
            Operation::Multiply => {
                silver += silver_ints[i].iter().product::<i64>();
            }
        }
    }

    let chars: Vec<Vec<char>> = lines
        .iter()
        .map(|line| line.chars().rev().collect())
        .collect();

    let mut transposed_chars = vec![vec!['\0'; chars.len()]; chars[0].len()];

    for i in 0..chars.len() {
        for j in 0..chars[0].len() {
            transposed_chars[j][i] = chars[i][j];
        }
    }

    let mut gold_ints: Vec<i64> = Vec::new();

    for i in 0..transposed_chars.len() {
        if transposed_chars[i].iter().all(|&c| c == ' ') {
            gold_ints.clear();
            continue;
        }
        let num: i64 = transposed_chars[i]
            .iter()
            .filter_map(|char| {
                if char < &'0' || char > &'9' {
                    None
                } else {
                    Some(char)
                }
            })
            .collect::<String>()
            .parse::<i64>()
            .unwrap();
        gold_ints.push(num);
        match transposed_chars[i][transposed_chars[i].len() - 1] {
            '+' => {
                gold += gold_ints.iter().sum::<i64>();
            }
            '*' => {
                gold += gold_ints.iter().product::<i64>();
            }
            _ => {}
        }
    }

    println!("Silver: {silver}\nGold: {gold}");
}
