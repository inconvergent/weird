
(in-package :rnd)

(veq:vdef* 3on-line ((veq:varg 3 a b))
  (declare #.*opt* (veq:ff a b))
  (veq:f3from a (veq:f3- b a) (rnd)))

(veq:vdef* 3non-line (n (veq:varg 3 a b))
  (declare #.*opt* (veq:ff a b))
  (veq:fwith-arrays (:n n :itr k
    :arr ((arr 3))
    :fxs ((f () (3on-line a b)))
    :exs ((arr k (f))))
    arr))


(veq:vdef* 3in-box ((veq:varg 3 s))
  (declare #.*opt* (veq:ff s))
  (values (rnd* (veq:vref s 0))
          (rnd* (veq:vref s 1))
          (rnd* (veq:vref s 2))))

(veq:vdef* 3in-cube (s)
  (declare #.*opt* (veq:ff s))
  (3in-box s s s))

(veq:vdef* 3nin-box (n (veq:varg 3 s))
  (declare #.*opt* (veq:ff s))
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 3))
    :fxs ((f () (3in-box s)))
    :exs ((a k (f))))
    a))

(veq:vdef* 3nin-cube (n s)
  (declare #.*opt* (veq:ff s))
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 3))
    :fxs ((f () (3in-cube s)))
    :exs ((a k (f))))
    a))


(veq:vdef* 3on-sphere (rad)
  (declare #.*opt* (veq:ff rad))
  (mvb (a b) (norm)
    (declare (veq:ff a b))
    (let ((c (norm)))
      (declare (veq:ff c))
      (veq:f3scale a b c (/ rad (veq:f3len a b c))))))

(veq:vdef* 3in-sphere (rad)
  (declare #.*opt* (veq:ff rad))
  (veq:f3let ((cand (values 0f0 0f0 0f0)))
    (loop while t
          do (veq:f3vset cand (values (rnd*) (rnd*) (rnd*)))
             (when (< (veq:f3len2 cand) 1f0)
                   (return-from 3in-sphere
                     (veq:f3scale cand rad))))))

(veq:vdef* 3non-sphere (n rad)
  (declare #.*opt* (veq:ff rad))
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 3))
    :fxs ((f () (3on-sphere rad)))
    :exs ((a k (f))))
    a))

(veq:vdef* 3nin-sphere (n rad)
  (declare #.*opt* (veq:ff rad))
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 3))
    :fxs ((f () (3in-sphere rad)))
    :exs ((a k (f))))
    a))

