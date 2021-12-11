
(in-package :bzspl)

; http://graphics.cs.ucdavis.edu/~joy/ecs178/Unit-7-Notes/MatrixBSpline.pdf

(defstruct bzspl
  (n nil :type pos-int :read-only t)
  (ns nil :type pos-int :read-only t)
  (closed nil :type boolean :read-only t)
  (vpts nil :type veq:fvec :read-only t))


(declaim (inline -do-calc))
(veq:vdef -do-calc (vpts x seg)
  (declare #.*opt* (veq:fvec vpts) (veq:ff x) (pos-int seg))
  (let ((2x (+ x x))
        (xe2 (* x x))
        (ia (* 2 seg)))
    (declare (veq:ff 2x xe2) (pos-int ia))
    (labels ((fx ((veq:varg 2 va vb vc))
               (veq:f2+ (veq:f2scale vc xe2)
                        (veq:f2+ (veq:f2scale va (+ 1f0 (- 2x) xe2))
                                 (veq:f2scale vb (+ 2x (* -2f0 xe2)))))))
      (weird:mvc #'fx (veq:f2$ vpts ia (+ ia 1) (+ ia 2))))))

; TODO: wrap around?
(declaim (inline -get-seg))
(defun -get-seg (ns x &aux (s (veq:ff ns)))
  (declare #.*opt* (pos-int ns) (veq:ff x s))
  (if (>= x 1f0) (values (1- ns) 1f0)
                 (the pos-int (truncate (the veq:ff (* x s))))))

(declaim (inline -x-to-pt))
(defun -x-to-pt (vpts ns x)
  (declare #.*opt* (veq:fvec vpts) (pos-int ns) (veq:ff x))
  (weird:mvb (seg xloc) (-get-seg ns x)
    (declare (pos-int seg) (veq:ff xloc))
    (-do-calc vpts xloc seg)))


; TODO: handle closed differently?
; (veq:vdef adaptive-pos (bz &key (lim 0.1d0))
;   (declare (bzspl bz) (veq:ff lim))
;   (with-struct (bzspl- ns vpts) bz
;     (declare (pos-int ns) (veq:fvec vpts))
;     (labels
;       ((-to-res (pts) (veq:f$_ (map 'list #'second pts)))
;        (-resappend (res a (veq:vref 2 av))
;          (declare (vector res))
;          (if (or (< (length res) 1)
;                  (> a (weird:vector-last res)))
;            (weird:vextend (list a (list av)) res)))
;        (-midsample (l r)
;          (declare (veq:ff l r))
;          (+ (* 0.5d0 (+ r l)) (rnd:rnd* (* 0.2d0 (- r l)))))
;        (veq:vdef -area ((veq:varg 2 a b c))
;          (declare (veq:ff a b c))
;          (* 0.5d0 (+ (* (veq:vref a 0) (- (veq:vref b 1) (veq:vref c 2)))
;                      (* (veq:vref b 0) (- (veq:vref c 1) (veq:vref a 2)))
;                      (* (veq:vref c 0) (- (veq:vref a 1) (veq:vref b 2))))))
;        (-adaptive (l r lv rv res)
;          (let ((m (-midsample l r)))
;            (declare (veq:ff m))
;            (veq:f2let ((lv* (if lv lv (-x-to-pt vpts ns l)))
;                        (rv* (if rv rv (-x-to-pt vpts ns r)))
;                        (mv* (-x-to-pt vpts ns m)))
;              (if (< (abs (-area lv* mv* rv*)) lim)
;                (progn (-resappend res l lv*)
;                       (-resappend res r rv*))
;                (progn (-adaptive l m lv* mv* res)
;                       (-adaptive m r mv* rv res)))))))

;       (-to-res (let ((m (-midsample 0d0 1d0))
;                      (res (make-adjustable-vector :type 'list)))
;                  (declare (veq:ff m) (vector res))
;                  (-adaptive 0d0 m res)
;                  (-adaptive m 1d0 res)
;                  res)))))

; TODO: IMPLEMENT ADAPTIVE POS
; (defun len (b)
;   (declare (bzspl b))
;   (loop with pts of-type list = (adaptive-pos b)
;         for a of-type vec:vec in pts
;         and b of-type vec:vec in (cdr pts)
;         summing (vec:dst a b) of-type veq:ff))

(defun pos (bz x)
  (declare #.*opt* (bzspl bz) (veq:ff x))
  (-x-to-pt (bzspl-vpts bz) (bzspl-ns bz) x))

(veq:vdef pos* (b xx)
  (declare #.*opt* (bzspl b) (list xx))
  (with-struct (bzspl- ns vpts) b
    (declare (pos-int ns) (veq:fvec vpts))
    (loop with res of-type veq:fvec = (veq:f$make :dim 2 :n (length xx))
          for x of-type veq:ff in xx
          for i of-type pos-int from 0
          do (veq:2vaset (res i) (-x-to-pt vpts ns x))
          finally (return res))))

(defun rndpos (b n &key order)
  (declare #.*opt* (bzspl b) (pos-int n))
  (pos* b (rnd:rndspace n 0f0 1f0 :order order)))


(defmacro -set (vpts opts a b)
  `(veq:2vaset (,vpts ,b) (veq:f2$ ,opts ,a)))

(defmacro -set-mean (vpts opts a b c)
  `(veq:2vaset (,vpts ,c) (veq:f2iscale (veq:f2+ (veq:f2$ ,opts ,a ,b)) 2f0)))

(veq:vdef -set-vpts-open (vpts pts n &aux (n* (- (* 2 n) 3)))
  (declare #.*opt* (pos-int n n*) (veq:fvec vpts pts))
  (loop for i of-type pos-int from 0 below 2
        and k of-type pos-int from (- n* 2)
        and j of-type pos-int from (- n 2)
        do (-set vpts pts i i)
           (-set vpts pts j k))
  (loop for i of-type pos-int from 1 below (- n 2)
        and i+ of-type pos-int from 1 by 2
        do (-set vpts pts i i+)
           (-set-mean vpts pts i (+ i 1) (+ i+ 1))))

(veq:vdef -set-vpts-closed (vpts pts n &aux (n* (+ (* 2 n) 1)))
  (declare #.*opt* (pos-int n n*) (veq:fvec vpts pts))
  (loop for i of-type pos-int from 0 below n
        and ii of-type pos-int from 0 by 2
        do (-set-mean vpts pts i (mod (+ i 1) n) ii)
           (-set vpts pts (mod (+ i 1) n) (+ ii 1))
        finally (-set-mean vpts pts 0 1 (- n* 1))))

(defun make (pts &key closed &aux (n (veq:2$num pts)))
  (declare #.*opt* (veq:fvec pts) (boolean closed) (pos-int n))
  (assert (>= n 3) (n) "must have at least 3 pts. has ~a." n)
  (let ((vpts (veq:f$make :n (if closed (+ (* 2 n) 1) (- (* 2 n) 3)) :dim 2)))
    (if closed (-set-vpts-closed vpts pts n) (-set-vpts-open vpts pts n))
    (make-bzspl :n n :ns (if closed n (- n 2)) :vpts vpts :closed closed)))

