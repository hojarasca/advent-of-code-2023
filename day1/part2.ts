import { DATA } from './entry'

// const DATA = `two1nine
// eightwothree
// abcone2threexyz
// xtwone3four
// 4nineeightseven2
// zoneight234
// 7pqrstsixteen`

const lines = DATA.split('\n')

const res = lines.map((line) => {
    const digits = line
        .replaceAll('one', 'one1one')
        .replaceAll('two', 'two2two')
        .replaceAll('three', 'three3three')
        .replaceAll('four', 'four4four')
        .replaceAll('five', 'five5five')
        .replaceAll('six', 'six6six')
        .replaceAll('seven', 'seven7seven')
        .replaceAll('eight', 'eight8eight')
        .replaceAll('nine', 'nine9nine')
        .replaceAll('zero', 'zero0zero')
        .split(/\D+/)
        .flatMap(ns => ns.split(''))
        .filter(a => !!a)

    return Number(digits[0] + digits[digits.length - 1])
}).filter(a => !isNaN(a))
    .reduce((a, b) => a + b, 0)

console.log(res)
// res.forEach((a) => console.log(a))