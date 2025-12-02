use std::{collections::HashSet,fs::read_to_string};

fn main() {
    let raw_input = read_to_string("day2/input/bigboy.txt").unwrap();
	let input = raw_input.trim();

	let mut silver: i64 = 0;
	let mut gold: i64 = 0;
	// silver seeds (up to 18 digits)
	let mut silver_seed: Vec<i64> = Vec::new();
	for i in 0..18 {
		if i == 0 || i%2==1 {
			silver_seed.push(0);
			continue;
		}
		let factor = 10_i64.pow(i/2) + 1;
		silver_seed.push(factor);
	}
	// gold seeds (up to 18 digits)
	let mut gold_seed: Vec<Vec<i64>> = Vec::new();
	for i in 0..18 {
		let mut num_vals: Vec<i64> = Vec::new();
		num_vals.push((10_i64.pow(i)-1)/9);

		let mut factors: HashSet<i32> = HashSet::new();
		let mut tmp: i32 = i as i32;
		let sqrt = tmp.isqrt();
		let mut cur: i32 = 3;
		if tmp > 3 {
			loop {
				if tmp % 2 == 0 {
					factors.insert(2);
					tmp = tmp / 2;
				} else {
					if tmp % cur == 0 {
						factors.insert(cur);
						tmp = tmp / cur;
					} else {
						cur += 1;
					}
				}
				if cur > sqrt {
					if tmp > 1 && tmp != i as i32{
						factors.insert(tmp);
					}
					break;
				}
			}
		}

		for factor in factors {
			let mut constructed_val: i64 = 0;
			let num_zeroes: i32 = (i as i32)/factor;
			for x in 0..factor {
				constructed_val += 10_i64.pow((x*num_zeroes) as u32);
			}
			num_vals.push(constructed_val);
		}
		gold_seed.push(num_vals);
	}

	let input_iter: Vec<&str> = input.split(",").collect();
	for range in input_iter {
		let range_vals: Vec<&str> = range.split("-").collect();
		let mut left = range_vals[0].parse::<i64>().unwrap();
		let right = range_vals[1].parse::<i64>().unwrap();

		if left < 11 {
			if right < 11 {
				continue;
			}
			left = 11;
		};

		for num in left..=right {
			if is_invalid_silver(num,&silver_seed) {
				silver += num;
			}
			if is_invalid_gold(num,&gold_seed) {
				gold += num;
			}
		}
	}
	println!("Silver: {silver}\nGold: {gold}");
}

fn is_invalid_silver(x: i64, seeds: &Vec<i64>) -> bool {
	let x_f64 = x as f64;
	let num_digits = x_f64.log(10.0).floor() as i32 + 1;
	if num_digits%2==1 {
		return false;
	}
	let factor = seeds[num_digits as usize];
	x%factor==0
}

fn is_invalid_gold(x: i64, seeds: &Vec<Vec<i64>>) -> bool {
	let x_f64 = x as f64;
	let num_digits = x_f64.log(10.0).floor() as i32 + 1;

	let factors = &seeds[num_digits as usize];
	for factor in factors {
		if x%factor== 0 {
			return true;
		}
	};
	return false;
}