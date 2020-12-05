(ns advent
    (:gen-class))

(defn pow
    "Raises integer to the power of second integer"
    ([a b]
        (reduce * (repeat b a))))

(defn abs
    ([x]
        (if (< x 0) (- x) x)))

(defn c-to-binary
    "Convert char to binary"
    ([c]
        (case c
            \B 1
            \F 0
            \R 1
            \L 0
            -1)))

(defn to-binary
    "Convert string to binary representation"
    ([s]
        (map c-to-binary (seq s))))

(defn from-binary
    "From binary system to decimal"
    ([b]
        (reduce + (map-indexed (fn [idx itm] (* itm (pow 2 idx))) (reverse b)))))

(defn get-id
    "Gets seat id from it's text representation"
    ([s]
        (let [
            bin (to-binary s)
            row (take 7 bin)
            seat (drop 7 bin)]
            (+ (* 8 (from-binary row)) (from-binary seat)))))

(defn cartesian
    "Returns cartesian product of two collections"
    ([coll1 coll2]
        (mapcat (fn [a] (map (fn [b] [a, b]) coll2)) coll1)))

(defn readIds
    "Read seat ids from file"
    ([filename]
        (with-open [rdr (clojure.java.io/reader filename)]
            (doall (map get-id (line-seq rdr))))))

(defn solve
    "Solves part 2 of AOC 2020 day 5"
    ([filename]
        (let [
            ids (readIds filename)
            possibleSeats (set (map
                (fn [p] (/ (+ (first p) (second p)) 2))
                (filter (fn [x] (== (abs (- (first x) (second x))) 2)) (cartesian ids ids))))
        ]
        (first (filter (fn [x] (not (some #{x} (set ids)))) possibleSeats)))))

(println (solve "input.txt"))
