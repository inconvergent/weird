
(in-package #:weir)

; TODO: docs for arguments
; TODO: tests for these fxs

(veq:fvdef -get-proj-fx ((:va 3 pt n)
                         &aux (proj (ortho:make :cam (veq:f3$point pt)
                                                :vpn (veq:f3$point n))))
  (declare (veq:ff pt n) (ortho::ortho proj))
  (lambda ((:va 3 p) &rest rest)
    (declare (ignore rest) (veq:ff p))
    (veq:fxy (ortho:project proj p))))

(veq:fvdef -get-vfx ((:va 3 pt n) &aux (lim #.(* -2f0 weird:*eps*)))
  (declare (veq:ff pt n lim))
  (lambda ((:va 3 p))
    (declare (veq:ff p))
    (< (veq:f3. (veq:f3norm (veq:f3- p pt)) n) lim)))

(defun -classify-verts (wer vs vfx)
  (declare (weir wer) (hash-table vs) (function vfx))
  (itr-verts (wer v) (setf (gethash v vs) (veq:mvc vfx (3$verts wer v)))))


(defun -reconstruct-isect-path (wer vert->side mat-prop s isect c)
  (declare (weir wer) (hash-table vert->side))
  (labels ((poly-config (vs s p)
             (declare (hash-table vs) (boolean s) (list p))
             (length (remove-if-not (lambda (v) (eq s (gethash v vs))) p)))
           (except (l c) (car (set-difference (the list l) (list c))))
           (add-poly (&rest l) (add-polygon! wer l))
           (do-reconstruct (s nxt-p v nxt-v e nxt-e)
             (declare (boolean s) (list nxt-p e nxt-e) (fixnum v nxt-v))
             (let ((c (car (intersection e nxt-e))))
               ; (declare (fixnum c))
               (unless c (warn "bad c ~a ~a" e nxt-e))
               (case (poly-config vert->side s nxt-p)
                 (0 (warn "poly reconstruct nil poly?")) ; this may not be an error
                 (1 (list (add-poly c v nxt-v)))
                 (2 (let ((nec (except nxt-e c)))
                      (list (add-poly v (except e c) nec)
                            (add-poly v nxt-v nec))))
                 (otherwise (warn "bad result in poly reconstruct")))))

           ; TODO: use c properly
           (do-reconstruct-isect-path (s isect c)
             (declare  (boolean s c))
             (loop with n = (length isect)
                   for i from 0 below n
                   ; TODO: in the event of nil polys this will fail
                   do (veq:dsb (e v p) (aref isect i)
                        (if p
                          (veq:dsb (ne nv np) (aref isect (mod (1+ i) n))
                            (if np (mset-poly-prop wer
                                     (do-reconstruct s np v nv e ne)
                                     mat-prop (get-poly-prop wer np mat-prop))
                              (warn "bad np")))
                          (warn "bad p"))))))
    (do-reconstruct-isect-path s isect c)))

(veq:fvdef -isect-add-verts (wer vert->side cut-prop edge-d s isect)
  (declare (weir wer) (hash-table vert->side))
  (labels ((add-vert (ea s)
             (declare (list ea) (veq:ff s))
             (3add-vert! wer (veq:f3lerp (veq:f3$ (3gvs wer ea) 0 1) s)))

           (split-add-vert (edge-d s e)
             (declare (hash-table edge-d) (list e) (boolean s))
             (let ((v (add-vert e (gethash e edge-d))))
               (declare (fixnum v))
               (setf (gethash v vert->side) s)
               (set-vert-prop wer v cut-prop)
               v))

           (add-verts (edge-d s isect)
             (declare (hash-table edge-d) (boolean s) (list isect))
             (loop for (e p) in isect
                   collect (list e (split-add-vert edge-d s e) p))))
    (add-verts edge-d s isect)))


(veq:fvdef* mesh-bisect (wer (:va 3 cut-pt cut-n)
                         &key (vfx (-get-vfx cut-pt cut-n))
                              (pfx (-get-proj-fx cut-pt cut-n))
                              (vert->side (make-hash-table :test #'eq))
                              (mat :inside)
                              (mat-prop :mat)
                              (cut-prop (gensym "CUT")))
  (declare (weir wer) (symbol cut-prop mat-prop) (veq:ff cut-pt cut-n)
           (function vfx pfx) (hash-table vert->side))

  "cut-pt: cut plane pt
   cut-n: cut plane normal
   vfx: classify vertex to either side of the cut plane
   pfx: fx that projects verts into projection plane pt, n
   vert->side: hash table to contain the result of vfx
   mat: material assigned to intersection surface
   mat-prop: property used to set material
   cut-prop: material used to indicate cut verts
  "
  (labels ((triangulate-intersection (isect m)
             (declare (vector isect))
             (mset-poly-prop wer
               (3triangulate wer
                 (graph:path->edge-set (map 'list #'second isect) :closed t)
                 :fx pfx)
               mat-prop m))
           (select-mat (isect)
             (typecase mat
               (null (get-poly-prop wer (second (first isect)) mat-prop))
               (function (funcall mat (get-poly-prop wer (second (first isect))
                                                     mat-prop)))
               (t mat)))
           (side-isect (edge-d s isect c)
             (declare (hash-table edge-d) (boolean s c) (list isect))
             (let ((m (select-mat isect))
                   (isect (weird:tv (-isect-add-verts wer
                                      vert->side cut-prop edge-d s isect))))
               (-reconstruct-isect-path wer vert->side mat-prop s isect c)
               (when c (triangulate-intersection isect m)))))

    (-classify-verts wer vert->side vfx)
    (weird:mvb (all-isects edge-d) (poly-isect-proj-plane wer cut-pt cut-n)
      (loop for (isect c) in all-isects
            do (loop for (e p) in isect if p do (del-polygon! wer p))
               (loop for s in (list t nil) do (side-isect edge-d s isect c))))))


(veq:fvdef* mesh-slice (wer (:va 3 cut-pt cut-n)
                              &key (side t)
                                   del-polys
                                   (vfx (-get-vfx cut-pt cut-n))
                                   (vert->side (make-hash-table :test #'eq))
                                   (mat-prop :mat)
                                   (cut-prop (gensym "CUT")))
  (declare (weir wer) (symbol cut-prop mat-prop) (veq:ff cut-pt cut-n)
           (function vfx) (hash-table vert->side))

  (labels ((side-isect (edge-d s isect c)
             (declare (hash-table edge-d) (boolean s c) (list isect))
             (let ((isect (weird:tv (-isect-add-verts wer
                                      vert->side cut-prop edge-d s isect))))
               (-reconstruct-isect-path wer vert->side mat-prop s isect c)))
           (poly-side (p)
             (not (every (lambda (v) (eq side (gethash v vert->side))) p)))
           (del-all-polys ()
             (loop for p in (get-all-polygons wer)
                   if (poly-side p) do (del-polygon! wer p))))

    (-classify-verts wer vert->side vfx)
    (weird:mvb (all-isects edge-d) (poly-isect-proj-plane wer cut-pt cut-n)
      (loop for (isect c) in all-isects
            do (loop for (e p) in isect if p do (del-polygon! wer p))
               (side-isect edge-d side isect c)))
    (when del-polys (del-all-polys))))

