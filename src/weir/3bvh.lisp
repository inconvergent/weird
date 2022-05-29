
(in-package :weir)


(declaim (inline %-poly-normal))
(veq:fvdef* -poly-normal ((:va 3 a b c))
  (declare #.*opt* (veq:ff a b c))
  (handler-case
    (veq:f3let ((nrm (veq:f3norm (veq:f3cross (veq:f3- b a) (veq:f3- c a)))))
      ; TODO: handle /0 issues differently? default normal?
      (values nrm))
    (error (e) (declare (ignore e)) (values 1f0 0f0 0f0))))


; TODO: this is nonsense
(declaim (inline -bbox))
(veq:fvdef -bbox (vv)
  (veq:mvb (xmi xma ymi yma zmi zma) (veq:f3$mima vv)
    (declare (veq:ff xmi xma ymi yma zmi zma))
    ; (veq:f_ (list xmi ymi zmi xma yma zma))
    (veq:f_ (list xmi xma ymi yma zmi zma))))


(veq:fvdef -make-objects-and-normals (wer)
  (declare #.*opt* (weir wer))
  (loop with normals = (make-hash-table :test #'equal)
        with objs = (list)
        for poly of-type list in (get-all-polygons wer)
        do (let ((vv (3gvs wer poly))) ; vv = #(line)
             ; TODO: lst bad
             ; (((1 2 3) xmi xma ymi yma ...) ... )
             (push (cons poly (list (-bbox vv))) objs)
             (setf (gethash poly normals)
                   (veq:f_ (veq:lst (-poly-normal (veq:f3$ vv 0 1 2))))))
        finally (return (values objs normals))))

(declaim (inline %make-polyx))
(veq:fvdef* make-polyx ((:va 3 v0 v1 v2))
  (declare (optimize speed (safety 0)) (veq:ff v0 v1 v2))
  (let ((res (veq:f3$zero 3)))
    (declare (veq:fvec res))
    (veq:3$vset (res 0) (veq:f3 v0))
    (veq:3$vset (res 1) (veq:f3- v1 v0))
    (veq:3$vset (res 2) (veq:f3- v2 v0))
    res))

; objs: (((1 2 3) #(xmi ymi zmi xma yma zma))
;        ...)

(veq:fvdef make-bvh (wer &key (num 5))
  (declare #.*opt* (weir wer) (pos-int num))
  (veq:mvb (objs normals) (-make-objects-and-normals wer)
    (let ((bvh (bvh::make objs
                 (lambda (poly)
                   (declare #.*opt* (list poly))
                   (make-polyx ; TODO: find a better way for this
                     (veq:f3$ (3gvs wer poly) 0 1 2)))
                 :num num)))
      (setf (bvh::bvh-normals bvh) normals)
      bvh)))

(declaim (inline make-bvhres bvhres-i bvhres-s bvhres-pt))
(defstruct (bvhres)
  (i nil :type list :read-only nil)
  (s 900000f0 :type veq:ff :read-only nil)
  (pt (veq:f3$point 0f0 0f0 0f0) :type veq:fvec :read-only nil))
(weird:define-struct-load-form bvhres)


(declaim (inline get-bvh-res-norm))
(veq:fvdef get-bvh-res-norm (bvh res)
  (declare #.*opt* (bvh::bvh bvh) (bvhres res))
  (if (bvhres-i res)
      (veq:f3$ (gethash (bvhres-i res) (bvh::bvh-normals bvh)))
      (veq:f3rep* 0f0)))


; ;https://en.wikipedia.org/wiki/M%C3%B6ller%E2%80%93Trumbore_intersection_algorithm
(declaim (inline -polyx))
(veq:fvdef -polyx (fx (:va 3 org l))
  (declare (optimize speed (safety 0))
           (veq:fvec fx) (veq:ff org l))
  (veq:fvlet ((h 3 (veq:f3cross l (veq:f3$ fx 2)))
              (a (veq:f3. (veq:f3$ fx 1) h)))
    (declare (veq:ff h a))
  ; e1,e2 are parallel
  (when (< (abs a) (the veq:ff #.*eps*)) ; miss!
        (return-from -polyx -1f0))
  (veq:fvlet ((f (/ a))
              (s 3 (veq:f3- org (veq:f3$ fx 0)))
              (u (the veq:ff (* f (veq:f3. s h)))))
    (declare (veq:ff f s u))
    (when (or (> u 1f0) (< u 0f0)) ; miss!
          (return-from -polyx -1f0))
    (veq:fvlet ((q 3 (veq:f3cross s (veq:f3$ fx 1)))
                (v (the veq:ff (* f (veq:f3. l q)))))
      (declare (veq:ff q v))
      (when (or (< v 0f0) (> (the veq:ff (+ u v)) 1f0)) ; miss!
            (return-from -polyx -1f0))
      ; technically we should do this:
      ; (max (the veq:ff (* f (veq:f3. (veq:f3$ fx 2) q))) ; hit!
      ;      (the veq:ff #.(- *eps*))))
      ; but the final check is performed in make raycaster,
      ; so we do this instead:
      (the veq:ff (* f (veq:f3. (veq:f3$ fx 2) q))))))) ; hit/miss!


(veq:fvdef make-raycaster (bvh &aux (res (make-bvhres)) (p (bvhres-pt res))
                                    (root (bvh::bvh-root bvh)))
  (declare (optimize speed (safety 0))
           (bvh::bvh bvh) (bvhres res) (veq:fvec p) (bvh::node root))
  (macrolet
    ((leaf- ((res i) &body body)
       `(let ((s ,@body))
          (declare (veq:ff s))
          (when (and (< (the veq:ff *eps*) s) (< s (bvhres-s ,res)))
                (setf (bvhres-s ,res) s (bvhres-i ,res) (the list ,i)))))
     (for-leaves- ((res node fx) &body body)
       `(loop for (i ,fx) of-type (list veq:fvec)
              in (bvh::node-leaves ,node) do (leaf- (,res i) ,@body)))
     (rec-if- (&rest rest) `(typecase (,@rest) (bvh::node (rec (,@rest))))))

    (labels
      ((raycast ((:va 3 org b))
         (declare (veq:ff org b))
         (veq:f3let ((ll (veq:f3- b org))
                     (inv (bvh::-eps-div* ll)))
           (veq:mvb ((:va 3 sig)) (bvh::-sig inv)
             (declare (boolean sig))
             (labels
               ((rec (node)
                  (declare (optimize speed (safety 0)) (bvh::node node))
                  (unless (bvh::-bbox-test (bvh::node-mima node) sig inv org)
                          (return-from rec))
                  (for-leaves- (res node fx) (-polyx fx org ll))
                  (rec-if- bvh::node-l node)
                  (rec-if- bvh::node-r node)))
               (setf (bvhres-i res) nil (bvhres-s res) 900000f0)
               (rec root)
               (veq:3$vset (p 0) (veq:f3from org ll (bvhres-s res)))
               res)))))
    #'raycast)))

