
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
  (weird:mvb (xmi xma ymi yma zmi zma) (veq:f3$mima vv)
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


; ;https://en.wikipedia.org/wiki/M%C3%B6ller%E2%80%93Trumbore_intersection_algorithm
(declaim (inline %-polyx))
(veq:fvdef* -polyx ((:va 3 v0 e1 e2 org l))
  (declare #.*opt* (veq:ff org l v0 e1 e2))
  (veq:fvlet ((h 3 (veq:f3cross l e2))
              (a (veq:f3. e1 h)))
    (declare (veq:ff h a))
  ; e1,e2 are parallel
  (when (< (abs a) (the veq:ff *eps*)) (return-from -polyx (values nil 0f0)))
  (veq:fvlet ((f (/ a))
              (s 3 (veq:f3- org v0))
              (u (* f (veq:f3. s h))))
    (declare (veq:ff f s u))
    (when (or (> u 1f0) (< u 0f0)) (return-from -polyx (values nil 0f0)))
    (veq:fvlet ((q 3 (veq:f3cross s e1))
                (v (* f (veq:f3. l q))))
      (declare (veq:ff q v))
      (when (or (< v 0f0) (> (+ u v) 1f0)) (return-from -polyx (values nil 0f0)))
      (let ((tt (* f (veq:f3. e2 q))))
        (declare (veq:ff tt))
        (when (> 1f0 tt (the veq:ff *eps*)) (return-from -polyx (values t tt))) ; isect!
        (values nil tt)))))) ; miss!

(declaim (inline %make-polyx))
(veq:fvdef* make-polyx ((:va 3 v0 v1 v2))
  (declare #.*opt* (veq:ff v0 v1 v2))
  (veq:f3let ((e1 (veq:f3- v1 v0))
              (e2 (veq:f3- v2 v0)))
    (lambda ((:va 3 org l))
      (declare #.*opt* (veq:ff org l))
      (-polyx v0 e1 e2 org l))))

; objs: (((1 2 3) #(xmi ymi zmi xma yma zma))
;        ...)

(veq:fvdef make-bvh (wer &key (num 5))
  (declare #.*opt* (weir wer) (pos-int num))
  (weird:mvb (objs normals) (-make-objects-and-normals wer)
    (let ((bvh (bvh::make objs
                 (lambda (poly)
                   (declare #.*opt* (list poly))
                   (make-polyx ; TODO: find a better way for this
                     (veq:f3$ (3gvs wer poly) 0 1 2)))
                 :num num)))
      (setf (bvh:bvh-normals bvh) normals)
      bvh)))

(declaim (inline make-bvhres bvhres-i bvhres-s bvhres-pt))
(defstruct (bvhres)
  (i nil :type list :read-only nil)
  (s 900000f0 :type veq:ff :read-only nil)
  (pt (veq:f3$point 0f0 0f0 0f0) :type veq:fvec :read-only nil))
(weird:define-struct-load-form bvhres)

; much much slower than the recursive version:
; (declaim (inline %-do-raycast))
; (veq:fvdef* -do-raycast (root (:va 3 org ll) bfx res)
;   (declare #.*opt* (bvh:node root) (veq:ff org ll) (function bfx) (bvhres res))

;   (let ((q (list root)))
;     (declare (list q) )
;     (loop while q
;           for curr of-type bvh:node = root then (pop q)
;           if (veq:mvc bfx (veq:f3$ (bvh::node-mima curr) 0 1))
;           do
;              (loop for (i leaffx) of-type (list function) in (bvh:node-leaves curr)
;                    do (veq:mvb (isect s) (funcall leaffx org ll)
;                         (declare (boolean isect) (veq:ff s))
;                         (when (and isect (< s (bvhres-s res)))
;                               (setf (bvhres-s res) s
;                                     (bvhres-i res) i))))

;              (when (bvh:node-l curr) (push (bvh:node-l curr) q))
;              (when (bvh:node-r curr) (push (bvh:node-r curr) q)))

;     ; (setf (bvhres-s res) s* (bvhres-i res) i*)
;     res))

; bfx: line-bbox-test
(veq:fvdef* -do-raycast (root (:va 3 org ll) bfx res)
  (declare #.*opt* (bvh:node root) (veq:ff org ll) (function bfx) (bvhres res))
  (labels ((leaf (i leaffx)
            (declare (list i) (function leaffx))
            (veq:mvb (isect s) (funcall leaffx org ll)
              (declare (boolean isect) (veq:ff s))
              (when (and isect (< s (bvhres-s res)))
                (setf (bvhres-s res) s (bvhres-i res) i))))

           (rec (node)
            (declare (bvh:node node))
            (unless (veq:mvc bfx (veq:f3$ (bvh::node-mima node) 0 1))
                    (return-from rec))
            (loop for (i leaffx) of-type (list function)
                    in (bvh:node-leaves node)
                  do (leaf i leaffx))
            (when (bvh:node-l node) (rec (bvh:node-l node)))
            (when (bvh:node-r node) (rec (bvh:node-r node)))))

    (rec root)))


(declaim (inline get-bvh-res-norm))
(veq:fvdef get-bvh-res-norm (bvh res)
  (declare #.*opt* (bvh:bvh bvh) (bvhres res))
  (if (bvhres-i res)
      (veq:f3$ (gethash (bvhres-i res) (bvh:bvh-normals bvh)))
      (veq:f3rep* 0f0)))

(veq:fvdef* raycast (bvh (:va 3 org b))
  (declare #.*opt* (bvh:bvh bvh) (veq:ff org b))
  (veq:f3let ((ll (veq:f3- b org)))
    (let ((res (make-bvhres)))
      (declare (bvhres res))

      (-do-raycast (bvh:bvh-root bvh) org ll
                   (bvh:make-line-bbox-test org ll) res)

      (veq:f3let ((pt (veq:f3from org ll (bvhres-s res))))
        (let ((p (bvhres-pt res)))
          (declare (veq:fvec p))
          (setf (aref p 0) (:vr pt 0)
                (aref p 1) (:vr pt 1)
                (aref p 2) (:vr pt 2))))

      res)))

(veq:fvdef make-raycaster (bvh &aux (res (make-bvhres)))
  (declare #.*opt* (bvh:bvh bvh) (bvhres res))
  (labels ((raycast ((:va 3 org b))
             (declare (veq:ff org b))
             (veq:f3let ((ll (veq:f3- b org)))
               (setf (bvhres-i res) nil (bvhres-s res) 900000f0)
               ; (setf res (make-bvhres)) ; debug avoid sfxs
               (-do-raycast (bvh:bvh-root bvh) org ll
                            (bvh:make-line-bbox-test org ll) res)
               (veq:f3let ((pt (veq:f3from org ll (bvhres-s res))))
                 (let ((p (bvhres-pt res)))
                   (declare (veq:fvec p))
                   (setf (aref p 0) (:vr pt 0)
                         (aref p 1) (:vr pt 1)
                         (aref p 2) (:vr pt 2))))
                res)))
    #'raycast))

