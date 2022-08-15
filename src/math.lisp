
(in-package :math)


(defun last* (l) (declare #.*opt* (list l)) (first (last l)))

(defun close-path (p)
  (declare #.*opt* (list p))
  "append first element of p to end of p."
  (append p (subseq p 0 1)))

(defun close-path* (p)
  (declare #.*opt* (list p))
  "append last element of p to front of p."
  (cons (last* p) p))


(defmacro nrep (n &body body)
  "returns list with body :evaluated: n times."
  `(the list (loop repeat (the veq:pn ,n) collect (progn ,@body))))

(defun range (a &optional (b nil))
  (declare #.*opt* (fixnum a))
  "fixnums from 0 to a, or a to b."
  (if (not b) (loop for x of-type fixnum from 0 below a collect x)
              (loop for x of-type fixnum from a below (the fixnum b)
                    collect x)))

; this is kind of silly
(defun lpos (ll &key (fx #'first))
  (declare #.*opt* (list ll) (function fx))
  "apply fx to every element in ll. "
  (mapcar fx ll))

; TODO pretty sure there is a better way to do this
(defun ll-transpose (l)
  (declare #.*opt* (list l))
  "transpose list of lists.
assumes all initial lists in l have the same length."
  (labels ((-reduce (acc v) (loop for a in acc and b in v collect (cons b a))))
    (mapcar #'reverse (reduce #'-reduce l
                              :initial-value (loop repeat (length (the list (first l)))
                                                   collect (list))))))

(defun list>than (l n)
  (declare #.*opt* (list l) (veq:pn n))
  "list is longer than n?"
  (consp (nthcdr n l)))


(defun linspace (n a b &key (end t))
  (declare #.*opt* (veq:pn n) (veq:ff a b) (boolean end))
  "n veq:ffs from a to b."
  (if (> n 1)
    (loop with ban of-type veq:ff = (/ (- b a) (if end (1- n) n))
          for i of-type fixnum from 0 below n
          collect (+ a (* (coerce i 'veq:ff) ban)) of-type veq:ff)
    (list a)))


; INT LIST MATH

(defmacro lop (name type &body body)
  `(defun ,name (aa bb)
     (declare #.*opt* (list aa bb))
     ,(format nil "element wise ~a for two lists of ~a" (car body) type)
     (loop for a of-type ,type in aa and b of-type ,type in bb
           collect (the ,type (,@body (the ,type a) (the ,type b)))
             of-type ,type)))

(lop add fixnum +)
(lop sub fixnum -)
(lop mult fixnum *)

(defun mod2 (i)
  (declare #.*opt* (fixnum i))
  "(mod i 2) for fixnums."
  (mod i 2))
(defun imod (i inc m)
  (declare #.*opt* (fixnum i inc m))
  "(mod (+ i inc) m) for fixnums"
  (the fixnum (mod (the fixnum (+ i inc)) m)))


; OTHER

(defun copy-sort (a fx &key (key #'identity))
  (declare #.*opt* (sequence a))
  "sort a without side effects to a. not very efficent."
  (sort (copy-seq a) fx :key key))


(defun range-search (ranges f &aux (n (1- (length ranges)))
                                   (ranges* (ensure-vector ranges)))
  "binary range search.  range must be sorted in ascending order. f is a value
inside the range you are looking for."
  (if (or (< f (aref ranges* 0)) (> f (aref ranges* n)))
    (error "querying position outside range: ~a" f))

  (loop with l of-type fixnum = 0
        with r of-type fixnum = n
        with m of-type fixnum = 0
        until (<= (aref ranges* m) f (aref ranges* (1+ m)))
        do (setf m (floor (+ l r) 2))
           (cond ((> f (aref ranges* m)) (setf l (progn m)))
                 ((< f (aref ranges* m)) (setf r (1+ m))))
        finally (return m)))

(defun integer-search (aa v &aux (n (length aa)))
  (declare #.*opt* (vector aa) (fixnum v n))
  "binary integer search. assumes presorted list of integers"
  (loop with l of-type fixnum = 0
        with r of-type fixnum = (1- n)
        with m of-type fixnum = 0
        while (<= l r)
        do (setf m (ceiling (+ l r) 2))
           (cond ((< (the fixnum (aref aa m)) v) (setf l (1+ m)))
                 ((> (the fixnum (aref aa m)) v) (setf r (1- m)))
                 (t (return-from integer-search m)))))


(defun argmax (ll &optional (key #'identity))
  (declare (list ll) (function key))
  "returns (values iv v).
where iv is the index of v and v is the highest value in ll."
  (loop with iv = 0
        with v = (funcall key (first ll))
        for l in (cdr ll)
        and i from 1
        if (> (funcall key l) v)
        do (setf v (funcall key l) iv i)
        finally (return (values iv v))))

(defun argmin (ll &optional (key #'identity))
  (declare (list ll) (function key))
  "returns (values iv v).
where iv is the index of v and v is the smallest value in ll."
  (loop with iv = 0
        with v = (funcall key (first ll))
        for l in (cdr ll)
        and i from 1
        if (< (funcall key l) v)
        do (setf v (funcall key l) iv i)
        finally (return (values iv v))))

