import { DATA } from './input'

const DATA = `Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green`


const realAmounts = new Map([
    ['red', 12],
    ['green', 13],
    ['blue', 14]
])

const minimumAmounts = new Map([
    ['red', 0],
    ['green', 0],
    ['blue', 0]
])

const lines = DATA.split('\n')
const games = lines.map(line => {
    const [gamePart, hintsPart] = line.split(':')
    const gameId = Number(gamePart.replace('Game ', ''))

    const hints = hintsPart.split(';').map(rawHint => {
        return rawHint.split(',').map(s => s.trim().split(' '))
            .map(([rawNumber, color]) => ({ n: Number(rawNumber), color }) )
    })

    return { id: gameId, hints }
})

const minimumCubesForGames = games.map(({hints}) => {
    const minimumCubes = new Map(minimumAmounts)
    hints.forEach(hint => hint.forEach(({n, color}) => {
        minimumCubes.set(color, Math.max(minimumCubes.get(color)!, n))
    }))
    return minimumCubes
})

console.log(minimumCubesForGames)