#lang racket

(require "define-test.rkt")

(provide download)

(define (get-default-ytdl-name)
  (if (equal? (system-type 'os) 'windows)
      "youtube-dl.exe"
      "youtube-dl"))

(define ytdl-path (get-default-ytdl-name))

(define dl-dir (path->complete-path (build-path (expand-user-path "~"))))

(define+test (build-template template-list [output-template ""])
  (((build-template '(title "_" id "." ext)) "%\\(title\\)s_%\\(id\\)s.%\\(ext\\)s")
   ((build-template '(title " " url "." ext)) "%\\(title\\)s %\\(url\\)s.%\\(ext\\)s"))

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

(define ytdl-arguments (string-append " -o " (build-template '(title "_" id "." extension)) " "))

(define (download youtube-url)
  
  (define (get-extension)
    (if (equal? (system-type 'os) 'windows)
        ".exe"
        ""))

  (define (execute-youtube-dl)
    (system (string-append ytdl-path ytdl-arguments youtube-url)))
  
  (make-directory* dl-dir)
  (current-directory dl-dir)
  (execute-youtube-dl))

(module+ main
  (download "https://www.youtube.com/watch?v=It4WxQ6dnn0"))