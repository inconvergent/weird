
(in-package :rnd)


(veq:vdef* 2on-line ((:varg 2 a b))
  (declare #.*opt* (veq:ff a b))
  (veq:f2from a (veq:f2- b a) (rnd)))

(veq:vdef* 2non-line (n (:varg 2 a b))
  (declare #.*opt* (weird:pos-int n) (veq:ff a b))
  (veq:fwith-arrays (:n n :itr k
    :arr ((arr 2))
    :fxs ((f () (2on-line a b)))
    :exs ((arr k (f))))
    arr))


(veq:vdef* 2in-rect ((:varg 2 s))
  (declare #.*opt* (veq:ff s))
  (values (rnd* (:vref s 0)) (rnd* (:vref s 1))))

(veq:vdef* 2in-square (s)
  (declare #.*opt* (veq:ff s))
  (2in-rect s s))

(veq:vdef* 2nin-rect (n (:varg 2 s))
  (declare #.*opt* (weird:pos-int n) (veq:ff s))
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 2))
    :fxs ((f () (2in-rect s)))
    :exs ((a k (f))))
    a))

(veq:vdef* 2nin-square (n s)
  (declare #.*opt* (weird:pos-int n) (veq:ff s))
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 2))
    :fxs ((f () (2in-square s)))
    :exs ((a k (f))))
    a))


(veq:vdef* 2on-circ (rad)
  (declare #.*opt* (veq:ff rad))
  (veq:f2scale (veq:fcos-sin (rnd veq:fpii)) rad))

(veq:vdef* 2non-circ (n rad)
  (declare #.*opt* (veq:ff rad))
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 2))
    :fxs ((f () (2on-circ rad)))
    :exs ((a k (f))))
    a))

(veq:vdef* 2in-circ (rad)
  (declare #.*opt* (veq:ff rad))
  (let ((a (rnd)) (b (rnd)))
    (declare (veq:ff a b))
    (if (< a b) (setf a (* veq:fpii (/ a b)) b (* b rad))
                (let ((d a)) (setf a (* veq:fpii (/ b a)) b (* d rad))))
    (values (* (cos a) b) (* (sin a) b))))

(veq:vdef* 2nin-circ (n rad)
  (declare #.*opt* (veq:ff rad))
  (veq:fwith-arrays (:n n :itr k
    :arr ((a 2))
    :fxs ((f () (2in-circ rad)))
    :exs ((a k (f))))
    a))

