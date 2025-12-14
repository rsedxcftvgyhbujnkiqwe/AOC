use std::collections::{HashMap, HashSet};

pub fn solve(input: &String) -> i64 {
    //gold involves using manually updated input data
    let mut silver: i64 = 0;

    let length = input.len();
    let bytes = input.as_str().as_bytes();

    let mut connections: HashMap<String, Vec<String>> = HashMap::new();

    let mut wire_key: String = String::new();
    let mut wire_connections: Vec<String> = vec![];

    let mut key = true;
    let mut working = String::new();

    for x in 0..length {
        let byte = bytes[x];
        match byte {
            b'a'..=b'z' => {
                working.push(byte as char);
            }
            b' ' => {
                if key {
                    wire_key = working.clone();
                } else {
                    wire_connections.push(working.clone());
                }
                working.clear();
                key = false;
            }
            b'\n' => {
                key = true;
                wire_connections.push(working.clone());
                working.clear();
                connections.insert(wire_key.clone(), wire_connections.clone());
                wire_key.clear();
                wire_connections.clear();
            }
            _ => {}
        }
    }

    let mut path_cache: HashSet<String> = HashSet::new();
    let mut path_count_cache: HashMap<String, i64> = HashMap::new();
    path_count_cache.insert("out".to_string(), 1);
    // change to OUT if gold
    silver += count_paths("svr", &connections, &mut path_count_cache, &mut path_cache);
    println!("{:?}", path_count_cache);

    silver
}

fn count_paths(
    key: &str,
    connection_map: &HashMap<String, Vec<String>>,
    count_cache: &mut HashMap<String, i64>,
    path_cache: &mut HashSet<String>,
) -> i64 {
    if path_cache.contains(key) {
        return 0;
    }
    match count_cache.get(key) {
        Some(value) => *value,
        None => {
            let mut sum: i64 = 0;
            match connection_map.get(key) {
                Some(children) => {
                    path_cache.insert(key.to_string());
                    for child in children {
                        let retval = count_paths(child, connection_map, count_cache, path_cache);
                        sum += retval;
                    }
                    path_cache.remove(key);
                }
                None => {}
            };
            count_cache.insert(key.to_string(), sum);
            sum
        }
    }
}
