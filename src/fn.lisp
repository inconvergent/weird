
(in-package :fn)

(defun fn ()
  "generate file names using https://github.com/inconvergent/fn"
  (values
    (uiop:run-program (list "/usr/bin/fn")
                      :output '(:string :stripped t))))

