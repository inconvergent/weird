
(in-package :rnd)


(defmacro prob (p a &optional b)
  "evaluate first form in body with probability p.
second form (optional) is executed with probability 1-p.
ex: (prob 0.1 (print :a) (print :b)) ; returns :a or :b"
  `(if (< (rnd) (the veq:ff ,p)) ,a ,b))

(defmacro prob* (p &body body)
  "evaluate body with probability p. returns the last form as if in a progn.
ex: (prob 0.1 (print :a) (print :b)) ; returns :b"
  `(if (< (rnd) (the veq:ff ,p)) (progn ,@body)))

(defmacro either (a &optional b)
  "excecutes either a or b, with a probablility of 0.5. b is optional."
  `(prob 0.5f0 ,a ,b))


; TODO: sum to 1?
(defmacro rcond (&rest clauses)
  "executes the forms in clauses according to the probability of the weighted sum
ex: (rcond (0.1 (print :a)) (0.3 (print :b)) ...)
will print :a 1 times out of 4."
  (weird:awg (val)
    (let* ((tot 0f0)
           (clauses (loop for (p . body) in clauses
                          do (incf tot (veq:ff p))
                          collect `((< ,val ,tot) ,@body))))
      (declare (veq:ff tot) (list clauses))
      `(let ((,val (rnd ,tot)))
         (declare (veq:ff ,val))
         (cond ,@clauses)))))

(defmacro rep (a &optional b &body body)
  "repeat body at most a times, or between a and b times."
  `(loop repeat ,(if (and a b) `(rndrngi ,a ,b) `(rndi ,a))
         do (progn ,@body)))

