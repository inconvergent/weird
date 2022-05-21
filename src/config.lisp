;;; These are configuration settings for the project.
;;;
;;; These settings aren't particularly friendly to projects more
;;; broadly as they're not "self contained."

(in-package #:weird)

(setf *random-state* (make-random-state t)
      *print-pretty* t )

(declaim (single-float *eps*) (boolean *dev*) (cons *opt*))
(defparameter *eps* veq::*eps*)


; from: http://cl-cookbook.sourceforge.net/os.html
(defun vgetenv (name &optional default)
  #+CMU (let ((x (assoc name ext:*environment-list* :test #'string=)))
          (if x (cdr x) default))
  #-CMU (or #+Allegro (sys:getenv name)
            #+CLISP (ext:getenv name)
            #+ECL (si:getenv name)
            #+SBCL (sb-unix::posix-getenv name)
            #+LISPWORKS (lispworks:environment-variable name)
            default))

(if (> (length (string-downcase (vgetenv "DEV" ""))) 0)
  (progn
    (defparameter *dev* t)
    (defparameter *opt* '(optimize safety (speed 1) debug (space 2)))
    (format t "~&---------!!!!! WEIRD DEVMODE !!!!!---------~%"))
  (progn
    (defparameter *dev* nil)
    (defparameter *opt* '(optimize (safety 1) speed (debug 2) space))))

