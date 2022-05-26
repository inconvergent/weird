
(in-package :weird)

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

(defmacro init-config (dev-vals vals)
  (if (> (length (string-downcase (vgetenv "DEV" ""))) 0)
    `(progn (defvar *dev* t)
            (defvar *opt* ',dev-vals)
            (format t "~&---------!!!!! WEIRD COMPILED IN DEVMODE !!!!!---------
--------- ~a~%" ',dev-vals))
    `(progn (defvar *dev* nil)
            (defvar *opt* ',vals))))
