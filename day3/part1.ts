import { DATA } from './input'

// const DATA = `467..114..
// ...*......
// ..35..633.
// ......#...
// 617*......
// .....+.58.
// ..592.....
// ......755.
// ...$.*....
// .664.598..`

const lines = DATA.split('\n')
const matrix = lines.map(l => l.split(''))
const numbers = []

const partNumbers = lines.flatMap((line, y) => {
    const possiblePartNumber = [...line.matchAll(new RegExp('\\d+', 'gi'))]
        .map(a => ({ startIndex: a.index!, number: Number(a[0]), finalIndex: a[0].length + a.index! - 1 }));

    return possiblePartNumber.filter(number =>
        [-1, 0, 1].map(diff =>
            (lines[y + diff] ?? '').substring(number.startIndex - 1, number.finalIndex + 1 + 1)
        )
            .join('')
            .split('')
            .some(c => !'1234567890.'.includes(c)))
})


console.log(partNumbers.map(p => p.number).reduce((a, b) => a + b, 0))


