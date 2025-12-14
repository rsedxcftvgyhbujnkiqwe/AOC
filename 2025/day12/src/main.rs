use std::{fs::read_to_string, time::Instant};
fn main() {
    let input = read_to_string("day12/input/input.txt").unwrap();

    let start = Instant::now();

    let (silver, gold) = day12::solve(&input);

    let duration = start.elapsed();

    println!("Silver: {silver}\nGold: {gold}\nElapsed: {:?}", duration);
}
