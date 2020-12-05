(ns advent
    (:gen-class))

(defn pow
    "Raises integer to the power of second integer"
    ([a b]
        (reduce * (repeat b a))))

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

(defn solve
    "Solves part 1 of AOC 2020 day 5"
    ([filename]
        (with-open [rdr (clojure.java.io/reader filename)]
            (apply max (doall (map get-id (line-seq rdr)))))))

(println (solve "input.txt"))
