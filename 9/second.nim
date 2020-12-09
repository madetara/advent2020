import strutils, sequtils, sets

proc is_sum(summands: seq[int], sum: int): bool =
    let summands = toHashSet(summands)

    for summand in summands:
        let delta = sum - summand
        if delta in summands and 2 * delta != sum:
            return true

    false

proc solve_first(input: seq[int], preambleLen: int): int =
    for i, x in input[preambleLen..^1]:
        let preamble = input[i..(i + preambleLen - 1)]

        if not is_sum(preamble, x):
            return x

proc solve_second(input: seq[int], supposed_sum: int): int =
    let n = input.len()

    for i in 0..(n - 1):
        for j in i..(n - 1):
            let window = input[i..j]
            if foldl(window, a + b) == supposed_sum:
                return max(window) + min(window)


const fileName = "input.txt"
const preambleLen = 25;

let input = readFile(fileName)
    .strip()
    .splitLines()
    .map(parseInt)

echo solve_second(input, solve_first(input, preambleLen))
