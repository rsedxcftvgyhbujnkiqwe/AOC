use std::{cmp::{min,max},fs::read_to_string, time::Instant,collections::HashMap};

fn main() {
    let input = read_to_string("day9/input/input.txt").unwrap();

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

    let mut sizes: Vec<((i32,i32),(i32,i32),i64)> = Vec::new();
    let mut points: Vec<(i32,i32)> = Vec::new();

    let mut left = 0;
    let mut running = 0;
    for x in 0..length {
        let byte = bytes[x];
        match byte {
            b'0'..=b'9' => {
                running = running*10 + (byte - b'0') as i32;
            }
            b',' => {
                left = running;
                running = 0;
            }
            b'\n' => {
                let current = (left,running);
                points.push(current);
                left = 0;
                running = 0;
                for x in 0..points.len()-1 {
                    let size = rect_size(points[x],current);
                    sizes.push((points[x],current,size));
                }
            }
            _ => {}
            
        }
    }

    let mut compression_map: HashMap<(i32,i32),(i32,i32)> = HashMap::new();

    let length = points.len();
    let last = length - 1;
    let original_points = points.clone();

    // reduce X
    points.sort_by(|a,b| a.0.cmp(&b.0));
    let mut reduction = points[0].0;
    for i in 0..points.len() {
        let starting_point = points[i];

        let reduced = (starting_point.0 - reduction,starting_point.1);

        compression_map.insert(starting_point,reduced);

        reduction = if i < last {
            max(points[i+1].0 - starting_point.0 - 2,0) + reduction
        } else {
            0
        };
    }
    // reduce Y
    points.sort_by(|a,b| a.1.cmp(&b.1));
    reduction = points[0].1;
    for i in 0..points.len() {
        let starting_point = points[i];

        let reduced = (starting_point.0,starting_point.1 - reduction);

        let value = compression_map.get_mut(&starting_point).unwrap();
        value.1 = reduced.1;

        reduction = if i < last {
            max(points[i+1].1 - starting_point.1 - 2,0) + reduction
        } else {
            0
        };
    }

    sizes.sort_by(|a,b| b.2.cmp(&a.2));

    silver += sizes[0].2;

    // gen edges for raycasting
    let mut edges: Vec<(i32,i32,i32,i32,((i32,i32),(i32,i32)))> = Vec::new();
    for x in 0..length {
        let a = compression_map.get(&original_points[x]).unwrap();
        let b = if x < length-1 {
            compression_map.get(&original_points[x+1]).unwrap()
        } else {
            compression_map.get(&original_points[0]).unwrap()
        };
        let x_min = min(a.0,b.0);
        let x_max = max(a.0,b.0);
        let y_min = min(a.1,b.1);
        let y_max = max(a.1,b.1);
        edges.push((x_min,x_max,y_min,y_max, (*a, *b)));
    }

    let mut gold_solution: ((i32,i32),(i32,i32)) = ((0,0),(0,0));

    let mut ray_cache: HashMap<(i32,i32),bool> = HashMap::new();

    for size in sizes {
        let left = compression_map.get(&size.0).unwrap();
        let right = compression_map.get(&size.1).unwrap();
        let x_min = min(left.0,right.0);
        let x_max = max(left.0,right.0);
        let y_min = min(left.1,right.1);
        let y_max = max(left.1,right.1);

        let mut valid = true;

        for y in y_min..=y_max {
            for x in x_min..=x_max {
                let point = (x,y);
                let raycast = ray_cache.entry(point).or_insert_with(|| {
                    let mut intersections_x = 0;
                    let mut intersections_y = 0;
                    for edge in &edges {
                        // on vertical edge
                        if point.0 == edge.0 && edge.0 == edge.1 && point.1 <= edge.3 && point.1 >= edge.2 {
                            return true;
                        }
                        // on horizontal edge
                        if point.1 == edge.2 && edge.2 == edge.3 && point.0 <= edge.1 && point.0 >= edge.0 {
                            return true;
                        }
                        // vertical raycast
                        if point.1 > edge.3 && point.0 >= edge.0 && point.0 < edge.1 {
                            intersections_x += 1;
                        }
                        // horizontal raycast
                        if point.0 > edge.1 && point.1 >= edge.2 && point.1 < edge.3 {
                            intersections_y += 1;
                        }
                    };
                    !((intersections_x%2==0) && (intersections_y%2==0))
                });
                if !*raycast {
                    valid = false;
                    break;
                }
            }
            if !valid {
                break
            }
        }


        if !valid {
            continue;
        }

        gold_solution.0 = size.0;
        gold_solution.1 = size.1;
        gold += size.2;
        break;
    }

    (silver, gold)
}

fn rect_size(a: (i32,i32), b: (i32,i32)) -> i64 {
    let dx: i64 = (a.0 - b.0).abs() as i64 + 1;
    let dy: i64 = (a.1 - b.1).abs() as i64 + 1;
    dx*dy
}