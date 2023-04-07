
(in-package :canvas)


(defmacro -do-op ((canv size vals indfx) &body body)
  (declare (symbol canv size vals indfx))
  (alexandria:with-gensyms (sname)
    `(let* ((,sname ,canv)
            (,size (canvas-size ,sname))
            (,vals (canvas-vals ,sname))
            (,indfx (canvas-indfx ,sname)))
      (declare (veq:fvec ,vals) (function ,indfx) (small-ind ,size)
               (ignorable ,size))
      (progn ,@body))))

(defmacro -square-loop ((x y n) &body body)
  (declare (symbol x y n))
  (alexandria:with-gensyms (nname)
    `(let ((,nname ,n))
      (loop for ,y of-type small-ind from 0 below ,nname
            do (loop for ,x of-type small-ind from 0 below ,nname
                     do (progn ,@body))))))

(defstruct canvas
  (size nil :type small-ind :read-only t)
  (vals nil :type veq:fvec :read-only t)
  (indfx nil :type function :read-only t))


(declaim (inline set-pix))
(defun set-pix (canv i j r g b)
  (declare #.*opt* (veq:pn i j) (veq:ff r g b))
  "set (i j) to value (r g b) where 0.0 =< r,g,b =< 1.0."
  (-do-op (canv size vals indfx)
    (let ((ind (funcall indfx i j)))
      (declare (veq:pn ind))
      (setf (aref vals ind) (max 0f0 (min 1f0 r))
            (aref vals (1+ ind)) (max 0f0 (min 1f0 g))
            (aref vals (+ ind 2)) (max 0f0 (min 1f0 b)))
      nil)))

(declaim (inline set-gray-pix))
(defun set-gray-pix (canv i j c)
  (declare #.*opt* (veq:pn i j) (veq:ff c))
  "set (i j) to value c where 0.0 =< c =< 1.0."
  (-do-op (canv size vals indfx)
    (let ((ind (funcall indfx i j))
          (c* (max 0f0 (min 1f0 c))))
      (declare (veq:pn ind) (veq:ff c*))
      (setf (aref vals ind) c*
            (aref vals (1+ ind)) c*
            (aref vals (+ ind 2)) c*)
      nil)))

(defun get-size (canv) (canvas-size canv))

(defun -get-indfx (size)
  (declare #.*opt* (small-ind size))
  (labels ((-indfx (s x y c)
             (declare #.*opt* (small-ind s x y c))
             (+ c (the veq:pn
                       (* 3 (the veq:pn (+ x (the veq:pn (* s y))))))))
           (indfx (x y &optional (c 0))
             (declare (small-ind x y c))
             (-indfx size x y c)))
    #'indfx))

(defun make (&key (size 1000))
  (declare #.*opt*)
  "make square PNG canvas instance of size to."
  (make-canvas
    :size size :vals (veq:f3$zero (* size size)) :indfx (-get-indfx size)))


(declaim (inline -png-vals))
(defun -png-vals (indfx vals x y g)
  (declare #.*opt* (function indfx) (fixnum x y) (veq:ff g) (veq:fvec vals))
  (labels
    ((-scale-convert (v &key (s 1f0) (gamma 1f0))
       (declare (veq:ff v s gamma))
       (setf v (expt (abs (the veq:ff (max 0f0 (the veq:ff (/ v s))))) gamma)))
     (-u8 (v)
       (declare (veq:ff v))
       (the fixnum (cond ((>= v 1f0) 255)
                         ((<= v 0f0) 0)
                         (t (values (floor (the veq:ff (* 255f0 v)))))))))

    (let ((ind (funcall indfx x y)))
      (declare (veq:pn ind))
      (values (-u8 (-scale-convert (aref vals ind) :gamma g))
              (-u8 (-scale-convert (aref vals (1+ ind)) :gamma g))
              (-u8 (-scale-convert (aref vals (+ ind 2)) :gamma g))))))

(defun -save8 (canv fn &key gamma)
  (declare #.*opt*)
  (-do-op (canv size vals indfx)
    (let ((png (make-instance 'zpng::pixel-streamed-png
                 :color-type :truecolor :width size :height size)))
      (with-open-file (fstream (weird:ensure-filename fn ".png")
                        :direction :output :if-exists :supersede
                        :if-does-not-exist :create
                        :element-type '(unsigned-byte 8))
        (zpng:start-png png fstream)
        (-square-loop (x y size)
          (weird:mvb (r g b) (-png-vals indfx vals x y gamma)
            (declare (fixnum r g b))
            (zpng:write-pixel (list r g b) png)))
        (zpng:finish-png png)))))

(defun save (canv fn &key (gamma 1f0))
  (declare (canvas canv) (veq:ff gamma))
  "save as 8 bit PNG file fn with gamma."
  (-save8 canv fn :gamma gamma))

