#lang racket/gui

(require "system-interaction.rkt")

(define top-frame
  (new frame%
       [label "guitube-dl"]))

(define (event-type-equal? event type)
  (equal? (send event get-event-type) type))

(define url-field
  (new text-field%
       [parent top-frame]
       [label "URL:"]
       [min-width 500]
       [callback (lambda (tf e)
                   (when (event-type-equal? e 'text-field-enter)
                     (execute-dl (send tf get-value))))]))

(define fetch-panel
  (new horizontal-panel%
       [parent top-frame]
       [alignment '(center top)]))

(define fetch-button
  (new button%
       [parent fetch-panel]
       [label "Fetch"]
       [min-width 150]
       [callback (lambda (b e)
                   (when (event-type-equal? e 'button)
                     (execute-dl (send url-field get-value))))]))

(send top-frame show #t)