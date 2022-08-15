
(in-package :weir)

; TODO: ignore nil alts
(defun build-alt (wname pairs aexpr
                  &key alt-res res db
                  &aux (wgs (gensym (mkstr wname))))
  (declare #.*opt* (symbol alt-res wname wgs) (list pairs aexpr))
  "helper function used to construct alterations from template.
see defalt macro below."

  ;; eg: expanded alt for (% (add-edge? v? (+ i 1)) :res a?):

  ;; alt body: (ADD-EDGE! W A B G G)
  ;; res: A?
  ;; wrapped: ((B (+ I 1) OUT-B23) (G NIL OUT-G24))
  ;; futures: ((A V? OUT-A22))

  ;; (LET ((#:OUT-B23 (+ I 1))) ; <-- create closure for B,G
  ;;   (LET ((#:OUT-G24 NIL))
  ;;     (LAMBDA (#:WER164)
  ;;       (DECLARE (OPTIMIZE (SAFETY 1) (SPEED 3) DEBUG SPACE)
  ;;                (WEIR::WEIR #:WER164)
  ;;                (IGNORABLE #:WER164))
  ;;       (CASE (WEIR::-IF-ALL-RESOLVED #:ALT-RES6 V?) ; <-- checks if V? is resolved
  ;;         (:OK
  ;;          (VALUES T
  ;;                  (SETF (GETHASH A? #:ALT-RES6)    ; <- res is assigned here
  ;;                          (WEIR:ADD-EDGE! #:WER164 ; <-- alt body
  ;;                                          (VALUES (GETHASH V? #:ALT-RES6))
  ;;                                          #:OUT-B23 :G #:OUT-G24))))
  ;;         (:BAIL (PROGN (SETF (GETHASH A? #:ALT-RES6) NIL) (VALUES T NIL)))
  ;;         (T (VALUES NIL NIL))))))

  (labels ((-print-debug (outer futures full)
             (format t "~&alt body: ~a~&res: ~a~&wrapped: ~a~&futures: ~a~&"
                     aexpr res outer futures)
             (pprint full)
             #+SBCL (when (equal db :verbose)
                      (format t "~&--- full expansion --->~&")
                      (pprint (third (sb-cltl2:macroexpand-all
                                       `(veq:vprogn ,full)))))
             (format t "~&--------------------~&"))
           (select-let (s)
             (declare (symbol s))
             (cond ((fdim-symbp s :dim 2) 'veq:f2let)
                   ((fdim-symbp s :dim 3) 'veq:f3let)
                   ((fdim-symbp s :dim 4) 'veq:f4let)
                   (t 'let)))
           (wraplet (pairs inner)
             (declare (list pairs) (cons inner))
             (loop for (o b a) in (reverse pairs)
                   do (setf inner `(,(select-let o) ((,a ,b)) ,inner)))
             inner)
           (replace-inner-symbols (pairs aexpr)
             (declare (list pairs) (cons aexpr))
             (loop for (old org new) in pairs
                   do (setf aexpr (subst new old aexpr)))
             aexpr)
           (future-s (tree) (tree-find tree #'future-symbp))
           (replace-inner-futures (pairs aexpr)
             (declare (list pairs) (cons aexpr))
             (loop for (old org new) in pairs
                   do (setf aexpr
                            (subst `(values (gethash ,(future-s org) ,alt-res))
                                   (future-s org)
                                   (subst org old aexpr))))
             aexpr)
           (split-pairs (pairs)
             (declare (list pairs))
             (filter-by-predicate
               (mapcar (lambda (sv) (declare (optimize speed))
                         `(,@sv ,(gensym (mkstr "OUT-" (car sv)))))
                       (weird:group pairs 2))
               (lambda (s) (declare (optimize speed)) (future-s (second s))))))

    (mvb (futures outer) (split-pairs pairs)
      (declare (list outer futures))
      (let* ((aexpr (subst wgs wname
                           (replace-inner-futures futures
                             (replace-inner-symbols outer aexpr))))
             (main (if res `(setf (gethash ,res ,alt-res) ,aexpr) ; assign result
                           `(progn ,aexpr))) ; unnamed result
             (inner (if futures ; if arg
                      `(case (-if-all-resolved ,alt-res
                               ,@(mapcar (lambda (l) (future-s (second l)))
                                         futures))
                         (:ok (values t ,main))
                         (:bail (progn ,(when res `(setf (gethash ,res ,alt-res) nil))
                                       (values t nil)))
                         (t (values nil nil)))
                      `(values t ,main)))
             (full (wraplet outer
                     `(lambda (,wgs)
                        (declare #.*opt* (weir ,wgs) (ignorable ,wgs))
                        ,inner))))
        (declare (list aexpr main inner full))
        (when db (-print-debug outer futures full))
        `(veq:fvprogn ,full)))))


(defmacro defalt (name (wname &rest args)
                  &body body
                  &aux (rest (gensym "REST")))
  (declare (symbol name wname rest) (list args body))
  "define an alteration.
as an example, the definition of 2add-vert? looks like this:

  (defalt 2add-vert? (f2!p)
    (weir:2add-vert! wer f2!p))

the prefix f2! is neccessary to indicate that the symbol represents a
  (veq:f2 a b) vector.

defalt is used to define all internal alterations (except ?), and can be used
to define custom alterations outside the :weir package."
  (labels ((&-symbp (a)
             (and (symbolp a) (member a '(&key &optional &rest &aux))))
           (symb-with-default (a)
             (typecase a (symbol `(,a ,a))
                         (list `(,(car a) ,a))
                         (t (error "bad value in defalt.
requires symbol or list. got: ~a" a))))
           (make-arg-symbs (args)
             (loop for a in args
                   if (&-symbp a) collect a
                   else collect (symb-with-default a)))
           (make-build-alt-pairs (args &aux (res (list)))
             "build pairs of symb, value for alteration arguments.
              symbol is used in body to build futures."
             (loop for a in args
                   if (listp a) do (push `(quote ,(car a)) res)
                                   (push (car a) res))
             (reverse res))
           (if-weir-internal (margs)
            ; a bit hacky, but this is to only export/document
            ; when called in weir.
            (when (equalp (package-name *package*) "WEIR")
              (let ((docs (weird::-docs-sanitize
                            (format nil "weir alteration.~%args: ~a~%body: ~a"
                                    margs (car body)))))
                `((export ',name) (weird::map-docstring ',name
                                    ,docs :weircont :nodesc))))))
    (let* ((args (make-arg-symbs args))
           (margs (loop for a in args if (listp a) collect (cadr a)
                                      else collect a))) ; not listp == eg. &key)
      `(progn ,@(if-weir-internal margs)
         (defmacro ,name (,margs &rest ,rest)
           (apply #'build-alt ',wname (list ,@(make-build-alt-pairs args))
                                      ',@body ,rest))))))

