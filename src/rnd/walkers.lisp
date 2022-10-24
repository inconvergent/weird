
(in-package :rnd)


(defun walker (&optional (x 0f0))
  (declare #.*opt* (veq:ff x))
  "random walker."
  (lambda (s) (declare (veq:ff s))
    (incf x (rnd* s))))

(defun walker-acc (&optional (x 0f0) (a 0f0))
  (declare #.*opt* (veq:ff x a))
  "accelerated random walker."
  (lambda (s) (declare (veq:ff s))
    (incf a (rnd* s))
    (values (incf x a) a)))


(veq:fvdef* 2walker ((:va 2 x))
  (declare #.*opt* (veq:ff x))
  "random 2d walker."
  (lambda (s) (declare (veq:ff s))
    (veq:f2vset (x) (veq:f2+ x (2in-circ s)))
    (veq:f2 x)))

(veq:fvdef* 2walker-acc ((:va 2 x a))
  (declare #.*opt* (veq:ff x a))
  "accelerated random 2d walker."
  (lambda (s) (declare (veq:ff s))
    (veq:f2vset (a) (veq:f2+ a (2in-circ s)))
    (veq:f2vset (x) (veq:f2+ x a))
    (values x a)))


(veq:fvdef* 3walker ((:va 3 x))
  (declare #.*opt* (veq:ff x))
  "random 3d walker."
  (lambda (s)
    (declare (veq:ff s))
    (veq:f3vset (x) (veq:f3+ x (3in-sphere s)))
    (veq:f3 x)))

(veq:fvdef* 3walker-acc ((:va 3 x a))
  (declare #.*opt* (veq:ff x a))
  "accelerated random 3d walker."
  (lambda (s)
    (declare (veq:ff s))
    (veq:f3vset (a) (veq:f3+ a (3in-sphere s)))
    (veq:f3vset (x) (veq:f3+ x a))
    (values x a)))

