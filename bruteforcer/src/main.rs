use std::sync::mpsc::{channel, Receiver, Sender};
use std::thread;
use std::{fs, time::Duration};

// bruteforce solver for day 13, part 2
fn main() {
    let input = "test.txt";
    let input = read_input(input);

    let thread_count = 12;

    let longest_period = input.iter().max_by_key(|f| f.1).unwrap().clone();

    let reciever = spawn(longest_period, input, thread_count);

    let result = reciever.recv().unwrap() - longest_period.0;

    println!("{}", result);
}

fn spawn(longest_period: (u64, u64), input: Vec<(u64, u64)>, thread_count: u64) -> Receiver<u64> {
    let (sender, reciever): (Sender<u64>, Receiver<u64>) = channel();

    for i in 1u64..(thread_count + 1) {
        compute(
            input.clone(),
            longest_period.0,
            longest_period.1 * i,
            longest_period.1 * thread_count,
            sender.clone(),
        );
    }

    thread::sleep(Duration::from_secs(1));

    reciever
}

fn compute(
    schedule: Vec<(u64, u64)>,
    delay: u64,
    start: u64,
    step: u64,
    s: Sender<u64>,
) -> thread::JoinHandle<()> {
    thread::spawn(move || {
        let start = start + (100_000_000_000_000 / step) * step;
        for i in (1u64..).map(|x| start + step * x) {
            if !check(&schedule, delay, i) {
                continue;
            }

            s.send(i).unwrap();
            break;
        }
        ()
    })
}

fn check(schedule: &Vec<(u64, u64)>, delay: u64, departure: u64) -> bool {
    schedule
        .iter()
        .all(|x| (departure + x.0 - delay) % x.1 == 0)
}

fn read_input(file_name: &str) -> Vec<(u64, u64)> {
    let mut result = vec![];
    let mut k: u64 = 0;

    for s in fs::read_to_string(file_name)
        .unwrap()
        .split('\n')
        .collect::<String>()
        .split(',')
    {
        match s {
            "x" => k += 1,
            s => {
                let x = s.parse::<u64>().unwrap();
                result.push((k, x));
                k += 1;
            }
        }
    }

    result
}
