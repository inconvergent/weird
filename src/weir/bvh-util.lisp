
(in-package :bvh)

(deftype symvec () `(simple-array symbol))

(declaim (inline %-poly-normal))
(veq:fvdef* -poly-normal (v)
  (declare #.*opt* (veq:fvec v))
  (handler-case
    (veq:f3let ((a (veq:f3$ v 0)))
      (veq:f3norm (veq:f3cross (veq:f3- (veq:f3$ v 1) a)
                               (veq:f3- (veq:f3$ v 2) a))))
    (error (e) (declare (ignore e)) (rnd:3on-sphere 1f0))))

(progn (veq:fvdef -make-objects-and-normals (wer)
  (declare #.*opt* (weir::weir wer))
  (weir:itr-polys (wer pp :collect t)
    (let ((vv (weir:3gvs wer pp)))
      `(,pp ,(veq:f3$line (veq:f3$mima vv))
            ,(veq:f3$point (-poly-normal vv)))))))

(defun -print-bvh (o s)
  (declare (notinline bvh-time bvh-num-nodes bvh-num-polys))
  (weird:with-struct (bvh- num-nodes num-polys time) o
    (format s "<@bvh: (nodes: ~a, polys: ~a, time: ~a)>"
            num-nodes num-polys time)))

(defstruct (bvh (:constructor -make-bvh)
                (:print-object -print-bvh))
  (time 0 :type veq:ff :read-only t)
  (nodes (veq:p3$zero 0) :type veq:pvec :read-only t)
  (polys (veq:p3$zero 0) :type veq:pvec :read-only t)
  (mima (veq:f3$zero 0) :type veq:fvec :read-only t)
  (polyfx (veq:f3$zero 0) :type veq:fvec :read-only t)
  (normals (veq:f3$zero 0) :type veq:fvec :read-only t)
  (mat nil :type symvec :read-only t)
  (num-nodes 0 :type veq:pn :read-only t)
  (num-polys 0 :type veq:pn :read-only t))
(weird:define-struct-load-form bvh)

; TODO: bad bad bad
(declaim (inline -objs-list-bbox))
(veq:fvdef -objs-list-bbox (objs)
  (declare #.*opt* (list objs))
  (loop for o of-type veq:fvec in objs
        minimizing (aref o 0) into xmi of-type veq:ff
        maximizing (aref o 1) into xma of-type veq:ff
        minimizing (aref o 2) into ymi of-type veq:ff
        maximizing (aref o 3) into yma of-type veq:ff
        minimizing (aref o 4) into zmi of-type veq:ff
        maximizing (aref o 5) into zma of-type veq:ff
        finally (return (values xmi xma ymi yma zmi zma))))

(declaim (inline -longaxis))
(veq:fvdef -longaxis (objs)
  (declare #.*opt* (list objs))
  (veq:mvb (xmi xma ymi yma zmi zma)
    (-objs-list-bbox (mapcar #'second objs))
    (declare (veq:ff xmi xma ymi yma zmi zma))
    (veq:f3let ((diff (veq:f3 (- xma xmi) (- yma ymi) (- zma zmi))))
      (second (first (sort (list (list (:vr diff 0) 0) ;TODO: fix this?
                                 (list (:vr diff 1) 1)
                                 (list (:vr diff 2) 2))
                           #'> :key #'first))))))

(declaim (inline -axissort))
(defun -axissort (objs)
  (declare #.*opt* (list objs))
  (let ((axis (-longaxis objs)))
    (declare (veq:pn axis))
    ; sort by bbox min: (second o)
    (sort objs (lambda (a b)  ; TODO: refactor object format
                 (and (< (the veq:ff (aref (the veq:fvec (second a)) axis))
                         (the veq:ff (aref (the veq:fvec (second b)) axis))))))))

(declaim (fixnum +leap+))
(defconstant +leap+ 3)

(veq:fvdef make (all-objs leaffx &key (num 5) matfx)
  (declare #.*opt* (list all-objs) (function leaffx)
           (veq:pn maxlvl nodeind polyind num))
  (macrolet ((nodes- (slot v) `(setf (aref nodes (+ (* +leap+ ni) ,slot)) ,v)))

    (let* ((t0 (get-internal-real-time))
           (npolys (length all-objs))
           (npolys* (ceiling npolys (max 1 (1- num))))
           (polyind 0) (ni 0)
           (mima (veq:f3$zero (* 3 npolys))) ; 2x, but how many actual nodes for n polys?
           (nodes (veq:p$zero (* #.(* 3 +leap+) npolys*)))
           (polys (veq:p3$zero npolys))
           (mat (veq:$make :n npolys :dim 2 :v :ao :type 'symbol))
           (polyfx (veq:f3$zero (* 3 npolys)))
           (normals (veq:f3$zero npolys)))
      (declare (veq:pn ni npolys npolys* polyind) (veq:pvec polys nodes)
               (veq:fvec mima polyfx normals) (symvec mat))
      (labels ; num 0 ; poly 1 ; l 2 ;; leap 3
        ((get-free-index () (incf ni) (1- ni))
         (do-poly (o &aux (p (car o)))
           (veq:3$vset (polys polyind) (veq:from-lst p))
           (veq:3$vset (normals polyind) (veq:f3$ (third o)))
           (veq:$nvset (polyfx 9 (* 9 polyind))
                       (veq:f3$ (funcall leaffx p) 0 1 2))
           (when matfx (veq:$nvset (mat 2 (* 2 polyind))
                                   (funcall (the function matfx) p)))
           (incf polyind))
         (build (ni objs &aux (n (length objs)))
           (declare (veq:pn ni n) (list objs))
           (veq:$nvset (mima 6 (* 6 ni))
                       (-objs-list-bbox (mapcar #'second objs)))
          (if (<= n num) (loop initially (nodes- 1 polyind) ; poly
                               for o in (-axissort objs)
                               do (do-poly o)
                               finally (nodes- 0 n)); num
              (progn (setf objs (-axissort objs))
                     (let ((mid (floor n 2))
                           (l (get-free-index))
                           (r (get-free-index)))
                       (declare (veq:pn l r mid))
                       (nodes- 2 (* +leap+ l)) ; l
                       (build l (subseq objs 0 mid))
                       (build r (subseq objs mid)))))))
        (build (get-free-index) all-objs)
        (-make-bvh :nodes nodes :polys polys :mima mima
                   :polyfx polyfx :normals normals :mat mat
                   :num-polys polyind :num-nodes ni
                   :time (veq:ff (/ (- (get-internal-real-time) t0)
                                    internal-time-units-per-second)))))))

; ; ;https://en.wikipedia.org/wiki/M%C3%B6ller%E2%80%93Trumbore_intersection_algorithm
(declaim (inline -polyx))
(veq:fvdef -polyx (fx i (:va 3 org ll))
  (declare (optimize space speed (safety 0) (debug 0))
           (veq:fvec fx) (veq:ff org ll) (veq:pn i))

  (macrolet ((i (leap) `(aref fx (the veq:pn (+ i ,leap)))))
    (veq:fvlet ((h 3 (veq:f3cross ll (i 0) (i 1) (i 2)))  ;0
                (a (veq:f3. (i 3) (i 4) (i 5) h))) ; 1
      ; e1,e2 are parallel, miss!
      (when (< (abs a) (the veq:ff #.*eps*)) (return-from -polyx -1f0))
      (veq:fvlet ((f (/ a))
                  (s 3 (veq:f3- org (i 6) (i 7) (i 8))) ; 2
                  (u (the veq:ff (* f (veq:f3. s h)))))
        ; miss!
        (when (or (> u 1f0) (< u 0f0)) (return-from -polyx -1f0))
        (veq:fvlet ((q 3 (veq:f3cross s (i 3) (i 4) (i 5))) ; 1
                    (v (the veq:ff (* f (veq:ff (veq:f3. ll q))))))
          ; miss!
          (when (or (< v 0f0) (> (the veq:ff (+ u v)) 1f0)) (return-from -polyx -1f0))
          ; technically we should do this:
          ; (max (the veq:ff (* f (veq:f3. (veq:f3$ fx 2) q))) ; hit!
          ;      (the veq:ff #.(- *eps*))))
          ; but the final check is performed in make raycaster,
          ; so we do this instead:
          (the veq:ff
            (* f (the veq:ff (veq:f3. (i 0) (i 1) (i 2) q))))))))) ; hit/miss! ; 2


(declaim (inline -bbox-test))
(veq:fvdef -bbox-test (mima i (:va 3 inv org))
  (declare (optimize space speed (safety 0) (debug 0))
           (veq:ff inv org) (veq:fvec mima) (veq:pn i))
  (macrolet ((i (leap) `(aref mima (the veq:pn (+ i ,leap))))
             (-bound ((ao invl mi ma tmin tmax) &body body)
                `(if (<= 0f0 ,invl)
                  (let ((,tmin #1=(the veq:ff (* ,invl (the veq:ff (- ,mi ,ao)))))
                        (,tmax #2=(the veq:ff (* ,invl (the veq:ff (- ,ma ,ao))))))
                    #3=(declare (veq:ff ,tmin ,tmax))
                    #4=(progn ,@body))
                  (let ((,tmin #2#) (,tmax #1#)) #3# #4#))))
    (-bound ((:vr org 0) (:vr inv 0) (i 0) (i 1) tmin tmax)
      (-bound ((:vr org 1) (:vr inv 1) (i 2) (i 3) tymin tymax)
        (unless (or (> tmin tymax) (> tymin tmax))
          (when (> tymin tmin) (setf tmin tymin))
          (when (< tymax tmax) (setf tmax tymax))
          (-bound ((:vr org 2) (:vr inv 2) (i 4) (i 5) tzmin tzmax)
            (unless (or (> tmin tzmax) (> tzmin tmax))
              (when (> tzmin tmin) (setf tmin tzmin))
              (when (< tzmax tmax) (setf tmax tzmax))
              (and (< tmin 1f0) (> tmax 0f0)))))))))

