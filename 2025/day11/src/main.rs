use std::{fs::read_to_string, time::Instant};
fn main() {
    let input = read_to_string("day11/input/input_cut.txt").unwrap();

    let start = Instant::now();

    let silver = day11::solve(&input);

    let duration = start.elapsed();

    println!("Silver: {silver}\nElapsed: {:?}", duration);
}
