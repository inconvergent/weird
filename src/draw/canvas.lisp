
(in-package :canvas)

(deftype small-int (&optional (size 30000)) `(integer 0 ,size))
(deftype pos-int (&optional (bits 31)) `(unsigned-byte ,bits))
(deftype pos-float () `(single-float 0f0 *))


(defmacro -do-op ((canv size vals indfx) &body body)
  (declare (symbol canv size vals indfx))
  (alexandria:with-gensyms (sname)
    `(let* ((,sname ,canv)
            (,size (canvas-size ,sname))
            (,vals (canvas-vals ,sname))
            (,indfx (canvas-indfx ,sname)))
      (declare (type (simple-array single-float) ,vals)
               (function ,indfx) (small-int ,size) (ignorable ,size))
      (progn ,@body))))

(defmacro -square-loop ((x y n) &body body)
  (declare (symbol x y n))
  (alexandria:with-gensyms (nname)
    `(let ((,nname ,n))
      (loop for ,y of-type small-int from 0 below ,nname
            do (loop for ,x of-type small-int from 0 below ,nname
                     do (progn ,@body))))))


(declaim (inline -indfx))
(defun -indfx (s x y c)
  (declare (small-int s x y c))
  (+ c (the pos-int (* 3 (the pos-int (+ x (the pos-int (* s y))))))))

(defun -get-indfx (size)
  (declare (small-int size))
  (lambda (x y &optional (c 0))
    (declare (small-int x y c))
    (-indfx size x y c)))


(defstruct canvas
  (size nil :type small-int :read-only t)
  (vals nil :type (simple-array single-float) :read-only t)
  (indfx nil :type function :read-only t))


(defun make-rgb-array (size &key (init 0f0))
  (declare (small-int size))
  (make-array (* size size 3)
    :adjustable nil :initial-element init :element-type 'single-float))


(declaim (inline set-pix))
(defun set-pix (canv i j r g b)
  (declare (pos-int i j) (single-float r g b))
  "set (i j) to value (r g b) where 0.0 =< r,g,b =< 1.0."
  (-do-op (canv size vals indfx)
    (let ((ind (funcall indfx i j)))
      (declare (pos-int ind))
      (setf (aref vals ind) (max 0f0 (min 1f0 r))
            (aref vals (1+ ind)) (max 0f0 (min 1f0 g))
            (aref vals (+ ind 2)) (max 0f0 (min 1f0 b)))
      nil)))

(declaim (inline set-gray-pix))
(defun set-gray-pix (canv i j c)
  (declare (pos-int i j) (single-float c))
  "set (i j) to value c where 0.0 =< c =< 1.0."
  (-do-op (canv size vals indfx)
    (let ((ind (funcall indfx i j))
          (c* (max 0f0 (min 1f0 c))))
      (declare (pos-int ind) (single-float c*))
      (setf (aref vals ind) c*
            (aref vals (1+ ind)) c*
            (aref vals (+ ind 2)) c*)
      nil)))

(defun get-size (canv) (canvas-size canv))


(declaim (inline -u8))
(defun -u8 (v)
  (declare (single-float v))
  (cond ((>= v 1f0) 255)
        ((<= v 0f0) 0)
        (t (floor (* 255f0 v)))))


(declaim (inline -scale-convert))
(defun -scale-convert (v &key (s 1f0) (gamma 1f0))
  (declare (single-float s gamma))
  (setf v (expt (the pos-float (max 0f0 (/ v s))) gamma)))

(declaim (inline -png-vals))
(defun -png-vals (indfx vals x y g)
  (declare (function indfx)
                            (type (simple-array single-float) vals)
                            (fixnum x y) (single-float g))
  (let ((ind (funcall indfx x y)))
    (declare (pos-int ind))
    (values (-u8 (-scale-convert (aref vals ind) :gamma g))
            (-u8 (-scale-convert (aref vals (1+ ind)) :gamma g))
            (-u8 (-scale-convert (aref vals (+ ind 2)) :gamma g)))))


(defun make (&key (size 1000))
  "make square PNG canvas instance of size to."
  (make-canvas
    :size size :vals (make-rgb-array size) :indfx (-get-indfx size)))


(defun -save8 (canv fn &key gamma)
  (-do-op (canv size vals indfx)
    (let ((png (make-instance 'zpng::pixel-streamed-png
                              :color-type :truecolor
                              :width size
                              :height size)))
      (with-open-file
        (fstream (weird:ensure-filename fn ".png")
                 :direction :output :if-exists :supersede
                 :if-does-not-exist :create :element-type '(unsigned-byte 8))
        (declare (stream fstream))
        (zpng:start-png png fstream)
        (-square-loop (x y size)
          (multiple-value-bind (r g b) (-png-vals indfx vals x y gamma)
            (declare (fixnum r g b))
            (zpng:write-pixel (list r g b) png)))
        (zpng:finish-png png)))))


(defun save (canv fn &key (gamma 1f0))
  (declare (canvas canv) (single-float gamma))
  "save as 8 bit PNG file fn with gamma."
  (-save8 canv fn :gamma gamma))

