
(in-package :hatch)

; any fixed point will work. this magic number seemed to work well for some
; cases i tested ... TODO: make magic number configurable?
(defvar *magic* (vec:vec -997799.33333f0 -775577.747362f0))


(defun stitch (lines)
  "
  randomly mix the hatches in lines according to where the lines intersect.
  this is somewhat inefficient
  "
  (loop with res = (make-adjustable-vector)
        for i from 0 below (length lines)
        do (let ((ss (make-adjustable-vector))
                 (curr (aref lines i)))

             (vextend 0f0 ss)
             (vextend 1f0 ss)

             (loop for j from 0 below (length lines)
                   do (multiple-value-bind (x s)
                        (vec:segx curr (aref lines j))
                        (if x (vextend s ss))))

             (setf ss (sort ss (rnd:either #'< #'>)))

             (loop for k from (rnd:rndi 2) below (1- (length ss)) by 2
                   do (vextend (list (vec:lon-line (aref ss k) curr)
                                     (vec:lon-line (aref ss (1+ k)) curr))
                               res)))
        finally (return res)))


(defun -hatch-mid (pts)
  (loop with n = (length pts)
        with mid = (vec:zero)
        repeat (1- n) for p across pts
        do (vec:add! mid p)
        finally (return (vec:sdiv mid (coerce (1- n) 'veq:ff)))))

(defun segdst (mid a esize)
  "
  find the point along the line with angle a through mid that is closest to an
  arbitrary fixed point.  this way all hatches with same angle and rs will line
  up.
  "
  (let ((line (vec:rline esize a :xy mid)))
    (multiple-value-bind (_ tt) (vec:segdst line *magic*)
      (declare (ignore _))
      (vec:dst mid (vec:lon-line tt line)))))

(defun -get-angle-zero-point-lines (pts a rs esize)
  "
  get evenly spaced lines along angle line a that always match up for same
  (rs angle).
  "
  (let* ((mid (-hatch-mid pts))
         (va (vec:cos-sin a))
         (rad (+ (* 4 rs) (loop for p across pts maximize (vec:dst mid p))))
         (slide (vec:rline rad (- a (* 0.5 veq:fpi))))
         (d (segdst mid a esize))
         (zp- (+ rad (- (mod (- d rad) rs) rs)))
         (zp+ (- rad (mod (+ d rad) rs))))
    (loop for mark in
            (vec:lon-line*
              (math:linspace (1+ (round (+ zp- zp+) rs)) 0f0 1f0 :end t)
              (list (vec:sub mid (vec:smult va zp-))
                    (vec:add mid (vec:smult va zp+))))
          collect (vec:ladd* slide mark))))


(defun -line-hatch (res line pts)
  "make the actual hatches along line"
  (let ((ixs (make-adjustable-vector)))
    (loop for i from 0 below (1- (length pts))
          do (multiple-value-bind (x s)
               (vec:segx line (list (aref pts i) (aref pts (1+ i))))
               (if x (vextend s ixs))))
    (setf ixs (sort ixs #'<))
    (loop for i from 0 below (1- (length ixs)) by 2
          do (vextend (list (vec:lon-line (aref ixs i) line)
                            (vec:lon-line (aref ixs (1+ i)) line))
                      res))))


(defun hatch (pts &key (angles 0f0) (rs 3f0) (esize 3000f0)
                  &aux (pts* (ensure-vector pts)))
  "draw hatches at angles inside the area enclosed by the path in pts"

  (when (> (vec:dst (aref pts* 0) (vector-last pts*)) 0.0001f0)
        (error "first and last element in pts must be close to each other."))
  (loop with res = (make-adjustable-vector)
        for a in (if (equal (type-of angles) 'cons) angles (list angles))
        do (loop for line in (-get-angle-zero-point-lines pts* a rs esize)
                 do (-line-hatch res line pts*))
        finally (return res)))

