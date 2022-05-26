;;; These are configuration settings for the project.
;;;
;;; These settings aren't particularly friendly to projects more
;;; broadly as they're not "self contained."

(in-package #:weird)

(setf *random-state* (make-random-state t)
      *print-pretty* t )

(declaim (single-float *eps*) (boolean *dev*) (cons *opt*))
(defparameter *eps* veq::*eps*)

(init-config (optimize safety (speed 1) debug (space 2))
             (optimize (safety 1) (speed 3) debug space))

