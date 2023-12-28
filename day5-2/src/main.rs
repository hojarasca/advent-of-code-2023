#![feature(iter_array_chunks)]

mod data;

use std::ops::Range;
// use data::DATA_TEST as DATA;
use data::DATA_PROD as DATA;



fn main() {
    let lines = DATA.split("\n\n").collect::<Vec<&str>>();
    let [seeds, lines @ ..] = &lines[..] else { todo!() };

    let seeds = create_seeds(seeds);

    let mapping = lines.iter()
        .map(|l| Mapping::from_lines(l))
        .rev()
        .collect::<Vec<_>>();

    let mut i: isize = 0;

    loop {
        let seed = mapping.iter().fold(i, |number, mapping| {
            mapping.map_value(number)
        });

        if seeds.iter().any(|range| range.contains(&seed)) {
            break
        }
        i += 1;
    }

    println!("{:?}", &i);
}

fn create_seeds(seeds: &str) -> Vec<Range<isize>> {
    let seed_data = seeds.split(" ")
        .skip(1)
        .map(|a| a.parse::<isize>().unwrap())
        .array_chunks()
        .collect::<Vec<[isize; 2]>>();

    let seeds = seed_data.iter().map(|[start, size]| {
        *start..*start + *size
    }).collect::<Vec<_>>();
    seeds
}

#[derive(Debug)]
struct Mapping {
    rules: Vec<MappingRule>
}

impl Mapping {
    pub fn new (rules: Vec<MappingRule>) -> Mapping {
        Mapping { rules }
    }

    pub fn from_lines(lines: &str) -> Mapping {
        let rules = lines.split('\n').skip(1).map(|line| {
            let numbers: Vec<_> = line.split(' ').map(|str| str.parse::<isize>().unwrap()).collect();
            MappingRule::new(numbers[0], numbers[1], numbers[2])
        }).collect::<Vec<_>>();
        Mapping::new(rules)
    }

    pub fn map_value(&self, from: isize) -> isize {
        let value = self.rules.iter()
            .map(|rule| rule.translate(from))
            .reduce(|opt_a, opt_b| opt_a.or(opt_b)).flatten().unwrap_or(from);
        value
    }
}

#[derive(Debug)]
struct MappingRule {
    from: Range<isize>,
    to: isize,
}

impl MappingRule {
    pub fn new(from: isize, to: isize, size: isize) -> MappingRule {
        MappingRule { from: from.. from + size, to }
    }

    pub fn translate(&self, number: isize) -> Option<isize> {
        if self.from.contains(&number) {
            Some(self.to + number - self.from.start)
        } else {
            None
        }
    }
}