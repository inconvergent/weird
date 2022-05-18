
(in-package #:weir)

; TODO: bi-list can be built directly
(defun -bi-list (isects)
  (declare (list isects))
  (let ((edge-d (make-hash-table :test #'equal))
        (edge-poly (make-hash-table :test #'equal))
        (poly-edge (make-hash-table :test #'equal)))
    (declare (hash-table edge-d edge-poly poly-edge))
    (loop for (edge poly d) in isects
          do (if (gethash edge edge-poly)
                 (setf (gethash edge edge-poly) (cons poly (gethash edge edge-poly)))
                 (setf (gethash edge edge-poly) (list poly)))
             (setf (gethash `(,@edge) edge-d) d)
             (if (gethash poly poly-edge)
                 (setf (gethash poly poly-edge) (cons edge (gethash poly poly-edge)))
                 (setf (gethash poly poly-edge) (list edge))))
    (values edge-poly poly-edge edge-d)))


(defun pop-from-fx (l &key fx)
   (declare (list l) (function fx))
   "get first element, e, in l where fx is t. returns (values e (l without e))"
   (unless l (return-from pop-from-fx (values nil nil)))
   (loop for v in (the list l) ; TODO: split in one pass
         if (and v (funcall fx v))
         do (return-from pop-from-fx
              (values v (remove-if (lambda (c) (equal c v)) l))))
   (values nil nil))

(defun pop-from-key (ht k &key fx keep)
  "find first element of ht[k] to match fx. pops this element (e)
              from ht[k] and returns (values k e)"
   (let ((o (gethash k ht)))
     (if o (veq:mvb (popped remaining) (pop-from-fx o :fx fx)
                    (unless keep (remhash k ht))
                    (values k popped remaining))
           (values nil nil nil))))


(defun order-poly-isects (edge-poly-ht poly-edge-ht)
  (declare #.*opt* (hash-table edge-poly-ht poly-edge-ht) )
  "reorder (non-trivial) triangle strip constructed by the maps from
  edge to poly and poly to edge"
  (labels ((pop-first-edge ()
             "get first key (k) from ht, and pop the first element (e) from
              ht[k].  returns (values k e).  "
             (loop for k being the hash-keys of poly-edge-ht
                   do (return-from pop-first-edge
                        (veq:mvb (a b)
                          (pop-from-key poly-edge-ht k :fx #'identity :keep t)
                          (values b a)))))

           (pop-next-edge (fe np)
             (declare (list fe np))
             (unless (and fe np) (return-from pop-next-edge (values nil nil nil)))
             (pop-from-key poly-edge-ht np
               :fx (lambda (c) (not (equal c fe)))))

           (pop-next-poly (fp ne)
             (declare (list fp ne))
             (unless (and fp ne) (return-from pop-next-poly (values nil nil nil)))
             (pop-from-key edge-poly-ht ne
               :fx (lambda (c) (not (equal c fp)))
               :keep t))

           (closed-loop (res)
              "true if the triangle strip has been closed"
              (let* ((lst (first (last res)))
                     (closed (= (length (intersection (first lst) (caar res)))
                                2)))
                (values (if closed (cdr res) res) closed)))

           (clean-edge-from-poly (p e)
             (veq:mvb (edges exists) (gethash p poly-edge-ht)
               (when exists
                 (let ((remaining (remove-if (lambda (e*) (equal e* e)) edges)))
                   (if remaining (setf (gethash p poly-edge-ht) remaining))))))

           (walk (fe np &key (res (list (list fe np))))
                 ; TODO: improve this
            (loop while (and fe np)
                  do (clean-edge-from-poly np fe)
                     (veq:mvb (fp ne) (pop-next-edge fe np)
                       (if (and fp ne)
                         (veq:mvb (fe* np*) (pop-next-poly fp ne)
                           (if (and fe* np*)

                               (progn (push (list fe* np*) res)
                                      (setf fe fe* np np*))

                               (progn (setf fe nil np nil)
                                      (when fe* (push (list fe* np*) res)))))

                         (setf fe nil np nil))))
            (closed-loop res))

           (rec (&optional fe np &rest rest)
             (declare (list fe np) (ignore rest))
             "recursively reconstruct the triangle strip as a list of
               ((edge poly) ...)"
             (unless (and fe np) (warn "early termination order-poly-isects")
               (return-from rec (values nil nil)))

             (unless (= 2 (length fe)) (error "bad edge: ~a" fe))
             (-verify-poly np)
             (veq:mvb (res closed) (walk fe np)
               (when closed (return-from rec (values res t)))
               (setf res (reverse res))
               (values (walk (caar res) (cadar res) :res res) nil))))

    (veq:mvc #'rec (pop-first-edge))))

(veq:vdef* poly-isect-proj-plane (wer (:va 3 pt norm))
  (declare (weir wer) (veq:ff pt norm))
  "slice polygons of wer with a plane (pt, norm)"
  (labels ((poly-edge-isect (poly &aux (res (list)))
             (loop for (a b) in (get-polygon-edges wer poly)
                   do (veq:mvb (isect d)
                        (veq:f3planex norm pt (3$verts wer a b))
                           (when (and isect (< 0f0 d 1f0))
                                 (push `((,a ,b) ,poly ,d) res))))
             res)
           (do-all-intersections (&aux (res (list)))
             (loop for p in (get-all-polygons wer)
                   collect (loop for i in (poly-edge-isect p)
                                 do (push i res)))
             (-bi-list res))
           (until-empty (edge-poly-ht poly-edge-ht)
             ; TODO: better termination criteria?
             (loop while (and (> (hash-table-count edge-poly-ht) 1)
                              (> (hash-table-count poly-edge-ht) 0))
                   collect (veq:lst (order-poly-isects
                                      edge-poly-ht poly-edge-ht)))))
    ; NOTE: if the mesh is concave, there might be more than one disjoint
    ; cross sections
    ; order-poly-isects returns a list of several lists like this:
    ;   ( ((v1 v2) (p1 p2 p3) s) ...  ). each in an order
    ; that traces the outside of the hull(s) created by the intersection of
    ; existing polygons and the plane (pt, norm)
    (veq:mvb (edge-poly-ht poly-edge-ht edge-d) (do-all-intersections)
      (values (until-empty edge-poly-ht poly-edge-ht) edge-d))))


