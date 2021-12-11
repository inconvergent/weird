
(in-package :pigment)

"""Colors are stored internally with premultiplied alpha."""

; TODO: consider rewriting to utilize :veq

(defmacro with ((c r g b a) &body body)
  (alexandria:with-gensyms (c*)
    `(let* ((,c* ,c)
            (,r (rgba-r ,c*))
            (,g (rgba-g ,c*))
            (,b (rgba-b ,c*))
            (,a (rgba-a ,c*)))
      (declare (veq:ff ,r ,g ,b ,a))
      (progn ,@body))))


(defmacro -with ((c r g b a) &body body)
  (alexandria:with-gensyms (c*)
    `(let* ((,c* ,c)
            (,a (rgba-a ,c*))
            (,r (/ (rgba-r ,c*) ,a))
            (,g (/ (rgba-g ,c*) ,a))
            (,b (/ (rgba-b ,c*) ,a)))
      (declare (veq:ff ,r ,g ,b ,a))
      (progn ,@body))))


(defstruct (rgba (:constructor make-rgba) (:constructor -make-rgba (r g b a)))
  (r 0f0 :type veq:ff :read-only nil)
  (g 0f0 :type veq:ff :read-only nil)
  (b 0f0 :type veq:ff :read-only nil)
  (a 1f0 :type veq:ff :read-only nil))

(weird:define-struct-load-form rgba)
#+SBCL(declaim (sb-ext:freeze-type rgba))


(defun make (r g b &optional (a 1f0))
  (declare #.*opt* (veq:ff r g b a))
  (-make-rgba (* a r) (* a g) (* a b) a))

(defun copy (c)
  (declare #.*opt* (rgba c))
  (-make-rgba (rgba-r c) (rgba-g c) (rgba-b c) (rgba-a c)))

(defun to-list (c)
  (declare #.*opt* (rgba c))
  (let ((a (rgba-a c)))
    (list (/ (rgba-r c) a) (/ (rgba-g c) a) (/ (rgba-b c) a) a)))

(defun to-list* (c)
  (declare #.*opt* (rgba c))
  (list (rgba-r c) (rgba-g c) (rgba-b c) (rgba-a c)))


(defun white (&optional (a 1f0))
  (declare #.*opt* (veq:ff a))
  (make 1f0 1f0 1f0 a))

(defun black (&optional (a 1f0))
  (declare #.*opt* (veq:ff a))
  (make 0f0 0f0 0f0 a))

(defun red (&optional (a 1f0))
  (declare #.*opt* (veq:ff a))
  (make 1f0 0f0 0f0 a))

(defun green (&optional (a 1f0))
  (declare #.*opt* (veq:ff a))
  (make 0f0 1f0 0f0 a))

(defun blue (&optional (a 1f0))
  (declare #.*opt* (veq:ff a))
  (make 0f0 0f0 1f0 a))

(defun mdark (&optional (a 1f0))
  (declare #.*opt* (veq:ff a))
  (make 0.3f0 0.3f0 0.3f0 a))

(defun dark (&optional (a 1f0))
  (declare #.*opt* (veq:ff a))
  (make 0.2f0 0.2f0 0.2f0 a))

(defun vdark (&optional (a 1f0))
  (declare #.*opt* (veq:ff a))
  (make 0.1f0 0.1f0 0.1f0 a))

(defun gray (v &optional (a 1f0))
  (declare #.*opt* (veq:ff v a))
  (make v v v a))

(defun transparent ()
  (declare #.*opt*)
  (make 0f0 0f0 0f0 0f0))


(defun rgb (r g b &optional (a 1f0))
  (declare #.*opt* (veq:ff r g b a))
  (make r g b a))


(defun scale (c s)
  (declare #.*opt* (rgba c) (veq:ff s))
  (-make-rgba (* (rgba-r c) s) (* (rgba-g c) s)
              (* (rgba-b c) s) (* (rgba-a c) s)))

(defun scale! (c s)
  (declare #.*opt* (rgba c) (veq:ff s))
  (setf (rgba-r c) (* (rgba-r c) s) (rgba-g c) (* (rgba-g c) s)
        (rgba-b c) (* (rgba-b c) s) (rgba-a c) (* (rgba-a c) s))
  c)

(defun to-hex (c)
  (declare #.*opt* (rgba c))
  (labels ((-hex (d)
             (declare #.*opt* (veq:ff d))
             (format nil "~2,'0d" (min 255 (max 0 (floor (veq:ff (* d 256))))))))
    (weird:dsb (r g b a) (to-list c)
    (declare #.*opt* (veq:ff r g b a))
    (values (format nil "#~a~a~a" (-hex r) (-hex g) (-hex b)) a))))


(defun cmyk (c m y k &optional (a 1f0))
  (declare #.*opt* (veq:ff c m y k a))
  (let ((ik (- 1f0 k)))
    (declare (veq:ff ik))
    (make (* (- 1f0 c) ik) (* (- 1f0 m) ik) (* (- 1f0 y) ik) a)))

(defun hsv (h s v &optional (a 1f0))
  (declare #.*opt* (veq:ff h s v a))
  (let* ((c (* v s))
         (x (* c (- 1f0 (abs (- (mod (* 6f0 h) 2f0) 1f0)))))
         (m (- v c)))
    (declare (veq:ff c x m))
    (weird:mvb (r g b)
      (case (floor (mod (* h 6f0) 6f0))
        (0 (values (+ c m) (+ x m) m))
        (1 (values (+ x m) (+ c m) m))
        (2 (values m (+ c m) (+ x m)))
        (3 (values m (+ x m) (+ c m)))
        (4 (values (+ x m) m (+ c m)))
        (5 (values (+ c m) m (+ x m)))
        (t (values 0f0 0f0 0f0)))
      (declare (veq:ff r g b))
      (make r g b a))))

(defun as-hsv (c)
  (declare #.*opt* (rgba c))
  (labels ((-mod (ca cb df p)
             (declare #.*opt* (veq:ff ca cb df p))
             ;(mod a b) is remainder of (floor a b)
             (weird:mvb (_ res)
               (floor (the veq:ff (+ p (* 0.16666667
                                          (/ (the veq:ff (- ca cb)) df)))))
               (declare (ignore _) (veq:ff res))
               res)))
    (-with (c r g b a)
      (let ((rgb (list r g b)))
        (declare (list rgb))
        (weird:mvb (imn mn) (math:argmin rgb)
          (declare (fixnum imn) (veq:ff mn))
          (weird:mvb (imx mx) (math:argmax rgb)
            (declare (fixnum imx) (veq:ff mx))
            (let ((df (- mx mn)))
              (declare (veq:ff df))
              (list (cond ((= imn imx) 0f0)
                          ((= imx 0) (-mod g b df 1f0))
                          ((= imx 1) (-mod b r df 0.33333334))
                          ((= imx 2) (-mod r g df 0.6666667)))
                    (if (<= mx 0f0) 0f0 (/ df mx))
                    mx
                    a))))))))

(defun magenta (&key (sat 0.8f0) (val 0.85f0) (alpha 1f0))
  (hsv #.(/ 281f0 360f0) sat val alpha))

(defun cyan (&key (sat 0.8f0) (val 0.85f0) (alpha 1f0))
  (hsv #.(/ 196f0 360f0) sat val alpha))

(defun orange (&key (sat 0.8f0) (val 0.85f0) (alpha 1f0))
  (hsv #.(/ 38f0 360f0) sat val alpha))

(defun blood (&key (sat 0.8f0) (val 0.85f0) (alpha 1f0))
  (hsv #.(/ 362f0 360f0) sat val alpha))

