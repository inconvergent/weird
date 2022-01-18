
(in-package :ortho)

"
Simple orthographic projection with camera position (cam), view vector (vpn)
view plane offset (xy) and scaling (s).
"

(defun 2rep (&optional (v 0f0)) (list v v))
(defun 3rep (&optional (v 0f0)) (list v v v))

(declaim (inline from-list))
(defun from-list (l) (declare #.*opt* (list l)) (apply #'values l))

(veq:vdef 3identity ((:varg 3 x)) (values x))


(defstruct (ortho)
  (vpn nil :type list :read-only nil) ; away from dop
  (up nil :type list :read-only nil) ; cam up
  (cam nil :type list :read-only nil) ; cam position
  (u nil :type list :read-only nil) ; view plane horizontal
  (v nil :type list :read-only nil) ; view plane vertical
  (su nil :type list :read-only nil) ; u scaled by s
  (sv nil :type list :read-only nil) ; v scaled by s
  (xy nil :type list :read-only nil) ; view plane offset
  (s 1f0 :type veq:ff :read-only nil) ; scale
  (raylen 5000f0 :type veq:ff :read-only nil)
  (projfx #'3identity :type function :read-only nil)
  (dstfx #'3identity :type function :read-only nil)
  (rayfx #'3identity :type function :read-only nil))


(veq:vdef -get-u-v (up* vpn* s)
  (declare #.*opt* (list up* vpn*) (veq:ff s))
  (veq:f3let ((up (from-list up*))
              (vpn (from-list vpn*)))

    (unless (< (abs (veq:f3. up vpn)) #.(- 1f0 veq:*eps*))
            (error "ortho: gimbal lock. up: ~a vpn: ~a" up* vpn*))

    (veq:f3let ((v (veq:f3norm (veq:f3neg (veq:f3from up vpn
                                            (- (veq:f3. up vpn))))))
                (u (veq:f3rot v vpn veq:fpi5)))
      (declare (veq:ff u v))
      (values (list u) (list v) (veq:lst (veq:f3scale u s))
              (veq:lst (veq:f3scale v s))))))


(veq:vdef -look (cam look)
  (declare #.*opt* (list cam look))
  (veq:lst (veq:f3norm (veq:f3- (from-list cam) (from-list look)))))


(veq:vdef make-dstfx (proj)
  (declare #.*opt*)
  "distance from pt to camera plane with current parameters"
  (veq:f3let ((cam (from-list (ortho-cam proj)))
              (vpn (from-list (ortho-vpn proj))))
    (lambda ((:varg 3 pt)) (declare (veq:ff pt))
      (weird:mvb (hit d) (veq:f3planex vpn cam pt (veq:f3+ pt vpn))
        (declare (boolean hit) (veq:ff d))
        (if hit d 0f0)))))


(veq:vdef make-projfx (proj)
  (declare #.*opt*)
  "function to project pt into 2d with current parameters"
  (veq:f3let ((su (from-list (ortho-su proj)))
              (sv (from-list (ortho-sv proj)))
              (cam (from-list (ortho-cam proj))))
    (weird:mvb (x y) (from-list (ortho-xy proj))
      (declare (veq:ff x y))
      (lambda ((:varg 3 pt))
        (declare #.*opt* (veq:ff pt))
        (veq:f3let ((pt* (veq:f3- pt cam)))
          (veq:f2 (+ x (veq:f3. su pt*)) (+ y (veq:f3. sv pt*))))))))


(veq:vdef make-rayfx (proj)
  (declare #.*opt* (ortho proj))
  "cast a ray in direction -vpn from pt"
  (veq:f3let ((dir (veq:f3scale (veq:f3neg (from-list (ortho-vpn proj)))
                                (ortho-raylen proj))))
    (lambda ((:varg 3 pt))
      (declare #.*opt* (veq:ff pt))
      (weird:mvc #'values pt (veq:f3+ pt dir)))))


(defun make (&key (up (list 0f0 0f0 1f0)) (cam (3rep 1000f0))
                  (xy (2rep)) (s 1f0) vpn look (raylen 5000f0))
  (declare (list up cam xy) (veq:ff s raylen))
  "
  make projection.

  default up is (0 0 1)
  default cam is (1000 1000 1000)
  if look and vpn are unset, the camera will look at the origin.

  default scale is 1
  default xy is (0 0)
  "

  (assert (not (and vpn look)) (vpn look)
          "make: can only use (or vpn look)." vpn look)

  (let ((vpn* (if vpn vpn (-look cam (if look look (3rep))))))
    (weird:mvb (u v su sv) (-get-u-v up vpn* s)
      (declare (list u v su sv))
      (let ((res (make-ortho :vpn vpn* :up up :cam cam :u u :v v
                             :su su :sv sv :s s :xy xy :raylen raylen)))
        (setf (ortho-dstfx res) (make-dstfx res)
              (ortho-projfx res) (make-projfx res)
              (ortho-rayfx res) (make-rayfx res))
        res))))


; (defun export-data (proj)
;   (declare (ortho proj))
;   (with-struct (ortho- up cam xy s vpn raylen) proj
;     (list :ortho up cam xy s vpn raylen)))

; (defun import-data (o)
;   (declare (list o))
;   (destructuring-bind (up cam xy s vpn raylen) (cdr o)
;     (make :up up :cam cam :xy xy :s s :vpn vpn :raylen raylen)))


(defun update (proj &key s xy up cam vpn look)
  "
  update projection parameters.

  use vpn to set view plane normal directly, or look to set view plane normal
  relative to camera.

  ensures that internal state is updated appropriately.
  "
  (declare #.*opt* (ortho proj))

  (assert (not (and vpn look)) (vpn look)
          "update: can only use (or vpn look)." vpn look)

  (when cam (setf (ortho-cam proj) (the list cam)))
  (when up (setf (ortho-up proj) (the list up)))
  (when vpn (setf (ortho-vpn proj) (the list vpn)))
  (when look (setf (ortho-vpn proj)
                   (the list (-look (ortho-cam proj) look))))
  (when s (setf (ortho-s proj) (the veq:ff s)))
  (when xy (setf (ortho-xy proj) (the list xy)))
  (when (or s up vpn look)
        (weird:mvb (u v su sv) (-get-u-v (ortho-up proj) (ortho-vpn proj)
                                         (ortho-s proj))
          (declare (list u v su sv))
          (setf (ortho-u proj) u (ortho-v proj) v
                (ortho-su proj) su (ortho-sv proj) sv)))

  (setf (ortho-dstfx proj) (make-dstfx proj)
        (ortho-projfx proj) (make-projfx proj)
        (ortho-rayfx proj) (make-rayfx proj)))

(veq:vdef* project (proj (:varg 3 pt))
  (declare #.*opt* (ortho proj) (veq:ff pt))
  "project single point"
  (weird:mvc #'values (funcall (ortho-projfx proj) pt)
                      (funcall (ortho-dstfx proj) pt)))


(veq:vdef project* (proj path)
  (declare #.*opt* (ortho proj) (veq:fvec path))
  "project list of points. returns list (pts dsts)"
  (with-struct (ortho- projfx dstfx) proj
    (declare (function projfx dstfx))
    (veq:fwith-arrays (:n (veq:3$num path) :itr k
      :arr ((path 3 path) (p 2) (d 1))
      :fxs ((proj ((:varg 3 x)) (declare #.*opt* (veq:ff x))
                    (funcall projfx x))
            (dst ((:varg 3 x)) (declare #.*opt* (veq:ff x))
                    (funcall dstfx x)))
      :exs ((p k (proj path))
            (d k (dst path))))
      (values p d))))

