use ndarray::{Array1,Array2,s};
use std::cmp::Reverse;

#[derive(Debug)]
struct Shape {
    variants: Vec<((usize,usize),Array2<i8>)>,
    bbox: usize,
    efficiency: f32,
    count: Array1<i8>,
}

pub fn solve(input: &String) -> (i64, i64) {
    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let length = input.len();
    let bytes = input.as_str().as_bytes();

    let mut stop_point = 0;
    let mut newlines = 0;

    let mut shapes: Vec<(Vec<Vec<bool>>,Vec<usize>)> = vec![];

    let mut shape_matrix: Vec<Vec<bool>> = vec![];

    let mut shape_row: Vec<bool> = Vec::new();

    let mut prev_byte = b'\0';
    let mut working: usize = 0;
    let mut reduction: Vec<usize> = Vec::new();
    for x in 0..length {
        let byte = bytes[x];
        match byte {
            b'0'..=b'9' => {
                working = working * 10 + (byte - b'0') as usize;
            }
            b',' => {
                reduction.push(working);
                working = 0;
            }
            b'#' => {
                shape_row.push(true);
            }
            b'.' => {
                shape_row.push(false);
            }
            b'\n' => {
                if shape_row.len() > 0 {
                    shape_matrix.push(shape_row.clone())
                }
                shape_row.clear();
                newlines += 1;
                if prev_byte == b'\n' {
                    shapes.push((shape_matrix.clone(),reduction.clone()));
                    reduction.clear();
                    shape_matrix = vec![];
                }
            }
            b':' => {
                reduction.push(working);
                working = 0;
            }
            b'-' => {
                stop_point = x;
                break
            }
            _ => {}
        }
        prev_byte = byte;
    };

    let mut problems: Vec<((usize,usize),Vec<usize>)> = Vec::new();

    let mut dimensions: (usize,usize) = (0,0);
    let mut shape_count: Vec<usize> = vec![];

    working = 0;
    let mut on_dim = true;
    for x in stop_point+1..length {
        let byte = bytes[x];
        match byte {
            b'0'..=b'9' => {
                working = working*10 + (byte - b'0') as usize;
            }
            b'x' => {
                dimensions.0 = working;
                working = 0;
            }
            b':' => {
                dimensions.1 = working;
                working = 0;
            }
            b' ' => {
                if !on_dim {
                    shape_count.push(working);
                }
                on_dim = false;
                working = 0;
            }
            b'\n' => {
                on_dim = true;
                shape_count.push(working);
                working = 0;

                problems.push((dimensions,shape_count.clone()));
                dimensions = (0,0);
                shape_count.clear();
            }
            _ => {}
        }
    }

    //store shapes better
    let mut shape_master: Vec<Shape> = Vec::new();

    for shape in &shapes {
        let grid = &shape.0;
        let rows = grid.len();
        let cols = grid[0].len();
        let bbox = rows*cols;
        let size = grid.iter().map(|row| row.iter().filter(|&&x| x).count()).sum::<usize>();
        let efficiency: f32 = size as f32 / bbox as f32;
        let data: Vec<i8> = grid.into_iter().flat_map(|row| row.into_iter().map(|b| *b as i8)).collect();
        let array_shape = Array2::from_shape_vec((rows,cols),data).unwrap();
        let mut count_arr = Array1::zeros(6); //lolhardcode
        for v in &shape.1 {
            count_arr[*v] += 1;
        }
        let mut variations: Vec<((usize,usize),Array2<i8>)> = vec![((rows,cols),array_shape)];
        for i in 0..3 {
            let rotation: Array2<i8> = variations[i].1.t().slice(s![..,..;-1]).to_owned();
            let var_shape = (rotation.shape()[0],rotation.shape()[1]);
            variations.push((var_shape,rotation));
        }
        variations.swap(1,2);
        variations.dedup();
        shape_master.push(Shape {
            variants: variations,
            bbox,
            efficiency,
            count: count_arr
        })
    }

    shape_master.sort_by(|a,b| {
        b.bbox.cmp(&a.bbox).then_with(|| b.efficiency.partial_cmp(&a.efficiency).unwrap())
    });

    for (c,problem) in problems.iter().enumerate() {
        if can_fit_shapes(problem,&shape_master) {
            silver += 1;
        }
    }

    (silver, gold)
}

fn can_fit_shapes(problem: &((usize,usize),Vec<usize>), shape_master: &Vec<Shape>) -> bool {
    let dimensions = problem.0;
    let shape_count = &problem.1;
    let num_shapes = shape_master.len();

    let mut space_grid: Array2<i8> = Array2::zeros(dimensions);

    let int_count: Vec<i8> = shape_count.iter().map(|x| *x as i8).collect();
    let mut solution_arr: Array1<i8> = Array1::from(int_count);

    let mut cur_shape = 0;
    loop {
        if cur_shape == num_shapes {
            return !solution_arr.iter().any(|x| *x!=0);
        }
        solution_arr -= &shape_master[cur_shape].count;
        if solution_arr.iter().any(|x| *x<0) {
            solution_arr += &shape_master[cur_shape].count;
            cur_shape += 1;
            continue;
        }
        // println!("Subtracted {:?}\nfrom sol {:?}",shape_master[cur_shape].count,solution_arr);
        
        //okay actually find a spot for the damn thing...
        let mut found = false;
        let ((shape_y, shape_x),shape_size) = &shape_master[cur_shape].variants[0]; //fuck variants for now
        for y in 0..dimensions.0 - shape_y {
            for x in 0..dimensions.1 - shape_x{
                let slice = space_grid.slice(s![y..y+shape_y,x..x+shape_x]);
                if slice.iter().zip(shape_size.iter()).any(|(&a, &b)| (a & b) != 0) {
                    continue;
                }

                let mut viewm = space_grid.slice_mut(s![y..y+shape_y, x..x+shape_x]);
                viewm.iter_mut().zip(shape_size.iter()).for_each(|(a, &b)| *a |= b);
                found = true;
                break;
            }
            if found {
                break;
            }
        }

        if !found {
            solution_arr += &shape_master[cur_shape].count;
            cur_shape += 1;
        }
    }  

    false
}