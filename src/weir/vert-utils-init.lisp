
(in-package :weir)

(defun dim-placeholder (root dim)
  (declare (character dim))
  (labels ((repl (s dim) (intern (substitute dim #\@
                                   (string-upcase (weird:mkstr s)))
                                 (symbol-package s))))
    (cond ((symbolp root) (repl root dim))
          ((atom root) root)
          (t (cons (dim-placeholder (car root) dim)
                   (dim-placeholder (cdr root) dim))))))

(defmacro dimtemplate ((name &optional docs) &body body)
  (declare (symbol name))
  (labels ((docs (exportname) (when docs `(weird::map-docstring ',exportname ,docs)))
           (sub (en dim)
            (subst dim 'dim
               (subst en 'fx
                 (subst docs 'docs
                   (dim-placeholder body (digit-char dim))))))
           (sy (dim) (intern (weird:mkstr dim name) 'weir)))
    (let ((res (loop for dim in '(2 3)
                   collect (let ((exportname (sy dim)))
                             `(progn ,(docs exportname)
                                     (export ',exportname)
                                     ,@(sub exportname dim))))))
     `(progn ,@res))))

