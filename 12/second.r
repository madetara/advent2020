nextState <- function(x, y, wx, wy, inp) {
    cmd <- substring(inp, 1, 1)
    val <- strtoi(substring(inp, 2, nchar(inp)))

    result <- switch(cmd,
        "N" = move_w(x, y, wx, wy, "N", val),
        "S" = move_w(x, y, wx, wy, "S", val),
        "E" = move_w(x, y, wx, wy, "E", val),
        "W" = move_w(x, y, wx, wy, "W", val),
        "F" = move_f(x, y, wx, wy, val),
        "R" = rotate_v(x, y, wx, wy, -val),
        "L" = rotate_v(x, y, wx, wy, val))

    result
}

move_w <- function(x, y, wx, wy, moveDir, val) {
    switch(moveDir,
        "N" = c(x, y, wx, wy + val),
        "S" = c(x, y, wx, wy - val),
        "E" = c(x, y, wx + val, wy),
        "W" = c(x, y, wx - val, wy))
}

move_f <- function(x, y, wx, wy, count) {
    c(x + wx * count, y + wy * count, wx, wy)
}

rotate_v <- function(x, y, wx, wy, d) {
    r <- d * (pi / 180)

    c(x, y, wx * cos(r) - wy * sin(r), wx * sin(r) + wy * cos(r))
}

fileName <- "input.txt"

x <- 0
y <- 0

wx <- 10
wy <- 1

inp <- file(fileName, "r")

for (line in readLines(inp)) {
    s <- nextState(x, y, wx, wy, line)

    x <- round(as.double(s[1]))
    y <- round(as.double(s[2]))
    wx <- round(as.double(s[3]))
    wy <- round(as.double(s[4]))
}

close(inp)

print(abs(x) + abs(y))
