
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
(veq:vdef ori (a)
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


(veq:vdef o++ ((veq:varg 2 p v w)) (veq:lst (veq:f2+ (veq:f2+ p v) w)))
(veq:vdef o-- ((veq:varg 2 p v w)) (veq:lst (veq:f2- (veq:f2- p v) w)))
(veq:vdef o+- ((veq:varg 2 p v w)) (veq:lst (veq:f2- (veq:f2+ p v) w)))
(veq:vdef o-+ ((veq:varg 2 p v w)) (veq:lst (veq:f2+ (veq:f2- p v) w)))

(veq:vdef -make-joint-grid ((veq:varg 2 p) io)
  (declare (veq:ff p) (veq:fvec io))
  " 8 offset points around p "
  (veq:f2let ((z (veq:f2 0f0 0f0))
              (i (veq:f2$ io))
              (o (veq:f2$ io 1)))
    (veq:f$_ (list (o+- p o i) (o+- p z i) (o-- p o i) (o-+ p o z)
                   (o-+ p o i) (o++ p z i) (o++ p o i) (o++ p o z)
                   (veq:lst p)))))


(veq:vdef path->joints (path w* &key closed
                             &aux (w (* 0.5f0 w*))
                                  (n (round (/ (length path) 2))))
  (declare (veq:fvec path) (veq:ff w w*) (boolean closed))
  " joints contain information about how to offset around points in path. "
  (labels
    ((make-joint (i (veq:varg 2 a p b))
       (veq:f2let ((in (veq:f2norm (veq:f2- p a)))
                   (out (veq:f2norm (veq:f2- b p))))
         (let* ((alpha (- veq:fpi (acos (veq:f2. in out))))
                (s (/ w (veq:ff (sin alpha))))
                (in-out (veq:f$_ (list (veq:lst (veq:f2scale in s))
                                       (veq:lst (veq:f2scale out s))))))

            (-make-joint :w w :i i :alpha alpha :in-out in-out
                         :orientation (ori in-out)
                         :grid (-make-joint-grid p in-out))))) ; FIX

     (make-start ((veq:varg 2 p b))
       (veq:f2let ((out (veq:f2scale (veq:f2norm (veq:f2- b p)) w)))
        (let ((in-out (veq:f$_ (list (veq:lst (veq:f2rot out *pi2*))
                                      (veq:lst out)))))
           (-make-joint :w w :mode :start :alpha *pi2*
             :in-out in-out :grid (-make-joint-grid p in-out)))))

     (make-end (i (veq:varg 2 a p))
       (veq:f2let ((in (veq:f2scale (veq:f2norm (veq:f2- p a)) w)))
         (let ((in-out (veq:f$_ (list (veq:lst in)
                                      (veq:lst (veq:f2rot in (- *pi2*)))))))
           (-make-joint :w w :i i :mode :end :alpha (- *pi2*)
                      :in-out in-out :grid (-make-joint-grid p in-out)))))


     (ci (i) (veq:f2$ path (mod i n)))
     (closed-path->joints ()
       (loop for i from 0 below n
             collect (weird:mvc #'make-joint i
                        (ci (1- i)) (ci i) (ci (1+ i)))))
     (open-path->joints ()
       (loop with init = (weird:mvc #'make-end (1- n)
                           (ci (- n 2)) (ci (1- n)))
             with res = (list init)
             for i from (- n 2) downto 1
             do (push (weird:mvc #'make-joint i
                        (ci (1- i)) (ci i) (ci (1+ i))) res)
             finally (return (cons (weird:mvc #'make-start
                                     (ci 0) (ci 1)) res)))))

    (when (< n (if closed 3 2))
          (error "jpath error: must have at least 2 (open)
                  or 3 (closed) elements. n: ~a~ closed: ~a%" n closed))

    (if closed (closed-path->joints) (open-path->joints))))

(veq:vdef path->diagonals (path w &key closed (limits *limits*))
  (declare (veq:fvec path) (veq:ff w) (boolean closed))
  "
  return (orientation line) for every point in path. lerp-ing along lines will
  return controll points. lerp direction should be flipped when orientation is
  nil.  sharp or chamfered points correspond to two lines
  "
  (let ((joints (to-vector (path->joints path w :closed closed)))
        (res (list))
        (la (first limits))
        (lb (second limits))
        (lc (third limits)))
    (labels
       ((gx (a p) (veq:lst (veq:f2$ (joint-grid (aref joints a)) p)))
        (start (p) (veq:f$_ (list (gx p 1) (gx p 5))))
        (end (p) (veq:f$_ (list (gx p 7) (gx p 3))))
        (joint (p) (veq:f$_ (list (gx p 4) (gx p 0))))
        (soft-1 (p) (veq:f$_ (list (gx p 3) (gx p 0))))
        (soft-2 (p) (veq:f$_ (list (gx p 5) (gx p 0))))
        (chamfer-1 (p) (veq:f$_ (list (gx p 2) (gx p 0))))
        (chamfer-2 (p) (veq:f$_ (list (gx p 6) (gx p 0))))
        (sharp-3 (p) (veq:f$_ (list (gx p 2) (gx p 6))))
        (sharp-4 (p) (veq:f$_ (list (gx p 6) (gx p 2))))
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
             do (case (joint-mode (aref joints i))
                      (:end (push `(,t ,(end i)) res))
                      (:start (push `(,t ,(start i)) res))
                      (:joint (do-joint i))
                      (t (error "jpath error: unknown joint mode: ~a~%"
                                (aref joints i)))))

       ; diagonals: (#(a b) #(c d) ...)
       (reverse res))))


(veq:vdef jpath (path w &key (rep 3) closed (limits *limits*))
  (declare (veq:fvec path) (veq:ff w) (fixnum rep) (boolean closed))
  (let* ((diagonals (to-vector (path->diagonals path w
                                 :closed closed :limits limits)))
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
                        do (destructuring-bind (ori line)
                             (aref diagonals (open-ind i k i- ))
                             (vextend (veq:lst
                                        (veq:f2lerp
                                          (veq:f2$ line 0 1)
                                          (flip? ori s)))
                                      res))))))
      (if closed (closed-path) (open-path))
      (veq:f$_ (to-list res)))))

