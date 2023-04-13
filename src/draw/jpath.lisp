
(in-package :jpath)

(defmacro ht () `(make-hash-table :test #'equal))

(declaim (veq:ff *pi3* *pi2* *pi23*) (list *limits*))
(defvar *pi3* #.(/ veq:fpi 3f0))
(defvar *pi2* #.(/ veq:fpi 2f0))
(defvar *pi23* #.(* 2f0 (/ veq:fpi 3f0)))
(defvar *limits* `(#.(/ veq:fpi 2.99f0)
                   #.(/ veq:fpi 3.99f0)
                   #.(/ veq:fpi 7.99f0)))

(declaim (inline ori))
(veq:fvdef ori (a)
  (declare (veq:fvec a))
  (> (veq:f2cross (veq:f2$ a 0 1)) #.veq:*eps*))

(defstruct (joint (:constructor -make-joint))
  (w 0f0 :type veq:ff :read-only t)
  (orientation t :type boolean :read-only t)
  (alpha 0f0 :type veq:ff :read-only t)
  (in-out nil :type veq:fvec :read-only t)
  (mode :joint :type symbol :read-only t)
  (grid nil :type vector :read-only t)
  (i 0 :type fixnum :read-only t))


(veq:fvdef o++ ((:va 2 p v w)) (f2!@+ (f2!@+ p v) w))
(veq:fvdef o-- ((:va 2 p v w)) (f2!@- (f2!@- p v) w))
(veq:fvdef o+- ((:va 2 p v w)) (f2!@- (f2!@+ p v) w))
(veq:fvdef o-+ ((:va 2 p v w)) (f2!@+ (f2!@- p v) w))

(veq:fvdef -make-joint-grid ((:va 2 p) io)
  (declare (veq:ff p) (veq:fvec io))
  "8 offset points around p"
  (veq:xlet ((f2!z (veq:f2val 0f0))
             (f2!i (veq:f2$ io))
             (f2!o (veq:f2$ io 1)))
    (veq:f$~ (2) (o+- p o i) (o+- p z i) (o-- p o i) (o-+ p o z)
                 (o-+ p o i) (o++ p z i) (o++ p o i) (o++ p o z)
                 (veq:f2 p))))

(veq:fvdef path->joints (path w* &key closed
                                 &aux (w (* 0.5f0 w*))
                                      (n (round (length path) 2)))
  (declare (veq:fvec path) (veq:ff w w*) (boolean closed))
  "joints contain information about how to offset around points in path."
  (labels
    ((make-joint (i (:va 2 a p b))
       (veq:xlet ((f2!in (veq:f2norm (f2!@- p a)))
                  (f2!out (veq:f2norm (f2!@- b p)))
                  (alpha (- veq:fpi (acos (veq:fclamp* (veq:f2dot in out) -1.0 1f0))))
                  (s (/ w (veq:ff (sin alpha))))
                  (io (veq:f2$line (f2!@*. in s) (f2!@*. out s)))) ; in-out
         (-make-joint :w w :i i :alpha alpha :in-out io
                      :orientation (ori io)
                      :grid (-make-joint-grid p io)))) ; FIX

     (make-start ((:va 2 p b))
       (veq:xlet ((f2!out (f2!@*. (veq:f2norm (f2!@- b p)) w))
                  (io (veq:f2$line (veq:f2rot out *pi2*) out)))
         (-make-joint :w w :mode :start :alpha *pi2*
                      :in-out io :grid (-make-joint-grid p io))))

     (make-end (i (:va 2 a p))
       (veq:xlet ((f2!in (f2!@*. (veq:f2norm (f2!@- p a)) w))
                  (io (veq:f2$line in (veq:f2rot in (- *pi2*)))))
         (-make-joint :w w :i i :mode :end :alpha (- *pi2*)
                      :in-out io :grid (-make-joint-grid p io))))

     (ci (i) (veq:f2$ path (mod i n)))
     (closed-path->joints ()
       (loop for i from 0 below n
             collect (m@make-joint i (ci (1- i)) (ci i) (ci (1+ i)))))
     (open-path->joints ()
       (loop with init = (m@make-end (1- n) (ci (- n 2)) (ci (1- n)))
             with res = (list init)
             for i from (- n 2) downto 1
             do (push (m@make-joint i (ci (1- i)) (ci i) (ci (1+ i))) res)
             finally (return (cons (m@make-start (ci 0) (ci 1)) res)))))

    (when (< n (if closed 3 2))
          (error "JPATH: must have at least 2 (open)
or 3 (closed) elements. n: ~a~%closed: ~a" n closed))

    (if closed (closed-path->joints) (open-path->joints))))

(veq:fvdef path->diagonals (path w &key closed (limits *limits*))
  (declare (veq:fvec path) (veq:ff w) (boolean closed))
  "return (orientation line) for every point in path. lerp-ing along lines will
return controll points. lerp direction should be flipped when orientation is
nil. sharp or chamfered points correspond to two lines"
  (let ((joints (to-vector (path->joints path w :closed closed)))
        (la (first limits)) (lb (second limits)) (lc (third limits))
        (res (list)))
    (labels
       ((gx (a i) (veq:f2$ (joint-grid (aref joints a)) i))
        (gx* (p u v) (veq:f2$line (gx p u) (gx p v)))
        (start (p) (gx* p 1 5 )) (end (p) (gx* p 7 3 ))
        (joint (p) (gx* p 4 0))
        (soft-1 (p) (gx* p 3 0)) (soft-2 (p) (gx* p 5 0))
        (chamfer-1 (p) (gx* p 2 0)) (chamfer-2 (p) (gx* p 6 0))
        (sharp-3 (p) (gx* p 2 6)) (sharp-4 (p) (gx* p 6 2))
        (do-joint (i)
          (let* ((j (aref joints i))
                 (alpha (joint-alpha j))
                 (ori (joint-orientation j)))
            (cond ((<= alpha lc) (push `(,ori ,(sharp-3 i)) res)
                                 (push `(,ori ,(sharp-4 i)) res))
                  ((<= alpha lb) (push `(,ori ,(chamfer-1 i)) res)
                                 (push `(,ori ,(chamfer-2 i)) res))
                  ((<= alpha la) (push `(,ori ,(soft-1 i)) res)
                                 (push `(,ori ,(soft-2 i)) res))
                  (t (push `(,ori ,(joint i)) res))))))

       (loop for i from 0 below (length joints)
             do (ecase (joint-mode (aref joints i))
                      (:end (push `(,t ,(end i)) res))
                      (:start (push `(,t ,(start i)) res))
                      (:joint (do-joint i))))
       ; diagonals: (#(a b) #(c d) ...)
       (reverse res))))

(veq:fvdef jpath (path w &key (rep 3) closed (limits *limits*))
  (declare (veq:fvec path) (veq:ff w) (fixnum rep) (boolean closed))
  (let* ((diagonals (to-vector (path->diagonals path w :closed closed :limits limits)))
         (n (length diagonals))
         (res (make-adjustable-vector))
         (ss (math:linspace rep 0f0 1f0)))

    (labels
      ((flip? (ori s) (if ori s (- 1f0 s)))
       (open-ind (i k i-) (if (= (math:mod2 k) 0) i i-))
       (closed-path ()
         (loop for s in ss
               do (vextend (loop for (ori line) across diagonals
                                 collect (veq:lst (veq:f2lerp
                                                    (veq:f2$ line 0 1)
                                                    (flip? ori s))))
                           res)))
       (open-path ()
         (loop for s in ss and k of-type fixnum from 0
               do (loop for i of-type fixnum from 0 below n
                        and i- of-type fixnum downfrom (1- n)
                        for (ori line) = (aref diagonals (open-ind i k i- ))
                        do (vextend (veq:lst (veq:f2lerp (veq:f2$ line 0 1)
                                                         (flip? ori s)))
                                    res)))))
      (if closed (closed-path) (open-path))
      (veq:f$_ (to-list res)))))

