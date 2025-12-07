use std::{collections::HashMap, fs::read_to_string};

fn main() {
    let raw_input = read_to_string("day7/input/input.txt").unwrap();
    let input = raw_input.trim_end_matches("\n");

    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let mut start: (usize, usize) = (0, 0);
    let mut splitters: Vec<Vec<usize>> = Vec::new();

    let lines: Vec<&str> = input.split("\n").collect();

    for (y, line) in lines.iter().enumerate() {
        splitters.push(vec![]);
        for (x, char) in line.chars().enumerate() {
            match char {
                'S' => {
                    start = (y, x);
                }
                '^' => {
                    splitters[y].push(x);
                }
                _ => {}
            }
        }
    }

    let filtered_splitters: Vec<Vec<usize>> = splitters
        .iter()
        .filter_map(|row| {
            if row.is_empty() {
                None
            } else {
                Some(row.clone())
            }
        })
        .collect();

    let mut running_count = vec![false; lines[0].len()];
    running_count[start.1] = true;

    let length = filtered_splitters.len();

    let mut child_graph: HashMap<(usize, usize), Vec<(usize, usize)>> = HashMap::new();

    for (i, line) in filtered_splitters.iter().enumerate() {
        for splitter in line {
            if running_count[*splitter] {
                silver += 1;
                running_count[splitter - 1] = true;
                running_count[*splitter] = false;
                running_count[splitter + 1] = true;
            }

            //calc graph for gold

            let mut left: (usize, usize) = (0, 0);
            let mut right: (usize, usize) = (0, 0);

            for j in (i + 1)..length {
                for child_splitter in &filtered_splitters[j] {
                    if *child_splitter == splitter + 1 && right == (0, 0) {
                        right = (j, *child_splitter);
                    } else if *child_splitter == splitter - 1 && left == (0, 0) {
                        left = (j, *child_splitter);
                    }
                    if right != (0, 0) && left != (0, 0) {
                        break;
                    }
                }
                if right != (0, 0) && left != (0, 0) {
                    break;
                }
            }

            child_graph.insert((i, *splitter), vec![left, right]);
        }
    }

    let mut cache: HashMap<(usize, usize), i64> = HashMap::new();

    gold += get_splitter_timeline((0, filtered_splitters[0][0]), &mut cache, &child_graph);

    println!("Silver: {silver}\nGold: {gold}");
}

fn get_splitter_timeline(
    point: (usize, usize),
    cache: &mut HashMap<(usize, usize), i64>,
    child_graph: &HashMap<(usize, usize), Vec<(usize, usize)>>,
) -> i64 {
    if cache.contains_key(&point) {
        return *cache.get(&point).unwrap();
    }

    let children = child_graph.get(&point).unwrap();

    let (left, right) = (children[0], children[1]);

    let mut total = 0;
    total += if left == (0, 0) {
        1
    } else {
        get_splitter_timeline(left, cache, child_graph)
    };
    total += if right == (0, 0) {
        1
    } else {
        get_splitter_timeline(right, cache, child_graph)
    };

    cache.insert(point, total);

    return total;
}
