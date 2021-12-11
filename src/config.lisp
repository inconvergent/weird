;;; These are configuration settings for the project.
;;;
;;; These settings aren't particularly friendly to projects more
;;; broadly as they're not "self contained."

(in-package #:weird)

(setf *random-state* (make-random-state t))
(setf *print-pretty* t)


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

(let ((devmode (string-downcase (vgetenv "DEV" ""))))
  (if (> (length devmode) 0)
    (progn
      (defparameter *opt* '(optimize (safety 2) (speed 1) debug (space 1)
                                     compilation-speed))
      (format t "~%!!!!! WEIRD DEVMODE !!!!!~%~%"))
    (defparameter *opt* '(optimize (safety 1) speed (debug 2) space))))


