
(in-package :bvh)


(deftype pos-int (&optional (bits 31)) `(unsigned-byte ,bits))

(declaim (inline node-l node-r node-leaves node-mima))
(defstruct (node (:constructor -make-node))
  (l nil :read-only nil)
  (r nil :read-only nil)
  (leaves nil :type list :read-only nil)
  (mima (veq:f3$line 0f0 0f0 0f0 0f0 0f0 0f0) :type veq:fvec :read-only t))
(weird:define-struct-load-form node)

(defstruct (bvh (:constructor -make-bvh))
  (root nil :type node :read-only t)
  (normals nil :read-only nil))
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

; (declaim (inline -longaxis))
(veq:fvdef -longaxis (objs)
  (declare #.*opt* (list objs))
  (weird:mvb (xmi xma ymi yma zmi zma)
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
    (declare (pos-int axis))
    ; sort by bbox min: (second o)
    (sort objs (lambda (a b)  ; TODO: refactor object format
                 (and (< (the veq:ff (aref (second a) axis))
                         (the veq:ff (aref (second b) axis))))))))

; leaffx: (poly) -> (-polyx v0 e1 e2 org l) i think ..?
(defun make (all-objs leaffx &key (num 5))
  (declare #.*opt* (list all-objs) (function leaffx) (pos-int num))
  (labels
    ((build (root objs &aux (m (node-mima root)))
      (declare (node root) (veq:fvec m))
      (veq:mvb (xmi xma ymi yma zmi zma)
        (-objs-list-bbox (map 'list #'second objs)) ; <--- replace -bbox!!!
        (declare (veq:ff xmi xma ymi yma zmi zma))
        (setf (aref m 0) xmi (aref m 1) ymi (aref m 2) zmi
              (aref m 3) xma (aref m 4) yma (aref m 5) zma))

      (when (<= (length objs) num)
            (setf (node-leaves root)
                  ; (mapcar (lambda (o) (funcall leaffx (car o))) objs)
                  (mapcar (lambda (o) (list (car o)
                                            (funcall leaffx (car o))))
                          objs))
            (return-from build))

      (setf objs (-axissort objs))

      (let ((mid (ceiling (length objs) 2))
            (l (-make-node))
            (r (-make-node)))
        (declare (node l r) (pos-int mid))
        (setf (node-l root) l (node-r root) r)
        (build l (subseq objs 0 mid))
        (build r (subseq objs mid)))))

    (let* ((root (-make-node))
           (res (-make-bvh :root root)))
      (build root all-objs)
      res)))

(defmacro -select-bound ((ao invl mi ma sig tmin tmax) &body body)
  `(multiple-value-bind (,tmin ,tmax)
      (if ,sig (values (* ,invl (- ,mi ,ao)) (* ,invl (- ,ma ,ao)))
               (values (* ,invl (- ,ma ,ao)) (* ,invl (- ,mi ,ao))))
      (declare (veq:ff ,tmin ,tmax))
      (progn ,@body)))

(declaim (inline %-bbox-test))
(veq:fvdef* -bbox-test ((:va 3 inv sig org mi ma))
  (declare #.*opt* (boolean sig) (veq:ff inv org mi ma))
  (-select-bound ((:vr org 0) (:vr inv 0) (:vr mi 0)
                  (:vr ma 0) (:vr sig 0) tmin tmax)
    (-select-bound ((:vr org 1) (:vr inv 1) (:vr mi 1)
                    (:vr ma 1) (:vr sig 1) tymin tymax)
      (when (or (> tmin tymax) (> tymin tmax)) (return-from -bbox-test nil))
      (when (> tymin tmin) (setf tmin tymin))
      (when (< tymax tmax) (setf tmax tymax))
      (-select-bound ((:vr org 2) (:vr inv 2) (:vr mi 2)
                      (:vr ma 2) (:vr sig 2) tzmin tzmax)
        (when (or (> tmin tzmax) (> tzmin tmax)) (return-from -bbox-test nil))
        (when (> tzmin tmin) (setf tmin tzmin))
        (when (< tzmax tmax) (setf tmax tzmax))
        (and (< tmin 1f0) (> tmax 0f0))))))


(defmacro -eps-div (x)
  (declare (symbol x))
  `(if (> (the veq:ff (abs ,x)) (the veq:ff *eps*))
       (/ ,x) (the veq:ff *eps*)))

(declaim (inline %make-line-bbox-test))
(veq:fvdef* make-line-bbox-test ((:va 3 org l))
  (declare #.*opt* (veq:ff org l))
  (veq:f3let ((inv (veq:f3 (-eps-div (:vr l 0))
                           (-eps-div (:vr l 1))
                           (-eps-div (:vr l 2)))))
    (let ((sigx (<= 0f0 (:vr inv 0)))
          (sigy (<= 0f0 (:vr inv 1)))
          (sigz (<= 0f0 (:vr inv 2))))
      (declare (boolean sigx sigy sigz))
      (labels ((line-bbox-test ((:va 3 mi ma))
                (declare #.*opt* (veq:ff mi ma))
                (-bbox-test inv sigx sigy sigz org mi ma)))
        #'line-bbox-test))))

; (defun node-bbox-info (root)
;   (unless root (return-from node-bbox-info nil))
;   (let ((mi (node-mi root))
;         (ma (node-ma root)))
;     (format nil "~&bbox, mi ~a; ma: ~a~&" mi ma)))

