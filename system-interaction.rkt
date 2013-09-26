#lang racket

(provide execute-dl)

(define ytdl-path "")
(define dl-dir (path->complete-path (build-path (expand-user-path "~")

(define (build-template template-list [output-template ""])

  (define (evaluate-keyword keyword)
    (case keyword
      [(stitle title) "%\\(title\\)s"]
      [(id) "%\\(id\\)s"]
      [(url) "%\\(url\\)s"]
      [(ext extension) "%\\(ext\\)s"]
      [(epoch) "%\\(epoch\\)s"]
      [else keyword]))
  
  (if (null? template-list)
      output-template
      (build-template (rest template-list) (string-append output-template (evaluate-keyword (first template-list))))))

(define ytdl-arguments (string-append "-o" " " (build-template '(title "_" id "." extension))))

(define (execute-dl youtube-url)
  (define (get-extension)
    (if (equal? (system-type 'os) 'windows)
        ".exe"
        ""))

  (define (switch-directory dir-string)
    (current-directory dir-string))

  (define (call-youtube-dl)
    (system (string-append ytdl-path "youtube-dl" " " ytdl-arguments " " youtube-url)))
  
  (make-directory* dl-dir)
  (switch-directory dl-dir)
  (call-youtube-dl))

(module+ main
  (execute-dl "https://www.youtube.com/watch?v=It4WxQ6dnn0"))