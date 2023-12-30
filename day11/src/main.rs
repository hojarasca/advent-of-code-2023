mod data;

use std::cmp::{max, min};

fn main() {
    println!("Hello, world!");
}

type Galaxy = (usize, usize);

#[derive(Debug)]
struct Space {
    cells: Vec<Vec<char>>,
    galaxies: Option<Vec<Galaxy>>
}

impl Space {
    pub fn from_str(input: &str) -> Space {
        let cells = input.lines().map(|l| l.chars().collect())
            .collect();
        Space { cells, galaxies: None }
    }

    pub fn expand_space(&mut self) {
        let new_cells: Vec<_> = self.cells.iter().flat_map(|row| {
           if row.iter().all(|cell| *cell == '.') {
               vec![row, row]
           } else {
               vec![row]
           }
        }).cloned().map(|a| a).collect();

        let row_len = self.cells.first().unwrap().len();

        let columns_to_expand = (0..row_len)
            .filter(|i| self.cells.iter().all(|row| row[*i] == '.'))
            .collect::<Vec<_>>();

        let new_cells = new_cells.iter().map(|row| {
            row.iter().enumerate().flat_map(|(index, cell)| {
                if columns_to_expand.contains(&index) {
                    vec![cell, cell]
                } else {
                    vec![cell]
                }
            }).cloned().collect()
        }).collect();

        self.cells = new_cells;
        self.calculate_galaxies();
    }

    fn calculate_galaxies(&mut self) {
        let galaxies = self.cells.iter().enumerate().flat_map(|(row_number, row)| {
            row.iter().enumerate().filter_map(|(column_number, cell)| {
                if *cell == '.' {
                    None
                } else {
                    Some((column_number, row_number))
                }
            }).collect::<Vec<_>>()
        }).collect();
        self.galaxies = Some(galaxies)
    }

    pub fn combinations(&self) -> Vec<(Galaxy, Galaxy)> {
        let vec = self.galaxies.clone().unwrap();
        let head = vec.first().unwrap().clone();
        let tail = &vec[1..];
        return Self::combinations_inter(head, tail);
    }

    pub fn combinations_inter(galaxy: Galaxy, rest: &[Galaxy]) -> Vec<(Galaxy, Galaxy)> {
        if rest.is_empty() {
            return vec![]
        }
        let mut this_combinations = rest.iter().map(|g| (galaxy, g.clone())).collect::<Vec<_>>();
        let head = rest.first().unwrap().clone();
        let tail = &rest[1..];
        let mut coso = Self::combinations_inter(head, tail);
        this_combinations.append(&mut coso);
        return this_combinations
    }

    pub fn total_distance(&self) -> usize {
        let combinations = self.combinations();
        combinations.iter().map(|((g1_x, g1_y), (g2_x, g2_y))| {
            let x_max = max(g1_x, g2_x);
            let x_min = min(g1_x, g2_x);
            let y_max = max(g1_y, g2_y);
            let y_min = min(g1_y, g2_y);
            ( x_max - x_min) + (y_max - y_min)
        }).sum()
    }

    #[allow(dead_code)]
    pub fn pretty_print(&self) {
        println!("{:?}", &self.galaxies);
        self.cells.iter().for_each(|row| println!("{}", String::from_iter(row)))
    }
}

#[cfg(test)]
mod tests {
    use crate::data::{DATA, TEST_1};
    use crate::Space;

    #[test]
    fn case1() {
        let input = TEST_1;
        let mut space = Space::from_str(input);
        space.expand_space();
        println!("{}", space.total_distance())
    }

    #[test]
    fn posta () {
        let input = DATA;
        let mut space = Space::from_str(input);
        space.expand_space();
        println!("{}", space.total_distance())
    }
}