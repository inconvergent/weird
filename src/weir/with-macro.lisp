
(in-package :weir)


(defmacro with ((wer accfx &key db) &body body)
  (declare (symbol wer accfx))
  (awg (a clear-alt-res alt-res alts* with-res resolve-all resolve-1)
    (labels
      ((acc (expr &key res)
         (declare (optimize speed) (list expr))
         (when (and res (not (promise-symbp res)))
               (error "alteration error. invalid :res. got: ~a~%" res))

         (handler-case
           `(,accfx (,(intern (mkstr (car expr)) 'weir)
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
          (labels ((,accfx (,a) (declare #.*opt* (function ,a)) (push ,a ,alts*))
                   (,clear-alt-res ()
                     (declare #.*opt*)
                     (loop for ,a being the hash-keys of ,alt-res
                           do (remhash ,a ,alt-res)))
                   (,resolve-1 ()
                     (declare #.*opt*)
                     (loop for ,a in ,alts*
                           if (not (funcall (the function ,a) ,wer))
                           collect ,a of-type function))
                   (,resolve-all ()
                     (declare #.*opt*)
                     (loop until (not ,alts*) do (setf ,alts* (,resolve-1 )))))
            (let ((,with-res (progn ,@body)))
              (,clear-alt-res)
              (,resolve-all)
              ,with-res)))))))

