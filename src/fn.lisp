
(in-package :fn)

(defun fn ()
  "generate file names using https://github.com/inconvergent/fn"
  (values (uiop:run-program (list "/usr/bin/fn")
                            :output '(:string :stripped t))))


; elem: ("20220426" "104330" "0895f00" "e9ea3593")
(defun seed (fn)
  (labels ((lst (l) (declare (list l)) (first (last l)))
           (hex (s) (write-to-string (parse-integer (string-upcase s) :radix 16))))
    (let* ((elem (weird:split (lst (weird:split fn "/")) "-"))
           (seed (parse-integer ; date proc git
                   (weird:mkstr (first elem) (hex (fourth elem)) (hex (third elem))))))
      (format t "~&seed: ~a~%" seed)
      (rnd:set-rnd-state seed)
      (values fn seed))))

