
(in-package :weir)

; based on Constructing a Cycle Basis for a Planar Graph by David Eberly
; https://www.geometrictools.com/Documentation/MinimalCycleBasis.pdf

; TODO: clean this up
; TODO: this code and/or algorithm is very buggy. or at least sensitive to numerical
; pricision.

(declaim (veq:ff eps))
(defvar eps (* 3f0 single-float-epsilon))


(veq:fvdef -get-west-most-vert (verts vertfx incidentfx)
  (declare #.*opt* (list verts) (function vertfx incidentfx))

  (unless verts (return-from -get-west-most-vert nil))

  (let ((res (car verts)))
    (declare (fixnum res))
    (mvb (mx my) (funcall vertfx res)
      (declare (veq:ff mx my))
      (loop for i in (cdr verts)
            do (when (> (length (the list (funcall incidentfx i))) 0)
                     (mvb (px py) (funcall vertfx i)
                       (declare (veq:ff px py))
                       (when (or (< px mx) (and (<= px mx) (< py my)))
                             (setf res i mx px my py))))))
    res))

; (defun get-west-most-vert (wer &key g)
;   (declare #.*opt* (weir wer))
;   "
;   get west-most vert with at least one incident vert.
;   if there are multple candidates, select the one with lowest y value.
;   "
;   (-get-west-most-vert
;     (get-connected-verts wer :g g)
;     (lambda (v) (declare (optimize speed) (fixnum v)) (2gv wer v))
;     (lambda (v) (declare (optimize speed) (fixnum v)) (get-incident-edges wer v))))


(declaim (inline -dot-perp))
(veq:fvdef -dot-perp ((:varg 2 a b))
  (declare #.*opt* (veq:ff a b))
  ; (veq:f2. a (veq:f2perp b))
  (- (* (:vref a 0) (:vref b 1))
     (* (:vref a 1) (:vref b 0))))

(declaim (inline -is-convex))
(veq:fvdef -is-convex ((:varg 2 a b))
  (declare #.*opt* (veq:ff a b))
  (<= (-dot-perp a b) eps))

(veq:fvdef -get-cw-most-vert (curr prev &key dirfx adjfx)
  (declare #.*opt* (fixnum curr prev) (function dirfx adjfx))
  "this is only used once at the beginning of the algoritm"
  (veq:f2let ((dcurr (if (< prev 0) (veq:f2 0f0 -1f0)
                                    (funcall dirfx curr prev))))
    (let ((adj (funcall adjfx curr prev)))
      (declare (list adj))

      ; nil if adj is empty
      (when (< (length adj) 2) (return-from -get-cw-most-vert (car adj)))

      (veq:f2let ((dnext (veq:f2 0f0 0f0)))
        (loop with next of-type fixnum = (car adj)
              with convex of-type boolean
              for a of-type fixnum in (cdr adj)
              initially (veq:f2vset (dnext) (funcall dirfx next curr))
                        (setf convex (-is-convex dnext dcurr))
              do (veq:f2let ((da (funcall dirfx a curr)))
                   (if convex (when (or (< (-dot-perp dcurr da) eps)
                                        (< (-dot-perp dnext da) eps))
                                    (setf next a convex (-is-convex da dcurr))
                                    (veq:f2vset (dnext) (veq:f2 da)))
                              (when (and (< (-dot-perp dcurr da) eps)
                                         (< (-dot-perp dnext da) eps))
                                    (setf next a convex (-is-convex da dcurr))
                                    (veq:f2vset (dnext) (veq:f2 da)))))
              finally (return next))))))

(veq:fvdef -get-ccw-most-vert (curr prev &key dirfx adjfx)
  (declare #.*opt* (fixnum curr prev) (function dirfx adjfx))
  (veq:f2let ((dcurr (if (< prev 0) (veq:f2 0f0 -1f0)
                                    (funcall dirfx curr prev))))
    (let ((adj (funcall adjfx curr prev)))
      (declare (list adj))

      ; nil if adj is empty
      (when (< (length adj) 2) (return-from -get-ccw-most-vert (car adj)))

      (veq:f2let ((dnext (veq:f2 0f0 0f0)))
        ; infinite loops thend to happen here
        (loop with next of-type fixnum = (car adj)
              with convex of-type boolean
              for a of-type fixnum in (cdr adj)
              initially (veq:f2vset (dnext) (funcall dirfx next curr))
                        (setf convex (-is-convex dnext dcurr))
              do (veq:f2let ((da (funcall dirfx a curr)))
                   (if convex (when (and (> (-dot-perp dcurr da) (- eps))
                                         (> (-dot-perp dnext da) (- eps)))
                                    (setf next a convex (-is-convex da dcurr))
                                    (veq:f2vset (dnext) (veq:f2 da)))
                              (when (or (> (-dot-perp dcurr da) (- eps))
                                        (> (-dot-perp dnext da) (- eps)))
                                    (setf next a convex (-is-convex da dcurr))
                                    (veq:f2vset (dnext) (veq:f2 da)))))
              finally (return next))))))

(declaim (inline -absub))
(veq:fvdef -absub (verts i j)
  (declare #.*opt* (veq:fvec verts) (veq:pn i j))
  ; (when (< (veq:f2dst (veq:f2$ verts i j)) eps) (error "oh no"))
  (veq:f2- (veq:f2$ verts i j)))

; (defun get-incident-rotated-vert (wer curr &key (dir :ccw) (prev -1) g)
;   (declare #.*opt* (weir wer) (symbol dir) (fixnum curr prev))
;   "
;   (counter-)clockwise-most vertex of curr, relative to prev (or (0 -1))
;   NOTE: assuming the up is positive y, and right is positive x.
;   TODO: adjust this to handle that positive y is down? does it matter?
;   "
;   (labels ((dirfx (a b) (-absub (weir-verts wer) a b))
;            (adjfx (c p) (remove-if (lambda (i)
;                                      (declare (optimize speed) (fixnum i))
;                                      (= i p))
;                                    (graph::-only-incident-verts c
;                                      (get-incident-edges wer c :g g)))))
;     (case dir (:cw (-get-cw-most-vert curr prev :dirfx #'dirfx :adjfx #'adjfx))
;               (:ccw (-get-ccw-most-vert curr prev :dirfx #'dirfx :adjfx #'adjfx))
;               (t (error "dir must be :cw or :ccw")))))


(defun -do-walk-cycle (grph &key dirfx adjfx vertfx)
  (declare #.*opt* (graph::graph grph) (function dirfx adjfx))
  (when (< (the veq:pn (graph:get-num-edges grph)) 1) (return-from -do-walk-cycle nil))
  (let* ((prev (-get-west-most-vert (graph:get-verts grph)
                                    vertfx
                                    (lambda (v)
                                      (declare (optimize speed) (fixnum v))
                                      (graph:get-incident-edges grph v))))
         (start prev)
         (next (-get-cw-most-vert prev -1 :dirfx dirfx :adjfx adjfx))
         (res (list next prev)))

    (unless next (return-from -do-walk-cycle nil))

    (loop until (= (the veq:pn next) (the veq:pn start))
          do (let ((c (-get-ccw-most-vert next prev :dirfx dirfx :adjfx adjfx)))
               (push c res)
               (setf prev next next c)))
    (setf res (reverse res))

    (graph:del grph (first res) (second res))
    (graph:del-simple-filaments grph)

    ; return nil if it is a non-cycle closed walk
    (if (> (length res) (+ (length (remove-duplicates res)) 1)) nil res)))

(defun 2get-planar-cycles (wer &key cycle-info g &aux (res (list)))
  (declare #.*opt* (weir wer) (list res))
  (multiple-value-bind (g* exists) (gethash g (weir-grps wer))
    (unless exists (error "attempted to access invalid group: ~a" g))
    (let ((grph (graph:copy (grp-grph g*))))
      (graph:del-simple-filaments grph)
      (labels ((vertfx (v) (2gv wer v))
               (dirfx (a b) (-absub (weir-verts wer) a b))
               (adjfx (c p)
                 (declare (fixnum c p))
                 (remove-if (lambda (i) (declare (optimize speed) (fixnum i)) (= i p))
                            (graph::-only-incident-verts c
                              (graph:get-incident-edges grph c)))))

        (loop while (> (the veq:pn (graph:get-num-edges grph)) 0)
              do (let ((cycle (-do-walk-cycle grph :dirfx #'dirfx
                                :adjfx #'adjfx :vertfx #'vertfx)))
                   (when cycle (push cycle res)))))))

  (if cycle-info (loop for c in res
                       collect (graph::-cycle-info c) of-type list)
                 res))

