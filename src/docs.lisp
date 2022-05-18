
; (in-package :weird)

; (declaim (list *docstring-map*))
; (defvar *docstring-map* (list))


; ; (defmacro context? ()
; ;   "list all macrolets in veq context. that is ops available inside vprog,
; ;   fvprogn, vdef, fvdef defined contexts/functions."
; ;   (awg (s)
; ;     `(list (sort (mapcar (lambda (,s) (describe (list ,s)) (mkstr (car ,s)))
; ;                          *symbols-map*)
; ;                  #'string-lessp))))

; (defun desc (sym)
;   (declare #.*opt* (symbol sym))
;   (let ((d (with-output-to-string (*standard-output*)
;              (describe sym))))
;     (apply #'mkstr (mapcar (lambda (s) (mkstr " ; " s #\Newline))
;                            (butlast (str:split #\Newline d))))))

; (defun docstrings (sym)
;   (apply #'mkstr
;          (mapcar (lambda (o) (mkstr o #\Newline))
;                  (remove-if-not #'identity (list (documentation sym 'function)
;                                                  (documentation sym 'setf))))))


; (defun select-docs (sym)
;   (declare #.*opt* (symbol sym))
;   (let* ((docs (find-if (lambda (c) (eq sym c)) *docstring-map* :key #'car))
;          (idocs (docstrings sym))
;          (skip (find :skip docs))
;          (context (find :context docs))
;          (desc (unless (find :nodesc docs) (desc sym))))
;     (declare (list docs))

;     (values
;       (cond (docs (format nil "```~%~a~@[~&~%~a~&~]~&```" (cadr docs) desc))
;             ((and idocs (> (length idocs) 0))
;               (format nil "```~%~a~@[~&~%~a~&~]~&```" idocs desc))
;             (t (format nil "```~%:missing:todo:~%~@[~&~%~a~&~]~&```" desc)))
;       skip context)))

; (defmacro pckgs ()
;   (awg (sym)
;     `(sort (loop for ,sym being the external-symbols of (find-package :veq)
;                  collect (list (mkstr ,sym) ,sym))
;            #'string-lessp :key #'car)))

; (defmacro ext-symbols? (&optional mode)
;   "list all external symbols in veq. use :verbose to inlcude docstring.  use
;   :pretty to print verbose output to stdout in a readable form."
;   (awg (str sym doc skip context)
;     (case mode
;       (:pretty
;         `(loop for (,str ,sym) in (pckgs)
;                do (mvb (,doc ,skip ,context) (select-docs ,sym)
;                        (unless ,skip (format t "~&#### ~:[~;:context: ~]~a~%~%~a~&~%"
;                                              ,context
;                                              (str:replace-all "\*" "\\*" ,str)
;                                              ,doc)))))
;       (:pairs `(loop for (,str ,sym) in (pckgs)
;                      collect (list ,str (select-docs ,sym))))
;       (otherwise `(loop for (,str ,sym) in (pckgs) collect ,str)))))

; (defun map-docstring (&rest rest)
;   (declare #.*opt* (list rest))
;   "register docs info associated with symbol (car rest)."
;   (setf *docstring-map* (remove-if (lambda (cand) (eq (car cand) (car rest)))
;                                    *docstring-map*))
;   (push rest *docstring-map*))


