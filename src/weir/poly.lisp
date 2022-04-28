
(in-package #:weir)


; (defstruct (poly (:constructor -make-poly))
;   (id nil :type list :read-only t)
;   (normal (veq:f_) :type veq:fvec :read-only t)
;   (grph nil :type graph::graph)
;   (polygons (make-ht #'equal) :type hash-table) ; (a b c) -> (() () ())
;   (edges->poly (make-ht #'equal) :type hash-table))

(defmacro -verify-poly (poly*)
  (weird:awg (poly v)
    `(let ((,poly ,poly*))
      (declare (list ,poly))
      (unless (= 3 (length (remove-duplicates ,poly))) (error "bad poly size: ~a" ,poly))
      (unless (every (lambda (,v) (typecase ,v (fixnum (> ,v -1))
                                               (t nil)))
                     ,poly)
              (error "bad vert in poly: ~a" ,poly))
      ,poly)))

(defun -verify-edge (e)
  (unless (= 2 (length e)) (error "bad edge: ~a" e)))

(declaim (inline -get-polygons-from -get-edges->poly-from -idxy))
(defun -get-polygons-from (wer &key g) (with-grp (wer g* g) (grp-polygons g*)))
(defun -get-edges->poly-from (wer &key g) (with-grp (wer g* g) (grp-edges->poly g*)))
(defun -idxy (x y &rest rest) (declare (ignore rest)) (values x y))

(declaim (inline -sort-polygon))
(defun -sort-polygon (poly)
  (declare #.*opt* (list poly))
  "maintain vert order, but ensure that the smallest index is first.
   use -polygon-exists to test for duplicate polygons."
  (-verify-poly poly)
  (weird:dsb (a b c) poly
    (declare (pos-int a b c))
    (cond ((and (< a c) (< a b)) poly)
          ((and (< b a) (< b c)) (list b c a))
          (t (list c a b)))))


(defun get-all-polygons (wer &key g extra)
  (declare #.*opt* (weir wer))
  (loop for k of-type list
        being the hash-keys of (-get-polygons-from wer :g g)
        using (hash-value v)
        if extra collect (list k v)
        else collect k of-type list))

; TODO: should use -polygon-exists instead of sort-polygon?
(defun get-polygon-edges (wer poly &key g &aux (poly (-sort-polygon poly)))
  (declare #.*opt* (weir wer) (list poly))
  (-hash-table-get-key (-get-polygons-from wer :g g) poly))

(defun get-edge-polygons (wer edge &key g &aux (edge (-sort-list edge)))
  (declare #.*opt* (weir wer) (list edge))
  (-hash-table-get-key (-get-edges->poly-from wer :g g) edge))

(defun get-num-polygons (wer &key g)
  (declare #.*opt* (weir wer))
  (hash-table-count (-get-polygons-from wer :g g)))

; (declaim (inline -polygon-exists))
(defun -polygon-exists (polygons poly)
  (declare #.*opt* (hash-table polygons) (list poly))
  (labels ((-duplicate-cands (poly)
             (declare (list poly))
             (weird:dsb (a b c) poly
               (list poly (list a c b)))))
    (loop for cand of-type list in (-duplicate-cands poly)
          if (gethash cand polygons)
          do (return-from -polygon-exists cand)))
  nil)


(defun polygon-exists (wer poly &key g)
  (-verify-poly poly)
  (with-grp (wer g* g)
    (-polygon-exists (grp-polygons g*) poly)))

(defun add-polygon! (wer poly &key g &aux (poly (-sort-polygon poly)))
  (declare #.*opt* (weir wer) (list poly))
  (-verify-poly poly)
  (labels ((-ensure-no-duplicates ()
            (unless (apply #'< (-sort-list poly))
                    (error "duplicates indices in poly: ~a" poly)))

           (-add-edges->poly (edges->poly a b)
             (declare (hash-table edges->poly) (pos-int a b))
             (let ((e (-sort-list (list a b))))
               (veq:mvb (pp exists) (gethash e edges->poly)
                 (setf (gethash e edges->poly)
                       (the list (if exists (cons poly pp)
                                            (list poly)))))
               e))

           (-add-polygon-edges (edges->poly)
             (declare (hash-table edges->poly) )
             (loop for a in poly and b in (-roll-once poly)
                   collect (-add-edges->poly edges->poly a b)))

           (-add-polygon (polygons edges->poly)
             (declare (hash-table polygons edges->poly))
             ; if polygon exists already, return nil
             (when (-polygon-exists polygons poly)
                   (return-from -add-polygon nil))
             ; else, add polygon
             (add-path-ind! wer poly :g g :closed t) ; <-------- add poly to grph
             (setf (gethash poly polygons)
                   (-add-polygon-edges edges->poly)) ; TODO: duplicates??
             poly))

    (-ensure-no-duplicates)
    (with-grp (wer g* g)
      (-add-polygon (grp-polygons g*) (grp-edges->poly g*)))))

(defun add-polygons! (wer pp &key g)
  (declare #.*opt* (weir wer) (list pp))
  (loop for poly of-type list in pp
        collect (add-polygon! wer poly :g g)))

(defun del-polygon! (wer poly &key g)
  (declare #.*opt* (weir wer) (list poly))
  (-verify-poly poly)
  (labels ((-del-polygon-edges (edges->poly poly edge)
            (declare (hash-table edges->poly) (list poly edge))
            (let ((new-poly-list (remove-if (lambda (p) (declare (list p))
                                              (equal p poly))
                                            (gethash edge edges->poly))))
              (declare (list new-poly-list))
              (if new-poly-list (setf (gethash edge edges->poly) new-poly-list)
                (remhash edge edges->poly)))))

    (with-grp (wer g* g) wer
      (let* ((polygons (-get-polygons-from wer :g g))
             (edges->poly (grp-edges->poly g*))
             (poly (-polygon-exists polygons poly)))
        (declare (list poly))

        (unless poly (return-from del-polygon! nil))
        (loop for a in poly and b in (-roll-once poly)
              do (let ((e (-sort-list (list a b))))
                   (-del-polygon-edges edges->poly poly e)
                   (unless (-hash-table-get-key edges->poly e)
                           ; if edges->poly[edge] is now empty,
                           ; delete edge from grph
                           (ldel-edge! wer e)))) ; <---- remove edge from grph
        (unless (gethash poly polygons)
                (warn "missing poly: ~a" poly))
        (remhash poly polygons)
        t))))

(defun del-polygons! (wer polys &key g)
  (declare #.*opt* (weir wer) (list polys))
  (loop for p of-type list in polys
        collect (del-polygon! wer p :g g)))


(veq:fvdef 3triangulate (wer edge-set &key (fx '-idxy))
  (declare (weir wer) (list edge-set))
  "triangulate the hull defined by edge set, using the projection provided by fx
  where fx: R3 -> R2. default projection is xyz -> xy."
  (let ((path (weird:tv (graph:edge-set->path edge-set)))
        (res (list)))
    (declare (vector path))
    (labels ((gv (i) (declare (pos-int i)) (veq:vgrp-mvc (3 fx) (3gv wer i)))
             (ypos (v) (declare (pos-int v)) (veq:fy (gv v)))
             (ind-rotate (path ymost)
               (declare (vector path) (pos-int ymost))
               (weird:reorder path (ymost nil) (0 ymost)))
             (y-most (path &aux (ypos (ypos (aref path 0))) (cv 0) )
               (loop for v across (subseq path 1)
                     for i from 1
                     if (< (ypos v) ypos)
                     do (setf ypos (ypos v) cv i))
               cv)
             (cross (path &aux (n (length path)))
                "does any segment in path cross the line (aref path 1) (aref path -1)"
                (veq:f2let ((a (gv (aref path 1)))
                            (b (gv (weird:vl path))))
                  (loop for i from 0 below n
                        do ; weird precision issue. override veq eps
                           ; TODO: can we fix this somehow?
                           (let ((veq::*eps* (* 1000f0 veq::*eps*)))
                             (when (veq:f2segx a b (veq:vgrp-mvc (3 fx)
                                                     (3$verts wer (aref path i)
                                                       (aref path (mod (1+ i) n)))))
                               (return-from cross t)))))
                nil)
             (uw-farthest (path &aux (n (length path)) dst (curr -1))
              "find the vertex in triangle ((aref path 1) (aref path 0) (aref path -1))
               that is the farthest away from (aref path 1) (aref path -1) "
               (loop for i from 2 below (1- n)
                     if ; TODO: this feels very sketchy
                       (let ((veq::*eps* (* 1000f0 veq::*eps*)))
                          (veq:f2in-triangle
                            (veq:vgrp-mvc (3 fx)
                              (3$verts wer (aref path 0) (aref path 1)
                               (weird:vl path) (aref path i)))))

                     do (let ((d (veq:f2segdst
                                   (veq:vgrp-mvc (3 fx)
                                     (3$verts wer (aref path 1) (weird:vl path)
                                                  (aref path i))))))
                          (when (or (= curr -1) (> d dst))
                                (setf curr i dst d))))
               (values curr dst))
             (split-diag (path i)
               "split into two paths by introducing a new edge that divides
                path in two loops"
               (when (= i -1) (error "bad split (-1) at: ~a" path))
               (when (< (length path) 3) (error "diag: too few elements in ~a" path))
               (when (>= i (length path)) (error "diag bad ind: ~a ~a" path i))
               (do-step (weird:reorder path (i) (0 i)))
               (do-step (weird:reorder path (0) (i nil))))
             (split-tri (path)
               "split path into a triangle and a new path"
               (do-step (weird:reorder path ((1- (length path))) (0 2)))
               (do-step (subseq path 1)))
             (do-step (path &aux (n (length path)))
               "recursively subdived the path into triangles and/or new loops"
               ; (when (< n 3) (error "do-step: too few elements in ~a" path))
               (when (< n 3) (return-from do-step nil))
               (when (< n 4) (push (add-polygon! wer (weird:tl path)) res)
                             (return-from do-step t))

               ; this is confusing, but i was unable to find a better way. the
               ; problem is that sometimes cross path detects an intersection,
               ; but uw-farthest is unable to find a valid candidate. this is
               ; probably due to precision issues in either cross, uw-farthest,
               ; or both?
               (let ((path (ind-rotate path (y-most path))))
                 (if (not (cross path))
                     (split-tri path) ; -> no intersections
                     (let ((uw (uw-farthest path))) ; -> possible intersection
                       (if (> uw -1)
                           (split-diag path uw) ; intersection
                           (progn (warn "possble intersection, unable to detect farthest uw")
                                  (split-tri path)))))))) ; unable to detect intersection
      (do-step path)
      res)))

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

             (-verify-edge fe)
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


(defun obj-import! (wer fn &aux (res (list))
                                (n (get-num-verts wer)))
  (declare #.*opt* (weir wer) (list res) (fixnum n))
  ; TODO this is not a complete obj importer. it fails on
  ; comments. and it does not load face normals, or support quads. among
  ; other things
  (labels
    ((add-poly (o) (push (add-polygon! wer (mapcar (lambda (i) (+ n (1- i))) o))
                         res))
     (add-vert (o) (3add-vert! wer (apply #'values o)))
     (parse (l) (cond ((eq (first l) 'cl-user::f)
                       (add-poly
                         (loop for s in (cdr l)
                               collect (parse-number:parse-positive-real-number
                                         (first (split-sequence:split-sequence
                                                  #\/ (weird:mkstr s)))))))
                      ((eq (first l) 'cl-user::v) (add-vert (cdr l)))))
     (do-line (l)
       (let ((*read-default-float-format* 'single-float))
         (parse (loop for x = (read l nil nil)
                      for i of-type pos-int from 0
                      while x collect x )))))
    (dat:do-lines-as-buffer fn #'do-line))
  res)


(defun load-internal-model! (wer name)
  (declare (weir wer) (string name))
  (obj-import! wer (weird:internal-path-string
                     (format nil "src/data/~a.obj" name))))


(veq:fvdef obj-export (wer fn &key (mesh-name "mesh")
                              &aux (verts (3get-all-verts wer))
                                   (n (get-num-verts wer)))
  (declare #.*opt* (weir wer) (string mesh-name))
  (with-open-file (fstream (weird:ensure-filename fn ".obj")
                             :direction :output :if-exists :supersede)
    (format fstream "o ~a~%" mesh-name)
    (veq:f3$with-rows (n verts) (lambda (i (:va 3 x))
                                  (declare (ignore i))
                                  (format fstream "v ~@{~f~^ ~}~%" x)))

    (loop for poly in (get-all-polygons wer)
          ; obj files are one-indexed
          do (format fstream "f ~{~d~^ ~}~%" (math:add poly '(1 1 1))))))

