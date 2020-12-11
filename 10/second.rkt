#lang racket

;;; recursion goes brrrr
(define (count-combinations current elems terminator)
    (if (= current terminator)
        1
        (if (not (set-member? elems current))
            0
            (+
                (count-combinations (+ current 1) elems terminator)
                (count-combinations (+ current 2) elems terminator)
                (count-combinations (+ current 3) elems terminator)))))

(define (get-or-0 map k)
    (if (hash-has-key? map k)
        (hash-ref map k)
        0))

(define (climb-ladder step ladder)
        (hash-set
            ladder
            step
            (+
                (get-or-0 ladder (- step 1))
                (get-or-0 ladder (- step 2))
                (get-or-0 ladder (- step 3)))))

(define (count-combinations-smart adapters)
    (let ([sorted (sort adapters <)])
        (let ([terminator (last sorted)])
            (hash-ref
                (foldl climb-ladder (hash 0 1) (append sorted (list terminator)))
                terminator)))))

(define (solve-dumb file)
    (let ([input (map string->number (file->lines file))])
        (let ([elems (list->set input)])
            (count-combinations 0 (set-add elems 0) (+ (last (sort input <)) 3)))))

(define (solve-smart file)
    (let ([input (map string->number (file->lines file))])
        (count-combinations-smart input)))

(display (solve-smart "input.txt"))
(display "\n")
