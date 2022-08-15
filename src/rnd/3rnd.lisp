
(in-package :rnd)

(veq:fvprogn

(veq:def* 3on-line ((:varg 3 a b))
  (declare #.*opt* (veq:ff a b))
  "random point between a,b."
  (veq:f3from a (veq:f3- b a) (rnd)))

(veq:def* 3non-line (n (:varg 3 a b))
  (declare #.*opt* (veq:ff a b))
  "n random points between a,b."
  (veq:fwith-arrays (:n n :itr k
    :arr ((arr 3))
    :fxs ((f () (3on-line a b)))
    :exs ((arr k (f))))
    arr))


(veq:def* 3in-box ((:varg 3 s))
  (declare #.*opt* (veq:ff s))
  "random point in box of size sx,sy,sz. centered at origin."
  (values (rnd* (:vref s 0))
          (rnd* (:vref s 1))
          (rnd* (:vref s 2))))

(veq:def* 3in-cube (&optional (s 1f0))
  (declare #.*opt* (veq:ff s))
  "random point in cube of size s. centered at origin."
  (3in-box s s s))

(veq:def* 3nin-box (n (:va 3 s))
  (declare #.*opt* (veq:ff s))
  "n random points in box of size sx,sy,sz. centered at origin."
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 3))
    :fxs ((f () (3in-box s)))
    :exs ((a k (f))))
    a))

(defun 3nin-cube (n &optional (s 1f0))
  (declare #.*opt* (veq:ff s))
  "n random points in cube of size sx. centered at origin."
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 3))
    :fxs ((f () (3in-cube s)))
    :exs ((a k (f))))
    a))


(declaim (inline 3on-sphere-slow))
(defun 3on-sphere-slow (&optional (r 1f0))
  (declare #.*opt* (veq:ff r))
  "random point on sphere with rad r. centered at origin. slower than 3on-sphere."
  (labels ((-norm (&aux (s (sqrt (abs (* 2f0 (log (rnd))))))
                        (u (rnd veq:fpii)))
             (declare (veq:ff s u))
             (values (* s (cos u)) (* s (sin u)))))
    (mvb (a b) (-norm)
      (declare (veq:ff a b))
      (let ((c (-norm)))
        (declare (veq:ff c))
        (veq:f3scale a b c (/ r (veq:f3len a b c)))))))

(declaim (inline 3on-sphere))
(defun 3on-sphere (&optional (r 1f0))
  (declare (optimize speed (safety 0)) (veq:ff r))
  "random point on sphere with rad r. centered at origin."
  (let* ((th (* veq:fpii (rnd:rnd)))
         (la (- (the veq:ff (acos (- (* 2.0 (rnd:rnd)) 1f0))) veq:fpi5))
         (co (* r (cos la))))
    (declare (veq:ff th la co))
    (values (* co (cos th)) (* co (sin th)) (* r (sin la)))))

(declaim (inline 3in-sphere))
(defun 3in-sphere (&optional (r 1f0))
  (declare (optimize speed (safety 0)) (veq:ff r))
  "random point in sphere with rad r. centered at origin."
  (veq:f3let ((cand (values 0f0 0f0 0f0)))
    (loop while t
          do (veq:f3vset (cand) (veq:f3rep (rnd*)))
             (when (< (veq:f3len2 cand) 1f0)
                   (return-from 3in-sphere
                     (veq:f3scale cand r))))))

(defun 3non-sphere (n &optional (r 1f0))
  (declare #.*opt* (veq:ff r))
  "n random points on sphere with rad r. centered at origin."
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 3))
    :fxs ((f () (3on-sphere r)))
    :exs ((a k (f))))
    a))

(veq:def* 3nin-sphere (n &optional (r 1f0))
  (declare #.*opt* (veq:ff r))
  "n random points in sphere with rad r. centered at origin."
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 3))
    :fxs ((f () (3in-sphere r)))
    :exs ((a k (f))))
    a)))

