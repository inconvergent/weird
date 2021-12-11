(load "~/quicklisp/setup.lisp")

; (setf asdf:*asdf-verbose* t)
; ; set the path to the folder containing weir.asd:
; #+quicklisp (push "~/x/veq" ql:*local-project-directories*)
; #+quicklisp (push "~/x/weird" ql:*local-project-directories*)
; (print ql:*local-project-directories*)
; (ql:quickload :weird :silent nil)


; (with-open-stream (*standard-output* (make-broadcast-stream))
;   (with-open-stream (*error-output* (make-broadcast-stream))
;     (ql:quickload :asdf)
;     (asdf:load-asd "/home/anders/x/weir/weir.asd")
;     (asdf:load-system :weir)))


(ql:quickload :asdf)
(asdf:load-asd "/home/anders/x/veq/veq.asd")
(asdf:load-asd "/home/anders/x/weird/weird.asd")
(ql:quickload :weird)


; (asdf:load-asd "/home/anders/x/veq/veq.asd")
; (asdf:load-system :veq)
; (asdf:load-asd "/home/anders/x/weird/weird.asd")
; (asdf:load-system :weird)

