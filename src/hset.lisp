
(in-package :hset)

"
fixnum set. this is a naive wrapper around hash-table. not sure how efficient
it will be?
"

(defun copy (s &key (size 100) (inc 2f0))
  (declare #.*opt* (hash-table s) (fixnum size) (number inc))
  (let ((ns (make-hash-table :test #'eql :size size :rehash-size inc)))
    (declare (hash-table ns))
    (loop for k being the hash-keys of s do (setf (gethash k ns) t))
    ns))

(defun make (&key init (size 100) (inc 2f0))
  (declare #.*opt* (fixnum size))
  (let ((s (make-hash-table :test #'eql :size size :rehash-size inc)))
    (when init (add* s init))
    s))


(declaim (inline add))
(defun add (s e)
  (declare #.*opt* (hash-table s) (fixnum e))
  (multiple-value-bind (val exists) (gethash e s)
    (declare (ignore val))
    (if exists nil (setf (gethash e s) t))))

(defun add* (s ee)
  (declare #.*opt* (hash-table s) (sequence ee))
  (typecase ee (cons (loop for e of-type fixnum in ee collect (add s e)))
               (simple-array (loop for e of-type fixnum
                                     across (the (simple-array fixnum) ee)
                                   collect (add s e)))
               (t (error "incorrect type in hset:add*: ~a~%" ee))))

(declaim (inline del))
(defun del (s e)
  (declare #.*opt* (hash-table s) (fixnum e))
  (remhash e s))

(defun del* (s ee)
  (declare #.*opt* (hash-table s) (sequence ee))
  (typecase ee (cons (loop for e of-type fixnum in ee collect (del s e)))
               (simple-array (loop for e of-type fixnum
                                     across (the (simple-array fixnum) ee)
                                   collect (del s e)))
               (t (error "incorrect type in hset:del* ~a~%" ee))))

(declaim (inline mem))
(defun mem (s e)
  (declare #.*opt* (hash-table s) (fixnum e))
  (multiple-value-bind (_ exists) (gethash e s)
    (declare (ignore _))
    exists))

(defun mem* (s ee)
  (declare #.*opt* (hash-table s) (sequence ee))
  (typecase ee (cons (loop for e of-type fixnum in ee collect (mem s e)))
               (simple-array (loop for e of-type fixnum
                                     across (the (simple-array fixnum) ee)
                                   collect (mem s e)))
               (t (error "incorrect type in hset:mem* ~a~%" ee))))

(defun num (s)
  (declare #.*opt* (hash-table s))
  (the fixnum (hash-table-count s)))

(defun to-list (s)
  (declare #.*opt* (hash-table s))
  (loop for e of-type fixnum being the hash-keys of s collect e))


; SET OPS (not well tested)

(defun uni (a b)
  (declare #.*opt* (hash-table a b))
  (let ((c (copy a)))
    (loop for k being the hash-keys of b do (setf (gethash k c) t))
    c))

(defun inter (a b)
  (declare #.*opt* (hash-table a b))
  (loop with c = (make)
        for k being the hash-keys of a
        do (when (mem b k) (setf (gethash k c) t))
        finally (return c)))

(defun symdiff (a b)
  (declare #.*opt* (hash-table a b))
  (let ((uni (uni a b)))
    (declare (hash-table uni))
    (loop for k being the hash-keys of uni
          do (when (and (mem a k) (mem b k))
                   (remhash k uni)))
    uni))

