
(in-package :weir)


(declaim (inline make-bvhres bvhres-i bvhres-s))
(defstruct (bvhres)
  (i -1 :type fixnum :read-only nil)
  (s 900000f0 :type veq:ff :read-only nil))
(weird:define-struct-load-form bvhres)


(declaim (inline %make-polyx))
(veq:fvdef* make-polyx ((:va 3 v0 v1 v2) &aux (res (veq:f3$zero 3)))
  (declare (optimize speed (safety 0)) (veq:ff v0 v1 v2) (veq:fvec res))
  (veq:$nvset (res 9) (veq:f3- v2 v0) (veq:f3- v1 v0) (veq:f3 v0)))

(veq:fvdef make-bvh (wer &key (num 5) matfx)
  (declare #.*opt* (weir wer) (veq:pn num))
  (bvh::make (bvh::-make-objects-and-normals wer)
             (lambda (poly)
               (declare #.*opt* (list poly))
               ; TODO: find a better way for this ?? what is this?
               (make-polyx (veq:f3$ (3gvs wer poly) 0 1 2)))
             :matfx matfx
             :num num))

(declaim (inline get-bvh-res-norm))
(veq:fvdef get-bvh-res-norm (bvh res)
  (declare (optimize speed (safety 0)) (bvh::bvh bvh) (bvhres res))
  (veq:f3$ (bvh::bvh-normals bvh) (bvhres-i res)))

(declaim (inline get-bvh-res-poly))
(veq:fvdef get-bvh-res-poly (bvh res)
  (declare (optimize speed (safety 0)) (bvh::bvh bvh) (bvhres res))
  (veq:3$ (bvh::bvh-polys bvh) (bvhres-i res)))

(declaim (inline get-bvh-res-mat))
(veq:fvdef get-bvh-res-mat (bvh res)
  (declare (optimize speed (safety 0)) (bvh::bvh bvh) (bvhres res))
  (veq:2$ (bvh::bvh-mat bvh) (bvhres-i res)))

(defmacro -eps-div (&rest rest)
  `(values ,@(loop for x in rest
                   collect `(if (> (the veq:ff (abs (the veq:ff ,x)))
                                   (the veq:ff #.*eps*))
                              (the veq:ff (/ ,x)) (the veq:ff #.*eps*)))))


(veq:fvdef make-raycaster (bvh &aux (res (make-bvhres)))
  (declare (optimize speed (safety 0))
           (bvh::bvh bvh) (bvhres res))
  (macrolet
    ((nodes- (slot) `(aref nodes (the veq:pn (+ ,slot ni))))
     (for-leaves- ((res i3) &body body)
       `(loop repeat (nodes- 0)
              for i of-type veq:pn from (nodes- 1)
              do (let* ((,i3 (the veq:pn (* 9 i)))
                        (s ,@body))
                   (declare (veq:pn ,i3) (veq:ff s))
                   (when (and (< (the veq:ff #.*eps*) s)
                              (< s (bvhres-s ,res)))
                         (setf (bvhres-s ,res) s (bvhres-i ,res) i)))))
     (rec-if- (&rest rest)
       `(let ((i ,@rest))
          (declare (veq:pn i))
          (when (> i 0) (rec i) (rec (the veq:pn (+ bvh::+leap+ i)))))))

    (let ((mima (bvh::bvh-mima bvh))
          (polyfx (bvh::bvh-polyfx bvh))
          (nodes (bvh::bvh-nodes bvh)))
      (declare (veq:fvec mima polyfx) (veq:pvec nodes))
      (labels
        ((raycast ((:va 3 org ll))
           (declare (veq:ff org b))
           (veq:f3let ((inv (-eps-div ll)))
               (labels
                 ((rec (ni &aux (ni2 (the veq:pn (* 2 ni))))
                    (declare (veq:pn ni ni2))
                    (when (bvh::-bbox-test mima (the veq:pn ni2) inv org) ; LEAP?
                          (for-leaves- (res i3) (bvh::-polyx polyfx i3 org ll))
                          (rec-if- (nodes- 2)))))
                 (setf (bvhres-i res) -1 (bvhres-s res) 900000f0)
                 (rec 0)
                 res))))
        #'raycast))))


(veq:fvdef make-short-raycaster (bvh)
  (declare (optimize speed (safety 0)) (bvh::bvh bvh))
  (macrolet
    ((nodes- (slot) `(aref nodes (the veq:pn (+ ,slot ni))))
     (for-leaves- ((i3) &body body)
       `(loop repeat (nodes- 0)
              for i of-type veq:pn from (nodes- 1)
              do (let* ((,i3 (the veq:pn (* 9 i)))
                        (s ,@body))
                   (declare (veq:pn ,i3) (veq:ff s))
                   (when (and (< (the veq:ff #.*eps*) s) (< s 1f0))
                         (return-from raycast-short 0f0)))))
     (rec-if- (&rest rest)
       `(let ((i ,@rest))
          (declare (veq:pn i))
          (when (> i 0) (push-rt i) (push-rt (the veq:pn (+ bvh::+leap+ i)))))))

    (weird:with-fast-stack (rt :n 100 :safe-z 20 :type veq:pn)
      (let ((mima (bvh::bvh-mima bvh))
            (polyfx (bvh::bvh-polyfx bvh))
            (nodes (bvh::bvh-nodes bvh)))
        (declare (veq:fvec mima polyfx) (veq:pvec nodes))
        (labels
          ((raycast-short ((:va 3 org ll))
             (declare (veq:ff org b))
             (veq:f3let ((inv (-eps-div ll)))
               (nil-rt)
               (push-rt 0)
               (loop while (con-rt)
                     do (let* ((ni (the veq:pn (pop-rt)))
                               (ni2 (the veq:pn (* 2 ni)))) ; LEAP?
                          (declare (veq:pn ni ni2))
                          (when (bvh::-bbox-test mima ni2 inv org)
                                (for-leaves- (i3) (bvh::-polyx polyfx i3 org ll))
                                (rec-if- (nodes- 2)))))
               1f0)))
          #'raycast-short)))))

