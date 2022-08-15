
(in-package :weir)

(deftype index-array () `(simple-array fixnum))


(defmacro -ind (a dim i leap)
  `(the fixnum (+ (the fixnum (* ,dim (the fixnum (aref ,a ,i)))) ,leap)))

(defstruct (node (:constructor node (leap ind left right)))
  (left nil :read-only t)
  (right nil :read-only t)
  (leap -1 :type fixnum :read-only t)
  (ind -1 :type fixnum :read-only t))

(veq:fvdef -qsort-kdtree (argsort a &key dim (leap 0) (lo 0) hi)
  "construct a kd tree of dim using quicksort for partitioning.
argsort will contain the index into the spatial data in a."
  (declare (index-array argsort) (veq:fvec a) (fixnum dim leap lo hi))

  (cond ((= hi lo) (return-from -qsort-kdtree (node leap hi nil nil)))
        ((> lo hi) (return-from -qsort-kdtree nil)))

  (labels ((leapget (i)
             (declare (fixnum i))
             (aref a (-ind argsort dim i leap)))

           (partition (lo hi)
             (declare (fixnum lo hi))
             (loop with pivot = (leapget hi)
                   with i = (- lo 1)
                   for j from lo to hi
                   do (when (<= (leapget j) pivot)
                            (incf i)
                            (rotatef (aref argsort i) (aref argsort j)))
                   finally (return-from partition i))))

    ; p is the index into argsort, used to retrieve the node spatial info in a
    (let ((p (partition lo hi))
          (leap* (mod (1+ leap) dim)))
      (declare (fixnum p leap*))
      (node leap p
        (-qsort-kdtree argsort a :dim dim :leap leap* :lo lo :hi (- p 1))
        (-qsort-kdtree argsort a :dim dim :leap leap* :lo (+ p 1) :hi hi)))))


(defstruct (kdtree (:constructor -make-kdtree))
  (argsort #() :type index-array :read-only nil)
  (node nil :type node :read-only t)
  (dim -1 :type fixnum :read-only t))

(defun build-kdtree (wer)
  (declare (weir wer))
  (let* ((dim (weir-dim wer))
         (n (get-num-verts wer))
         (argsort (make-array n :adjustable nil :element-type 'fixnum
                    :initial-contents (loop for i of-type fixnum
                                            from 0 below n collect i))))
    (declare (fixnum dim n) (index-array argsort))
    (setf (weir-kdtree wer)
          (-make-kdtree :dim dim :argsort argsort
                        :node (-qsort-kdtree argsort (weir-verts wer)
                                :dim dim :hi (1- n))))))

; TODO: 3rad/3nn. 2/3 macro?

(veq:fvdef* 2rad (wer (:varg 2 x) rad &aux (rad2 (* rad rad)) (res (list)))
  "get indices of all verts in rad around x"
  (declare #.*opt* (weir wer) (veq:ff x rad rad2) (list res))

  (with-struct (weir- kdtree verts dim) wer
    (declare (veq:fvec verts) (fixnum dim))
    (with-struct (kdtree- argsort) kdtree
      (declare (index-array argsort))
      (labels
        ((leapget (leap ind)
           (declare #.*opt* (fixnum leap ind))
           (aref verts (-ind argsort dim ind leap)))

         (xdst2 (ind)
           (declare #.*opt* (fixnum ind))
           (veq:f2dst2 x (veq:f2$ verts (aref argsort ind))))

         (-rad (node)
           (declare #.*opt*)
           (when (not node) (return-from -rad))
           (with-struct (node- ind leap left right) node
             (declare (veq:pn ind leap))
             (let* ((xv (case leap (0 (:vref x 0)) (otherwise (:vref x 1))))
                    (nv (leapget leap ind))
                    (axdst2 (expt (- xv nv) 2f0))
                    (dst2 (xdst2 ind)))
               (declare (veq:ff xv nv axdst2 dst2))

               (when (< dst2 rad2) (push (aref argsort ind) res))
               (if (> rad2 axdst2)
                   (progn (-rad left) (-rad right))
                   (-rad (if (<= xv nv) left right)))))))

      (-rad (kdtree-node kdtree))
      res))))

(veq:fvdef* 2nn (wer (:varg 2 x) &aux (res -1) (resdst2 0f0))
  "get index of nearest neighbour of x."
  (declare #.*opt* (weir wer) (veq:ff x resdst2) (fixnum res))

  (with-struct (weir- kdtree verts dim) wer
    (declare (veq:fvec verts) (fixnum dim))
    (with-struct (kdtree- argsort) kdtree
      (declare (index-array argsort))
      (labels
        ((leapget (leap ind)
           (declare #.*opt* (fixnum leap ind))
           (aref verts (-ind argsort dim ind leap)))

         (xdst2 (ind)
           (declare #.*opt* (fixnum ind))
           (veq:f2dst2 x (veq:f2$ verts (aref argsort ind))))

         (-nn (node)
           (declare #.*opt*)
           (when (not node) (return-from -nn))
           (with-struct (node- ind leap left right) node
             (declare (veq:pn ind leap))
             (let* ((xv (case leap (0 (:vref x 0)) (otherwise (:vref x 1))))
                    (nv (leapget leap ind))
                    (axdst2 (expt (- xv nv) 2f0))
                    (dst2 (xdst2 ind)))
               (declare (veq:ff xv nv axdst2 dst2))

               (when (< dst2 resdst2)
                     (setf res (aref argsort ind) resdst2 dst2))
               (if (> resdst2 axdst2)
                   (progn (-nn left) (-nn right))
                   (-nn (if (<= xv nv) left right)))))))

      (let ((node (kdtree-node kdtree)))
        (declare (node node))
        (setf res (aref argsort (node-ind node))
              resdst2 (xdst2 (aref argsort (node-ind node))))
        (-nn node))
      (values res (sqrt resdst2))))))


(veq:fvdef* 3nn (wer (:varg 3 x) &aux (res -1) (resdst2 0f0))
  "get index of nearest neighbour of x."
  (declare #.*opt* (weir wer) (veq:ff x resdst2) (fixnum res))

  (with-struct (weir- kdtree verts dim) wer
    (declare (veq:fvec verts) (fixnum dim))
    (with-struct (kdtree- argsort) kdtree
      (declare (index-array argsort))
      (labels
        ((leapget (leap ind)
           (declare #.*opt* (fixnum leap ind))
           (aref verts (-ind argsort dim ind leap)))

         (xdst2 (ind)
           (declare #.*opt* (fixnum ind))
           (veq:f3dst2 x (veq:f3$ verts (aref argsort ind))))

         (-nn (node)
           (declare #.*opt*)
           (when (not node) (return-from -nn))
           (with-struct (node- ind leap left right) node
             (declare (veq:pn ind leap))
             (let* ((xv (case leap (0 (:vref x 0))
                                   (1 (:vref x 1))
                                   (otherwise (:vref x 2))))
                    (nv (leapget leap ind))
                    (axdst2 (expt (- xv nv) 2f0))
                    (dst2 (xdst2 ind)))
               (declare (veq:ff xv nv axdst2 dst2))

               (when (< dst2 resdst2)
                     (setf res (aref argsort ind) resdst2 dst2))
               (if (> resdst2 axdst2)
                   (progn (-nn left) (-nn right))
                   (-nn (if (<= xv nv) left right)))))))

      (let ((node (kdtree-node kdtree)))
        (declare (node node))
        (setf res (aref argsort (node-ind node))
              resdst2 (xdst2 (aref argsort (node-ind node))))
        (-nn node))
      (values res (sqrt resdst2))))))

