use std::fs::read_to_string;

fn main() {
    let raw_input = read_to_string("day4/input/input.txt").unwrap();
    let input = raw_input.trim();

    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let mut grid: Vec<Vec<bool>> = input
        .split("\n")
        .map(|line| line.chars().map(|char| char == '@').collect())
        .collect();

    let y_max = grid.len() - 1;
    let x_max = grid[0].len() - 1;

    for i in 0..=y_max {
        for j in 0..=x_max {
            if grid[i][j] && can_access(i, j, y_max, x_max, &grid) {
                silver += 1;
            }
        }
    }

    loop {
        let (count, return_grid) = count_and_remove(&grid);

        if count == 0 {
            break;
        }

        gold += count as i64;
        grid = return_grid;
    }

    println!("Silver: {silver}\nGold: {gold}");
}

fn count_and_remove(grid: &Vec<Vec<bool>>) -> (i32, Vec<Vec<bool>>) {
    let mut grid_clone = grid.clone();

    let y_max = grid.len() - 1;
    let x_max = grid[0].len() - 1;

    let mut count = 0;

    for i in 0..=y_max {
        for j in 0..=x_max {
            if grid[i][j] && can_access(i, j, y_max, x_max, &grid) {
                count += 1;
                grid_clone[i][j] = false;
            }
        }
    }

    (count, grid_clone)
}

fn can_access(y: usize, x: usize, y_max: usize, x_max: usize, grid: &Vec<Vec<bool>>) -> bool {
    let mut count: u8 = 0;

    let left_edge = x == 0;
    let right_edge = x == x_max;
    let top_edge = y == 0;
    let bottom_edge = y == y_max;

    if !top_edge {
        if !left_edge && grid[y - 1][x - 1] {
            count += 1;
        }
        if grid[y - 1][x] {
            count += 1;
        }
        if !right_edge && grid[y - 1][x + 1] {
            count += 1;
        }
    }

    if !left_edge && grid[y][x - 1] {
        count += 1;
    }
    if !right_edge && grid[y][x + 1] {
        count += 1;
    }

    if !bottom_edge {
        if !left_edge && grid[y + 1][x - 1] {
            count += 1;
        }
        if grid[y + 1][x] {
            count += 1;
        }
        if !right_edge && grid[y + 1][x + 1] {
            count += 1;
        }
    }

    count < 4
}
