
(in-package #:weird)


(deftype pos-int (&optional (bits 31)) `(unsigned-byte ,bits))

(defun v? (&optional silent)
  (if silent (slot-value (asdf:find-system 'weird) 'asdf:version)
             (format t "~%weird version: ~a~%"
               (slot-value (asdf:find-system 'weird) 'asdf:version))))


(defun f? (f)
  (declare (symbol f))
  (format t "~%---~%")
  (describe f)
  (format t "~%---~%") )

(defun i? (f) (inspect f))


;http://cl-cookbook.sourceforge.net/os.html
(defun cmd-args ()
  (or #+SBCL sb-ext:*posix-argv*
      #+LISPWORKS system:*line-arguments-list*
      #+CMU extensions:*command-line-words*
      nil))


;https://www.rosettacode.org/wiki/Program_termination#Common_Lisp
(defun terminate (status)
  (format t "~%terminated with status: ~a~%" status)
  #+sbcl (sb-ext:quit :unix-status status)
  #+ccl (ccl:quit status)
  #+clisp (ext:quit status)
  #+cmu (unix:unix-exit status)
  #+abcl (ext:quit:status status)
  #+allegro (excl:exit status :quiet t)
  #+gcl (common-lisp-user::bye status)
  #+ecl (ext:quit status))


;https://github.com/inconvergent/weir/pull/1/commits/4a1df51914800c78cb34e8194222185ebde12388
(defmacro define-struct-load-form (struct-name)
  "Allow the structure named STRUCT-NAME to be dumped to FASL files."
  `(defmethod make-load-form ((obj ,struct-name) &optional env)
     (make-load-form-saving-slots obj :environment env)))


; modified from on lisp by pg
(defun group (source n)
  (if (zerop n) (error "group: zero length"))
  (labels ((rec (source acc)
             (let ((rest (nthcdr n source)))
               (if (consp rest)
                   (rec rest (cons (subseq source 0 n) acc))
                   (nreverse (cons source acc))))))
    (if source (rec source nil) nil)))


; from on lisp by pg
(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

; from on lisp by pg
(defun reread (&rest args) (values (read-from-string (apply #'mkstr args))))


(declaim (inline lst>n))
(defun lst>n (l n)
  (declare (list l) (pos-int n))
  "is list, l, longer than n?"
  (consp (nthcdr n l)))

(declaim (inline last*))
(defun last* (a) (first (last a)))


(defun tree-find (tree fx)
  (declare (optimize speed) (function fx))
  (cond ((funcall fx tree) (return-from tree-find tree))
        ((atom tree) nil)
        ((consp tree) (or (tree-find (car tree) fx)
                          (tree-find (cdr tree) fx)))))

(defun tree-find-all (root fx &optional (res (list)))
  (declare (optimize speed) (function fx) (list res))
  (cond ((funcall fx root) (return-from tree-find-all (cons root res)))
        ((atom root) nil)
        (t (let ((l (tree-find-all (car root) fx res))
                 (r (tree-find-all (cdr root) fx res)))
             (when l (setf res `(,@l ,@res)))
             (when r (setf res `(,@r ,@res))))
           res)))

(defun filter-by-predicate (l fx)
  (declare (list l) (function fx))
  (loop for x in l
        if (funcall fx x) collect x into yes
        else collect x into no
        finally (return (values yes no))))


;from on lisp by pg
(defmacro aif (test-form then-form &optional else-form)
  `(let ((it ,test-form))
     (if it ,then-form ,else-form)))


;from on lisp by pg
(defmacro abbrev (short long)
  `(defmacro ,short (&rest args)
     `(,',long ,@args)))

(abbrev mvc multiple-value-call)
(abbrev mvb multiple-value-bind)
(abbrev dsb destructuring-bind)
(abbrev awg alexandria:with-gensyms)
(abbrev awf alexandria:flatten)


; from on lisp by pg
(defun symb (&rest args) (values (intern (apply #'mkstr args))))

;https://gist.github.com/lispm/6ed292af4118077b140df5d1012ca646
(defun psymb (package &rest args) (values (intern (apply #'mkstr args) package)))


;https://gist.github.com/lispm/6ed292af4118077b140df5d1012ca646
(defmacro with-struct ((name . fields) struct &body body)
  (let ((gs (gensym)))
    `(let ((,gs ,struct))
       (let ,(mapcar #'(lambda (f)
                         `(,f (,(psymb (symbol-package name) name f) ,gs)))
                     fields)
         ,@body))))

(defmacro template ((&rest all-pairs) &body body)
  (declare (optimize speed) (list all-pairs))
  (labels ((replace-pairs (root pairs)
             (declare (optimize speed))
             (loop for (old . new) in pairs
                   do (setf root (subst new old root)))
             root))
     `(progn ,@(loop for pairs in all-pairs
                     collect `(progn ,@(replace-pairs body pairs))))))


(defmacro make-animation ((ani) &body body)
  `(push (lambda () (progn ,@body)) ,ani))
(defmacro animate (ani)
  (weird:awg (a)
    `(setf ,ani (remove-if-not (lambda (,a) (funcall ,a)) ,ani))))


(defun append-postfix (fn postfix)
  (declare (string fn postfix))
  (concatenate 'string fn postfix))


(defun append-number (fn i)
  (declare (string fn) (fixnum i))
  (format nil "~a-~8,'0d" fn i))


(defun ensure-filename (fn &optional (postfix "") (silent nil))
  (let ((fn* (append-postfix (if fn fn "tmp") postfix)))
    (declare (string fn*))
    (format (not silent) "~%file: ~a~%~%" fn*)
    fn*))


(defun print-every (i &optional (n 1))
  (declare (fixnum i n))
  (when (= 0 (mod i n)) (format t "~%itt: ~a~%" i)))


(defun string-list-concat (l)
  (declare (list l))
  (format nil "~{~a~}" l))


(defun numshow (a &key (ten 6) (prec 6))
  (declare (number a))
  (let ((show (format nil "~~,~af" prec)))
    (if (< 1d-6 (the number (abs a)) (expt 10 ten))
        (format nil show a)
        (format nil "~,1e" a))))


(abbrev vextend vector-push-extend)

(defun lvextend (xx arr)
  (declare (sequence xx) (vector arr))
  (typecase xx (cons (loop for x in xx do (vextend x arr)))
               (t (loop for x across xx do (vextend x arr)))))


(declaim (inline vector-last))
(defun vector-last (a)
  (declare (vector a))
  (aref a (1- (the fixnum (length a)))))


(declaim (inline vector-first))
(defun vector-first (a)
  (declare (vector a))
  (aref a 0))


(defun make-adjustable-vector (&key init (type t) (size 128))
  (if init (make-array (length init)
             :fill-pointer t :initial-contents init
             :element-type type :adjustable t)
           (make-array size
             :fill-pointer 0 :element-type type :adjustable t)))


(defun to-vector (init &key (type t))
  (declare (list init))
  (make-array (length init)
    :initial-contents init :adjustable nil :element-type type))


(defun ensure-vector (o &key (type t))
  (declare (sequence o))
  (typecase o (cons (to-vector o :type type))
              (vector o)
              (t (error "unable to coerce to vector: ~a" o))))


(defun to-adjustable-vector (init &key (type t))
  (declare (sequence init))
  (make-array (length init)
              :fill-pointer t :initial-contents init
              :element-type type :adjustable t))


(defun to-list (a) (declare (sequence a)) (coerce a 'list))

(defun undup (e)
  (declare (optimize speed))
  (delete-duplicates (alexandria:flatten e)))

(defun internal-path-string (path)
  (declare (string path))
  (namestring (asdf:system-relative-pathname :weird path)))

