#lang racket

(define ytdl-path "")
(define dl-dir (path->complete-path (build-path (expand-user-path "~") "video/guitube-dl/")))
(define ytdl-arguments "-o %(stitle)s_%(id)s.%(ext)s")

(define (execute-dl)
  (define (get-extension)
    (if (equal? (system-type 'os) 'windows)
        ".exe"
        ""))

  (make-directory* dl-dir)
  
  (let ([switch-dir-string (string-append "cd " (path->string dl-dir))]
        [ytdl-string (string-append ytdl-path "youtube-dl" (get-extension) " " ytdl-arguments)])
    (system switch-dir-string)
    (system ytdl-string)))