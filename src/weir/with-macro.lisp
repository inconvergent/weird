
(in-package :weir)


(defmacro with ((wer accfx &key db (mode :warn))
                &body body
                &aux (weir-symbs (loop for sym being the external-symbols
                                         of (find-package :weir)
                                       collect sym)))
  (declare (symbol wer accfx))
  "create context for creating and applying alterations. alterations are
registered with accfx, and will be applied/resolved at the end of the context.

alterations can depend on the results of other alterations.  alteration names
must be keywords that end in ?, eg :a?; or symbols that end in ?, provided
that symbol has an assigned symbol as a value.  eg: (let ((a? (gensym))) ...)

ex: (weir:with (wer %)
      (% (2add-vert? (veq:f2 2.0 7.0) :res :a?)) ; result is named :a?
      (% (2move-vert? 1 (veq:f2 1.0 3.0)))
      (% (add-edge? 1 :a?)))

it is possible to create dependency situations that cause deadlocks.
use :mode values:
  - :warn, to warn and exit on deadlocks;
  - :strict, to cause error on deadlock;
  - :force, to use no special deadlock handling; or
  - t to exit silently on deadlocks.

use :db t to print the generated code for all alterations.

see examples/ex.lisp for a more involved example."
  (awg (a* a with-res incomp comp
        clear-alt-res alt-res alts*
        resolve-all resolve-once)
    (labels
      ((weir-alt-p (s)
         (not (not (member (intern (mkstr s) :weir) weir-symbs :test #'eq))))
       (intern-as-weir-or-symb-pkg (s)
         (intern (mkstr s) (if (weir-alt-p s) :weir (symbol-package s))))
       (handle-deadlock (&aux (msg "deadlock in weir:with. incomplete: ~a."))
         (case mode
           ; error on deadlock
           (:strict `(finally (when (< ,comp 1) (error ,msg ,incomp))))
           ; warn and exit on deadlock
           (:warn `(finally (when (< ,comp 1) (return (warn ,msg ,incomp)))))
           ; this will cause a deadlock unless there is special handling in the
           ; futures. might require further changes to defalt or with macros?
           (:force nil)
           ; exit silently on deadlock
           (t `(finally (when (< ,comp 1) (return nil))))))

       (acc (expr &key res)
         (declare (optimize speed) (list expr))
         (when (and res (not (future-symbp res)))
               (error "alteration error. invalid :res. got: ~a~%" res))

         (handler-case
           `(,accfx
              (,(intern-as-weir-or-symb-pkg (car expr))
                (,@(cdr expr)) :res ,res :alt-res ,alt-res :db ,db))
           (error (e) (error "error when building alt:~%~a~%err: ~a" expr e))))

       (rec (root)
         (declare (optimize speed))
         (cond ((atom root) root)
               ((and (listp root) (eq (car root) accfx))
                (apply #'acc (cdr root)))
               (t (cons (rec (car root)) (rec (cdr root)))))))

      (let ((body (rec body)))
       `(let ((,alt-res (weir-alt-res ,wer))
              (,alts* (list)))
          (declare (hash-table ,alt-res) (list ,alts*))
          (labels ((,accfx (,a) (declare #.*opt*)
                    (let ((,a* ,a))
                      (typecase ,a* (function (push ,a* ,alts*)))))
                   (,clear-alt-res () (declare #.*opt*) (clrhash ,alt-res))
                   (,resolve-once ()
                     (declare #.*opt*)
                     (loop for ,a in ,alts*
                           if (not (funcall (the function ,a) ,wer))
                           collect ,a of-type function
                           and summing 1 into ,incomp of-type fixnum
                           else summing 1 into ,comp of-type fixnum
                           ,@(handle-deadlock)))
                   (,resolve-all ()
                     (declare #.*opt*)
                     (loop until (not ,alts*) do (setf ,alts* (,resolve-once)))))
            (let ((,with-res (progn ,@body)))
              (,clear-alt-res)
              (,resolve-all)
              ,with-res)))))))

