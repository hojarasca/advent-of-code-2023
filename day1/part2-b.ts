import { DATA } from './entry'

// const DATA = `two1nine
// eightwothree
// abcone2threexyz
// xtwone3four
// 4nineeightseven2
// zoneight234
// 7pqrstsixteen`

// const DATA = `9167ddtxjpxb6`

const tokens = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine'
]

const translations = new Map(
    [
        ['zero', '0'],
        ['one', '1'],
        ['two', '2'],
        ['three', '3'],
        ['four', '4'],
        ['five', '5'],
        ['six', '6'],
        ['seven', '7'],
        ['eight', '8'],
        ['nine', '9'],
    ]
)


const lines = DATA.split('\n')

const res = lines.map((// const DATA = `two1nine
// eightwothree
// abcone2threexyz
// xtwone3four
// 4nineeightseven2
// zoneight234
// 7pqrstsixteen`
line) => {
    const indexes = tokens.flatMap(token => {
        const foundIndexes = [...line.matchAll(new RegExp(token, 'gi'))].map(a => Number(a.index))
        return foundIndexes.map(index => ({token: translations.get(token)??token, index}))
    }).filter(obj => obj.index >= 0)

    const min = indexes
        .reduce((current, min) => current.index < min.index ? current : min, { index: Infinity, token: ' ' })
    const max = indexes
        .reduce((current, min) => current.index > min.index ? current : min, { index: -Infinity, token: ' ' })
    return Number(min.token + max.token)
})
    .reduce((a, b) => a + b, 0)

console.log(res)

// res.forEach(a => console.log(a))