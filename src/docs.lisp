
(in-package :weird)

(declaim (list *docstring-map*))
(defvar *docstring-map* (list))


(defun desc (sym)
  (declare #.*opt* (symbol sym))
  (let ((d (with-output-to-string (*standard-output*)
             (describe sym))))
    (apply #'mkstr (mapcar (lambda (s) (mkstr " ; " s #\Newline))
                           (butlast (veq::split-string #\Newline d))))))

(defun docstrings (sym)
  (apply #'mkstr
         (mapcar (lambda (o) (mkstr o #\Newline))
                 (remove-if-not #'identity (list (documentation sym 'function)
                                                 (documentation sym 'setf))))))


(defun select-docs (sym)
  (declare #.*opt* (symbol sym))
  (let* ((docs (find-if (lambda (c) (eq sym c)) *docstring-map* :key #'car))
         (idocs (docstrings sym))
         (skip (find :skip docs))
         (desc (unless (find :nodesc docs) (desc sym))))
    (declare (list docs))

    (values
      (cond (docs (format nil "```~%~a~@[~&~%~a~&~]~&```" (cadr docs) desc))
            ((and idocs (> (length idocs) 0))
              (format nil "```~%~a~@[~&~%~a~&~]~&```" idocs desc))
            (t (format nil "```~%:missing:todo:~%~@[~&~%~a~&~]~&```" desc)))
      skip)))

(defmacro pckgs (pkg)
  (awg (sym)
    `(sort (loop for ,sym being the external-symbols of (find-package ,pkg)
                 collect (list (mkstr ,sym) ,sym))
           #'string-lessp :key #'car)))


(defun -md-sanitize (d)
  (let ((sp (veq::split-string #\* d)))
    (apply #'veq::mkstr
      (concatenate 'list (mapcar (lambda (s)
                                  (veq::mkstr s #\\ #\*)) (butlast sp))
                   (last sp)))))

(defmacro ext-symbols? (pkg &optional mode)
  "list all external symbols in pkg. use :verbose to inlcude docstring.
use :pretty to print verbose output to stdout in a readable form."
  (awg (str sym doc skip)
    (case mode
      (:pretty
        `(loop for (,str ,sym) in (pckgs ,pkg)
               do (mvb (,doc ,skip) (select-docs ,sym)
                       (unless ,skip (format t "~&#### ~a:~a~%~%~a~&~%"
                                             (weird:mkstr ,pkg)
                                             (-md-sanitize ,str)
                                             ,doc)))))
      (:pairs `(loop for (,str ,sym) in (pckgs ,pkg)
                     collect (list ,str (select-docs ,sym))))
      (otherwise `(loop for (,str ,sym) in (pckgs ,pkg) collect ,str)))))

(defun map-docstring (&rest rest)
  (declare #.*opt* (list rest))
  "register docs info associated with symbol (car rest)."
  (setf *docstring-map* (remove-if (lambda (cand) (eq (car cand) (car rest)))
                                   *docstring-map*))
  (push rest *docstring-map*))

