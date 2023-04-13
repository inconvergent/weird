
(defpackage #:weird-tests (:use #:cl #:prove) (:export #:run-tests))
(in-package #:weird-tests)

(setf prove:*enable-colors* nil)

(defvar *files* `(#P"test/rnd.lisp" #P"test/math.lisp" #P"test/hset.lisp"
                  #P"test/bzspl.lisp" #P"test/graph.lisp" #P"test/weir.lisp"
                  #P"test/3weir.lisp" #P"test/weir-grp-prop.lisp"
                  #P"test/weir-with.lisp" #P"test/ortho.lisp"))

(defun run-tests ()
  (loop with fails = 0
        for f in *files*
        do (format t "~&~%starting tests in: ~a~%" (weird:mkstr f))
           (unless (prove:run f :reporter :fiveam)
                   (incf fails))
           (format t "~&done: ~a~%" (weird:mkstr f))
        finally (return (unless (< fails 1)
                          (sb-ext:quit :unix-status 7)))))

