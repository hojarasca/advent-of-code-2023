import {DATA} from './entry'

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

function range(n: number): number[] {
    return Array(n).fill(0).map((_x,i)=>i)
}

function findFirstTokenWithOrder(line: string, indexList: number[]) {
    for (const i of indexList) {
        const subLine = line.substring(i);
        const foundToken = tokens.find(token => subLine.startsWith(token));
        if (foundToken) return translations.get(foundToken) ?? foundToken;
    }

    return '';
}

function firstTokenOf(line: string) {
    return findFirstTokenWithOrder(line, range(line.length));
}

function lastTokenOf(line: string) {
    return findFirstTokenWithOrder(line, range(line.length).reverse())
}

const res = lines.map((line) => {
    return Number(firstTokenOf(line) + lastTokenOf(line))
}).reduce((a, b) => a + b, 0)

console.log(res)
