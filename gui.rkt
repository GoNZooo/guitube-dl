#lang racket/gui

(require "system-interaction.rkt")

(define (fetch-url component event)
  (cond
   [(event-type-equal? event 'text-field-enter) (download (get-component-value component))]
   [(event-type-equal? event 'button) (download (get-component-value url-field))]))

(define top-frame
  (new frame%
       [label "guitube-dl"]))

(define (event-type-equal? event type)
  (equal? (send event get-event-type) type))

(define (get-component-value component)
  (send component get-value))

(define url-field
  (new text-field%
       [parent top-frame]
       [label "URL:"]
       [min-width 500]
       [callback fetch-url]))

(define fetch-panel
  (new horizontal-panel%
       [parent top-frame]
       [alignment '(center top)]))

(define fetch-button
  (new button%
       [parent fetch-panel]
       [label "Fetch"]
       [min-width 150]
       [callback fetch-url]))

(send top-frame show #t)