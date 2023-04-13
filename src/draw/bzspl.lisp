
(in-package :bzspl)

; http://graphics.cs.ucdavis.edu/~joy/ecs178/Unit-7-Notes/MatrixBSpline.pdf

(declaim (veq:ff *lim*))
(defparameter *lim* 0.1)

(defstruct bzspl
  (n nil :type veq:pn :read-only t)
  (ns nil :type veq:pn :read-only t)
  (closed nil :type boolean :read-only t)
  (vpts nil :type veq:fvec :read-only t))


(declaim (inline -do-calc))
(veq:fvdef -do-calc (vpts seg x)
  (declare #.*opt* (veq:fvec vpts) (veq:ff x) (veq:pn seg))
  (veq:xlet ((f!2x (+ x x))
             (f!xe2 (* x x))
             (p!ia (* 2 seg)))
     (labels ((fx ((:va 2 va vb vc))
                (f2!@+ (f2!@*. vc xe2)
                       (f2!@+ (f2!@*. va (+ 1f0 (- 2x) xe2))
                              (f2!@*. vb (+ 2x (* -2f0 xe2)))))))
       (m@fx (veq:f2$ vpts ia (+ ia 1) (+ ia 2))))))

; TODO: wrap around?
(declaim (inline -get-seg))
(defun -get-seg (ns x &aux (s (veq:ff ns)))
  (declare #.*opt* (veq:pn ns) (veq:ff x s))
  (if (>= x 1f0) (values (1- ns) 1f0)
                 (truncate (the veq:ff (* x s)))))

(declaim (inline -x-to-pt))
(veq:fvdef -x-to-pt (vpts ns x)
  (declare #.*opt* (veq:fvec vpts) (veq:pn ns) (veq:ff x))
  (m@-do-calc vpts (-get-seg ns x)))


; TODO: handle closed differently?
(veq:fvdef adaptive-pos (bz &optional (lim *lim*))
  (declare (bzspl bz) (veq:ff lim))
  (with-struct (bzspl- ns vpts) bz
    (declare (veq:pn ns) (veq:fvec vpts))
    (labels
      ((-to-res (pts) (veq:f$_ (map 'list #'second pts)))
       (-resappend (res a (:va 2 av))
         (declare (vector res))
         (if (or (< (length res) 1)
                 (> a (car (weird:vector-last res))))
           (weird:vextend (list a (list av)) res)))
       (-midsample (l r)
         (declare (veq:ff l r))
         (+ (* 0.5f0 (+ r l)) (rnd:rnd* (* 0.2f0 (- r l)))))
       (-area ((:va 2 a b c))
         (declare (veq:ff a b c))
         (* 0.5f0 (+ (* (:vr a 0) (- (:vr b 1) (:vr c 1)))
                     (* (:vr b 0) (- (:vr c 1) (:vr a 1)))
                     (* (:vr c 0) (- (:vr a 1) (:vr b 1))))))
       (-adaptive (l r (:va 2 lv rv) res)
         (veq:xlet ((f!m (-midsample l r))
                    (f2!mv (-x-to-pt vpts ns m)))
           (if (< (abs (-area lv mv rv)) lim)
             (progn (-resappend res l lv)
                    (-resappend res r rv))
             (progn (-adaptive l m lv mv res)
                    (-adaptive m r mv rv res))))))
      (veq:xlet ((f!m (-midsample 0f0 1f0))
                 (res (make-adjustable-vector :type 'list))
                 (f2!mv (-x-to-pt vpts ns m)))
         (declare (vector res))
         (m@-adaptive 0f0 m (-x-to-pt vpts ns 0f0) mv res)
         (m@-adaptive m 1f0 mv (-x-to-pt vpts ns 1f0) res)
         (-to-res res)))))

(veq:fvdef len (bz &optional (lim *lim*))
  (declare (bzspl bz))
  (loop with pts of-type veq:fvec = (adaptive-pos bz lim)
        for i from 0 below (1- (veq:f2$num pts))
        summing (veq:f2dst (veq:f2$ pts i (1+ i))) of-type veq:ff))

(defun pos (bz x)
  (declare #.*opt* (bzspl bz) (veq:ff x))
  (-x-to-pt (bzspl-vpts bz) (bzspl-ns bz) x))

(veq:fvdef pos* (b xx)
  (declare #.*opt* (bzspl b) (list xx))
  (with-struct (bzspl- ns vpts) b
    (declare (veq:pn ns) (veq:fvec vpts))
    (loop with res of-type veq:fvec = (veq:f$make :dim 2 :n (length xx))
          for x of-type veq:ff in xx
          for i of-type veq:pn from 0
          do (veq:2$vset (res i) (-x-to-pt vpts ns x))
          finally (return res))))

(defun rndpos (b n &key order)
  (declare #.*opt* (bzspl b) (veq:pn n))
  (pos* b (rnd:rndspace n 0f0 1f0 :order order)))

(defmacro -set (vpts opts a b)
  `(veq:fvprogn (veq:2$vset (,vpts ,b) (veq:f2$ ,opts ,a))))

(defmacro -set-mean (vpts opts a b c)
  `(veq:fvprogn (veq:2$vset (,vpts ,c)
                  (f2!@/. (f2!@+ (veq:f2$ ,opts ,a ,b)) 2f0))))

(defun -set-vpts-open (vpts pts n &aux (n* (- (* 2 n) 3)))
  (declare #.*opt* (veq:pn n n*) (veq:fvec vpts pts))
  (loop for i of-type veq:pn from 0 below 2
        and k of-type veq:pn from (- n* 2)
        and j of-type veq:pn from (- n 2)
        do (-set vpts pts i i)
           (-set vpts pts j k))
  (loop for i of-type veq:pn from 1 below (- n 2)
        and i+ of-type veq:pn from 1 by 2
        do (-set vpts pts i i+)
           (-set-mean vpts pts i (+ i 1) (+ i+ 1))))

(defun -set-vpts-closed (vpts pts n &aux (n* (+ (* 2 n) 1)))
  (declare #.*opt* (veq:pn n n*) (veq:fvec vpts pts))
  (loop for i of-type veq:pn from 0 below n
        and ii of-type veq:pn from 0 by 2
        do (-set-mean vpts pts i (mod (+ i 1) n) ii)
           (-set vpts pts (mod (+ i 1) n) (+ ii 1))
        finally (-set-mean vpts pts 0 1 (- n* 1))))

(defun make (pts &key closed &aux (n (veq:2$num pts)))
  (declare #.*opt* (veq:fvec pts) (boolean closed) (veq:pn n))
  (assert (>= n 3) (n) "must have at least 3 pts. has ~a." n)
  (let ((vpts (veq:f$make :n (if closed (+ (* 2 n) 1) (- (* 2 n) 3)) :dim 2)))
    (if closed (-set-vpts-closed vpts pts n) (-set-vpts-open vpts pts n))
    (make-bzspl :n n :ns (if closed n (- n 2)) :vpts vpts :closed closed)))

