mod data;

use std::cmp::{max, min};
use crate::data::DATA;

fn main() {
    let input = DATA;
    let mut space = Space::from_str(input);
    space.expand_space(1_000_000);
    println!("{}", space.total_distance())
}

type Galaxy = (usize, usize);

#[derive(Debug)]
struct Space {
    cells: Vec<Vec<char>>,
    distances: Option<Vec<Vec<usize>>>,
    galaxies: Option<Vec<Galaxy>>
}


// ...#......
// .......#..
// #.........
// ..........
// ......#...
// .#........
// .........#
// ..........
// .......#..
// #...#.....

impl Space {
    pub fn from_str(input: &str) -> Space {
        let cells = input.lines().map(|l| l.chars().collect())
            .collect();
        Space { cells, galaxies: None, distances: None }
    }

    pub fn expand_space(&mut self, expansion: usize) {
        let row_len = self.cells.first().unwrap().len();
        let columns_to_expand = (0..row_len)
            .filter(|i| self.cells.iter().all(|row| row[*i] == '.'))
            .collect::<Vec<_>>();

        let rows_to_expand: Vec<_> = (0 .. self.cells.len())
            .filter(|i| self.cells[*i].iter().all(|cell| *cell == '.')).collect();

        let distances = self.cells.iter().enumerate().map(|(row_number, row)| {
            row.iter().enumerate().map(|(colum_number, cell)| {
                if columns_to_expand.contains(&colum_number) || rows_to_expand.contains(&row_number) {
                    expansion
                } else {
                    1
                }
            }).collect()
        }).collect();

        self.distances = Some(distances);
        self.calculate_galaxies();
    }

    fn calculate_galaxies(&mut self) {
        let galaxies = self.cells.iter().enumerate().flat_map(|(row_number, row)| {
            row.iter().enumerate().filter_map(|(column_number, cell)| {
                if *cell == '.' {
                    None
                } else {
                    let column_distance = self.calculate_column_distance(column_number, row_number);
                    let row_distance = self.calculate_row_distance(column_number, row_number);
                    Some((column_distance, row_distance))
                }
            }).collect::<Vec<_>>()
        }).collect();
        self.galaxies = Some(galaxies)
    }

    fn calculate_column_distance(&self, column: usize, row: usize) -> usize {
        self.distances.clone().unwrap()[..row].iter().map(|row| row[column]).sum()
    }

    fn calculate_row_distance(&self, column: usize, row: usize) -> usize {
        self.distances.clone().unwrap()[row].iter().take(column).sum()
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
        space.expand_space(2);
        println!("{}", space.total_distance())
    }

    #[test]
    fn posta () {
        let input = DATA;
        let mut space = Space::from_str(input);
        space.expand_space(2);
        println!("{}", space.total_distance())
    }

    #[test]
    fn papa () {
        let input = DATA;
        let mut space = Space::from_str(input);
        space.expand_space(1_000_000);
        println!("{}", space.total_distance())
    }
}