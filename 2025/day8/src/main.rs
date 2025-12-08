use std::{fs::read_to_string, time::Instant, collections::HashSet};

fn main() {
    let input = read_to_string("day8/input/input.txt").unwrap();

    let start = Instant::now();

    let (silver, gold) = solve(input);

    let duration = start.elapsed();

    println!("Silver: {silver}\nGold: {gold}\nElapsed: {:?}", duration);
}

fn solve(input: String) -> (i64, i64) {
    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let length = input.len();

    let bytes = input.as_bytes();

    let mut junctions: Vec<(i32,i32,i32)> = Vec::new();
    let mut junc_connections: Vec<((i32,i32,i32),(i32,i32,i32),i64)> = Vec::new();

    let mut line_nums: Vec<i32,> = Vec::new();
    let mut running = 0;
    for x in 0..length {
        let byte = bytes[x];
        if byte == b',' {
            line_nums.push(running);
            running = 0;
        } else if byte == b'\n' {
            line_nums.push(running);
            junctions.push((line_nums[0],line_nums[1],line_nums[2]));
            line_nums.clear();
            running = 0;
        } else if byte >= b'0' && byte <= b'9' {
            running = running * 10 + ((byte - b'0') as i32);
        } 
    }
    let num_junctions = junctions.len();
    for x in 0..num_junctions-1 {
        let junc = junctions[x];
        for comp in x+1..num_junctions {
            let comp_junc = junctions[comp];
            let dist = distance(junc,comp_junc);
            junc_connections.push((junc,comp_junc,dist));
        }
    }
    junc_connections.sort_by(|a,b| a.2.cmp(&b.2));

    let mut connections: Vec<HashSet<(i32,i32,i32)>> = Vec::new();

    let mut last_connection: ((i32,i32,i32),(i32,i32,i32)) = ((0,0,0),(0,0,0));

    for x in 0..junc_connections.len() {
        let left = junc_connections[x].0;
        let right = junc_connections[x].1;
        let mut contains: Vec<usize> = Vec::new();
        for (i,connection) in connections.iter_mut().enumerate() {
            let contains_left = connection.contains(&left);
            let contains_right = connection.contains(&right);
            if contains_left || contains_right {
                contains.push(i);
            } else {
            }
        }

        contains.reverse();
        let contlen = contains.len();

        let mut did_insert = false;

        if contlen > 0 {
            for i in 0..contlen-1 {
                let current: Vec<_> = connections[contains[i]].iter().cloned().collect();
                connections[contains[i+1]].extend(current);
                connections.remove(contains[i]);
                did_insert = true;
            }
            let did_left = connections[contains[contlen-1]].insert(left);
            let did_right = connections[contains[contlen-1]].insert(right);
            if did_left || did_right {
                did_insert = true;
            }
        } else {
            let mut new_set: HashSet<(i32,i32,i32)> = HashSet::new();
            new_set.insert(left);
            new_set.insert(right);
            connections.push(new_set);
        }

        if x == 999 {
            connections.sort_by(|a,b| b.len().cmp(&a.len()));
            silver += (connections[0].len() as i64) * (connections[1].len() as i64) * (connections[2].len() as i64);
        }

        if did_insert {
            last_connection = (left,right);
        }

    }
    gold += (last_connection.0.0 as i64) * (last_connection.1.0 as i64);


    (silver, gold)
}

fn distance(a: (i32,i32,i32), b: (i32,i32,i32)) -> i64 {
    let dx = (a.0 - b.0) as f32;
    let dy = (a.1 - b.1) as f32;
    let dz = (a.2 - b.2) as f32;
    (dx*dx + dy*dy + dz*dz).sqrt() as i64
}