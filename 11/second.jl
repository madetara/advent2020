function readMap(fileName)
    result = Dict()
    i, j = 0, 0

    for line in eachline(fileName)
        j = 0
        for c in line
            result[(i, j)] = c
            j += 1
        end
        i += 1
    end

    result
end

function nextState(stateMap, i, j)
    current = stateMap[(i, j)]

    if (current == '.')
        return '.'
    end

    neighbours = countNeighbours(stateMap, i, j)

    if (neighbours == 0 && current == 'L')
        return '#'
    end

    if (current == '#' && neighbours >= 5)
        return 'L'
    end

    return current
end

function countNeighbours(stateMap, i, j)
    result = 0

    for (dx, dy) in [(1, 1), (1, 0), (1, -1), (0, 1), (0, -1), (-1, 1), (-1, 0), (-1, -1)]
        ii, jj = i, j
        while (true)
            val = get(stateMap, (ii + dx, jj + dy), 'x')

            ii += dx
            jj += dy

            if (val == '#')
                result += 1
                break
            end

            if (val == 'x' || val == 'L')
                break
            end
        end
    end

    result
end

function solve(fileName)
    seatMap = readMap(fileName)
    while (true)
        newState = Dict()

        stateChanges = 0

        for ((i, j), value) in pairs(seatMap)
            newState[(i, j)] = nextState(seatMap, i, j)
            if (seatMap[(i, j)] != newState[(i, j)])
                stateChanges += 1
            end
        end

        seatMap = newState

        if (stateChanges == 0)
            break;
        end
    end

    count(c->(c == '#'), values(seatMap))
end

const fileName = "input.txt"
println(solve(fileName))
