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
type Part = {
    n: number
}
const allParts = new Map<string, Part>()

lines.forEach((line, y) => {
    const possiblePartNumber = [...line.matchAll(new RegExp('\\d+', 'gi'))]
        .map(a => ({ startIndex: a.index!, number: Number(a[0]), finalIndex: a[0].length + a.index! - 1 }));
    possiblePartNumber.forEach(({ startIndex, number, finalIndex }) => {
        let obj = { n: number };
        for (let x = startIndex; x <= finalIndex; x++) {
            allParts.set(`${x}-${y}`, obj)
        }
    })
})

console.log(
    lines.flatMap((line, y) => {
        return line.split('').map((char, x) => {
            if (char === '*') {
                const deltas = [-1, 0, 1]
                const posiciones = deltas.flatMap(dx => deltas.map(dy => [dx + x,dy + y]))
                const nums = new Set(posiciones
                    .map(([x, y]) => allParts.get(`${x}-${y}`))
                    .filter(a => a) as Part[])
                if (nums.size === 2) return [...nums].map(n => n.n).reduce((a, b) => a * b, 1)
            }
            return 0
        })
    }).reduce((a, b) => a + b, 0)
)
