import strutils, sequtils, sets

proc is_sum(summands: seq[int], sum: int): bool =
    let summands = toHashSet(summands)

    for summand in summands:
        let delta = sum - summand
        if delta in summands and 2 * delta != sum:
            return true

    false

const fileName = "input.txt"
const preambleLen = 25;

let input = readFile(fileName)
    .strip()
    .splitLines()
    .map(parseInt)

for i, x in input[preambleLen..^1]:
    let preamble = input[i..(i + preambleLen - 1)]

    if not is_sum(preamble, x):
        echo x
        break
