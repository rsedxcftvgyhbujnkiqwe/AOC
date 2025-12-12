use good_lp::{constraint, lp_solve, variable, variables, Expression, Solution, SolverModel};
use std::cmp::min;

pub fn solve(input: &String) -> (i64, i64) {
    let mut silver: i64 = 0;
    let mut gold: i64 = 0;

    let length = input.len();
    let string_input = input.to_string();
    let bytes = string_input.as_bytes();

    let mut line_configs: Vec<(i16, Vec<i16>, Vec<i16>)> = Vec::new();

    let mut buttons: Vec<i16> = Vec::new();

    let mut reading_volts = false;

    let mut row = 0;
    let mut light = 0;
    let mut running = 0;
    for x in 0..length {
        let byte = bytes[x];
        match byte {
            b'0'..=b'9' => {
                running = running * 10 + (byte - b'0') as i16;
            }
            b',' => {
                if reading_volts {
                    line_configs[row].2.push(running);
                } else {
                    buttons.push(running);
                }
                running = 0;
            }
            b')' => {
                buttons.push(running);
                running = 0;

                let mut button_val = 0;

                for button in &buttons {
                    button_val |= 1 << button;
                }
                line_configs[row].1.push(button_val);

                buttons.clear();
            }
            b'{' => {
                reading_volts = true;
            }
            b'}' => {
                line_configs[row].2.push(running);
                running = 0;
                reading_volts = false;
            }
            b'[' => {
                line_configs.push((0, vec![], vec![]));
            }
            b'.' => {
                light += 1;
            }
            b'#' => {
                line_configs[row].0 |= 1 << light;
                light += 1;
            }
            b'\n' => {
                light = 0;
                row += 1;
            }
            _ => {}
        }
    }

    // println!("Volt Master: [(Volt#, [BtnID1,BtnID3..]), ]");
    // println!("Button Max: [(BtnID1, MaxPress, Affect#), ]");

    let mut max_volts = 0;
    let mut max_volt_size = 0;
    let mut max_buttons = 0;
    for cfg in &line_configs {
        let buttons = cfg.1.len();
        let volts = cfg.2.len();
        let volt_size = cfg.2.iter().max().unwrap();
        if buttons > max_buttons {
            max_buttons = buttons;
        }
        if volts > max_volts {
            max_volts = volts;
        }
        if volt_size > &max_volt_size {
            max_volt_size = *volt_size;
        }
    }

    for cfg in line_configs {
        let subsets = generate_button_subsets(&cfg.1);
        for subset in subsets {
            if subset.0 == cfg.0 {
                silver += subset.1;
                break;
            }
        }

        let size = cfg.2.len();

        let mut buttons: Vec<Vec<i16>> = Vec::new();

        for button in cfg.1 {
            let mut arr = Vec::new();
            for x in 0..size {
                if (button & 1 << x) > 0 {
                    arr.push(1)
                } else {
                    arr.push(0)
                }
            }
            buttons.push(arr);
        }

        let result = solve_system_of_equations(cfg.2, buttons);
        gold += result;
    }

    (silver, gold)
}

fn generate_button_subsets(buttons: &Vec<i16>) -> Vec<(i16, i64)> {
    let mut subsets: Vec<(i16, i64)> = Vec::new();

    let length = buttons.len();

    for i in 1..(1 << length) {
        let mut subset = (0, 0);
        for j in 0..length {
            if (i & (1 << j)) != 0 {
                subset.0 ^= buttons[j];
                subset.1 += 1;
            }
        }
        subsets.push(subset);
    }
    subsets.sort_by(|a, b| a.1.cmp(&b.1));

    subsets
}

fn solve_system_of_equations(target: Vec<i16>, buttons: Vec<Vec<i16>>) -> i64 {
    let size = target.len();
    let nbuttons = buttons.len();

    let mut button_matrix: Vec<Vec<i16>> = vec![vec![0; nbuttons + 1]; size];

    for y in 0..nbuttons {
        for x in 0..size {
            button_matrix[x][y] = buttons[y][x];
        }
    }
    for x in 0..size {
        button_matrix[x][nbuttons] = target[x];
    }
    let mut vars = variables!();

    let x_vec = vars.add_vector(variable().min(0.0).integer(), nbuttons);

    let mut objective: Expression = 0.0.into();
    for i in 0..nbuttons {
        objective = objective + x_vec[i];
    }

    let mut problem = vars.minimise(objective).using(lp_solve);

    for i in 0..size {
        let mut inequality: Expression = 0.0.into();
        for x in 0..nbuttons {
            if button_matrix[i][x] == 1 {
                inequality += x_vec[x];
            }
        }
        problem.add_constraint(constraint!(inequality == button_matrix[i][nbuttons] as f64));
    }
    let solution = problem.solve().unwrap();

    let mut total = vec![0; size];
    for y in 0..nbuttons {
        for x in 0..size {
            total[x] += buttons[y][x] * solution.value(x_vec[y]).round() as i16
        }
    }

    let mut bad_match = false;

    for i in 0..size {
        if target[i] != total[i] {
            bad_match = true;
        }
    }

    (0..nbuttons)
        .map(|i| solution.value(x_vec[i]).round() as i64)
        .sum()
}
