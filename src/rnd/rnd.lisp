(in-package :rnd)


(defun make-rnd-state ()
  "generate a new random state."
  (setf *random-state* (make-random-state t)))

(defun set-rnd-state (&optional i)
  "use this random seed. only implemented for SBCL."
   #+SBCL (if i (setf *random-state* (sb-ext:seed-random-state (the number i)))
                (make-rnd-state))
   #-SBCL (warn
"rnd:state is only implemented for SBCL. see src/rnd.lisp
to implement state for your environment."))

; NUMBERS AND RANGES

(declaim (inline rndi))
(defun rndi (a)
  (declare #.*opt* (fixnum a))
  "random fixnum in range (0 a]."
  (the fixnum (random a)))

(declaim (inline nrndi))
(defun nrndi (n a)
  (declare #.*opt* (veq:pn n a))
  "n random fixnums in range: (0 a]."
  (loop repeat n collect (rndi a) of-type fixnum))


(declaim (inline rndrngi))
(defun rndrngi (a b)
  (declare #.*opt* (fixnum a b))
  "random fixnum in range (a b]."
  (+ a (rndi (- b a))))

(declaim (inline nrndrngi))
(defun nrndrngi (n a b)
  (declare #.*opt* (veq:pn n) (fixnum a b))
  "n fixnums in range [a b)."
  (let ((d (- b a)))
    (declare (fixnum d))
    (loop repeat n collect (+ a (rndi d)) of-type fixnum)))


(declaim (inline rnd))
(defun rnd (&optional (x 1f0))
  (declare (optimize speed (safety 0)) (veq:ff x))
  "random float below x."
  (random x))

(declaim (inline nrnd))
(defun nrnd (n &optional (x 1f0))
  (declare #.*opt* (veq:pn n) (veq:ff x))
  "n random floates below x."
  (loop repeat n collect (rnd x) of-type veq:ff))


(declaim (inline rnd*))
(defun rnd* (&optional (x 1f0))
  (declare (optimize speed (safety 0)) (veq:ff x))
  "random float in range (-x x)."
  (- x (rnd (* 2f0 x))))

(declaim (inline nrnd*))
(defun nrnd* (n &optional (x 1f0))
  (declare #.*opt* (veq:pn n) (veq:ff x))
  "n random floats in range (x -x)."
  (loop repeat n collect (rnd* x) of-type veq:ff))


(declaim (inline rndrng))
(defun rndrng (a b)
  (declare (optimize speed (safety 0)) (veq:ff a b))
  "random float in range (a b)."
  (+ a (rnd (- b a))))

(declaim (inline nrndrng))
(defun nrndrng (n a b)
  (declare #.*opt* (veq:pn n) (veq:ff a b))
  "n random floats in range (a b)."
  (loop repeat n collect (rndrng a b) of-type veq:ff))


; https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
(declaim (inline norm))
(defun norm (&key (mu 0f0) (sigma 1f0))
  (declare #.*opt* (veq:ff mu sigma))
  "two random numbers from normal distribution with (mu 0f0) and (sigma 1f0).
generated using the box-muller transform."
  (let ((s (* sigma (the veq:ff
                         (sqrt (the veq:pos-ff
                                    (* -2f0 (log (rnd))))))))
        (u (rnd veq:fpii)))
    (declare (veq:ff s u))
    (values (+ mu (* s (cos u)))
            (+ mu (* s (sin u))))))


; GENERIC

(defun rndget (l)
  (declare #.*opt* (sequence l))
  "get random item from sequence l."
  (typecase l (cons (nth (rndi (length (the list l))) l))
              (vector (aref l (rndi (length l))))
              (t (error "incorrect type in rndget: ~a" l))))


(defun rndspace (n a b &key order &aux (d (- b a)))
  (declare #.*opt* (veq:pn n) (veq:ff a b d))
  "n random numbers in range (a b). use :order t to sort result."
  (if order (sort (loop repeat n collect (+ a (rnd d)) of-type veq:ff) #'<)
            (loop repeat n collect (+ a (rnd d)) of-type veq:ff)))


(defun rndspacei (n a b &key order &aux (d (- b a)))
  (declare #.*opt* (veq:pn n) (fixnum a b d))
  "n random fixnums in range [a b). use order to sort result."
  (if order (sort (loop repeat n collect (+ a (rndi d)) of-type fixnum) #'<)
            (loop repeat n collect (+ a (rndi d)) of-type fixnum)))


(defun bernoulli (n p)
  (declare #.*opt* (veq:pn n) (veq:ff p))
  "n random numbers from bernoulli distribution with mean p."
  (loop repeat n collect (prob p 1f0 0f0) of-type veq:ff))


; https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
(defun shuffle (a* &aux (n (length a*)))
  (declare #.*opt* (veq:pn n) (simple-array a*))
  "shuffle a with fisher yates algorithm."
  (loop for i of-type veq:pn from 0 to (- n 2)
        do (rotatef (aref a* i) (aref a* (rndrngi i n))))
  a*)


(defun nrnd-from (n a)
  (declare #.*opt* (veq:pn n) (vector a))
  "n random elements from a."
  (loop for i in (nrndi n (length a)) collect (aref a i)))

(defun nrnd-from* (n a)
  (declare #.*opt* (veq:pn n) (vector a))
  "n random distinct elements from a. assumes no dupes in a."
  (let* ((a* (ensure-vector a))
         (resind nil)
         (anum (length (the simple-array a*))))
    (when (> n anum) (error "not enough distinct elements in a."))
    (loop until (>= (hset:num (hset:make :init resind)) n)
          do (setf resind (nrndi n anum)))
    (loop for i in resind collect (aref a* i))))


; TODO: port this
; some version of mitchell's best candidate algorithm
; https://bl.ocks.org/mbostock/1893974/c5a39633db9c8b1f12c73b069e002c388d4cb9bf
; TODO: make n the max number instead of the new sample number
; (defun max-distance-sample (n fx &key (sample-num 50) (dstfx #'vec:dst2)
;                                       (res (weir-utils:make-adjustable-vector)))
;   (declare (fixnum n sample-num) (function fx dstfx) (array res))
;   "
;   randomly sample a total of n items using (funcall fx sample-num), selecting
;   the element furthest from existing elemets.
;   example:

;     (rnd:max-distance-sample 100
;       (lambda (g) (rnd:nin-circ g 400f0)))
;   "
;   (labels ((-get-cand (c) (second (first c)))
;            (-closest (res* c) (loop for v across res*
;                                     minimizing (funcall dstfx v c))))
;     (loop with wanted-length of-type fixnum = (+ n (length res))
;           until (>= (length res) wanted-length)
;           do (weir-utils:vextend
;                (-get-cand (sort (loop for c in (funcall fx sample-num)
;                                       collect (list (-closest res c) c))
;                           #'> :key #'first))
;                res))
;     res))

