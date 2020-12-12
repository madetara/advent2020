nextState <- function(x, y, dir, inp) {
    cmd <- substring(inp, 1, 1)
    val <- strtoi(substring(inp, 2, nchar(inp)))

    result <- switch(cmd,
        "N" = move(x, y, "N", val, dir),
        "S" = move(x, y, "S", val, dir),
        "E" = move(x, y, "E", val, dir),
        "W" = move(x, y, "W", val, dir),
        "F" = move(x, y, dir, val, dir),
        "R" = c(x, y, rotate(val, dir)),
        "L" = c(x, y, rotate(-val, dir)))

    result
}

move <- function(x, y, moveDir, val, dir) {
    switch(moveDir,
        "N" = c(x, y + val, dir),
        "S" = c(x, y - val, dir),
        "E" = c(x + val, y, dir),
        "W" = c(x - val, y, dir))
}


fromDirection <- function(dir) {
    switch(dir,
        "N" = 0,
        "E" = 90,
        "S" = 180,
        "W" = 270)
}

toDirection <- function(deg) {
    switch((deg %/% 90) + 1,
        "N",
        "E",
        "S",
        "W")
}

rotate <- function(rotation, dir) {
    toDirection((360 + fromDirection(dir) + rotation) %% 360)
}

fileName <- "input.txt"
x <- 0
y <- 0
dir <- "E"

inp <- file(fileName, "r")

for (line in readLines(inp)) {
    s <- nextState(x, y, dir, line)
    x <- strtoi(s[1])
    y <- strtoi(s[2])
    dir <- s[3]
}

close(inp)

print(abs(x) + abs(y))
