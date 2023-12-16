import { DATA } from './entry'

const lines = DATA.split('\n')

const res = lines.map((line) => {
    const digits = line
        .split(/\D+/)
        .flatMap(ns => ns.split(''))
        .filter(a => !!a)

    return Number(digits[0] + digits[digits.length - 1])
}).filter(a => !isNaN(a))
    .reduce((a, b) => a + b, 0)

console.log(res)