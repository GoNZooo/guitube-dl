#lang racket

(provide define+test
         +test)

(require (for-syntax racket/syntax))
(require rackunit)

;;; Macro for defining tests as a part of defines
;; Do note that the macro does not currently work inside
;; function definitions as it needs to work in the
;; top level scope to be able to (module+ test)
(define-syntax (define+test stx)
  (syntax-case stx ()
    [(_ (func-name parameters ...)
        ((test-input desired-result) ...)
        body ...)
     #'(begin
         (define (func-name parameters ...)
           body ...)
         (module+ test
           (check-equal? test-input desired-result) ...))]))

;;; Macro for expanding tests, separate of definitions
(define-syntax (+test stx)
  (syntax-case stx ()
    [(_ (test-input desired-result) ...)
     #'(begin
         (module+ test
           (check-equal? test-input desired-result) ...))]))

;;; Usage examples
(define+test (cubic x)
  (((cubic 2) 8)
   ((cubic 3) 27)
   ((cubic 4) 64))
  (expt x 3))

(define+test (insert-rambo input-list)
  (((insert-rambo '(jungle now contains))
    '(jungle now contains rambo))
   ((insert-rambo '(nothing is impossible for))
    '(nothing is impossible for rambo))
   ((insert-rambo '(john))
    '(john rambo)))
  (append input-list '(rambo)))

(define (add2 x)
  (+ x 2))

(+test ((add2 5) 7)
       ((add2 2) 4)
       ((add2 1) 3))