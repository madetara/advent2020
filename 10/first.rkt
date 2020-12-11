#lang racket

(define (delta-count in out)
    (if (= (- (cdr in) (car in)) 3)
        (cons (car out) (+ (cdr out) 1))
        (cons (+ (car out) 1) (cdr out))))

(define (solve file)
    (let ([jolts
        (let ([input
            (sort (map string->number (file->lines file)) <)])
                (foldr
                    delta-count
                    (cons 0 0)
                    (map cons (list* 0 input) (append input (list (+ (last input) 3))))))])
        (* (car jolts) (cdr jolts))))

(display (solve "input.txt"))
(display "\n")
