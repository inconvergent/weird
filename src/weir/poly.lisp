
(in-package #:weir)


(defmacro -verify-poly (poly* &optional flag)
  (weird:awg (poly v)
    `(let ((,poly ,poly*))
      (declare (list ,poly))
      (unless (= 3 (length (remove-duplicates ,poly)))
              (error "bad poly size: ~a" ,poly))
      (unless (every (lambda (,v) (typecase ,v (fixnum (> ,v -1))
                                               (t nil)))
                     ,poly)
              (error "bad vert in poly (~a): ~a" ,flag ,poly))
      ,poly)))


(declaim (inline -sort-list))
(defun -sort-list (l)
  (declare #.*opt* (list l))
  (sort (copy-list l) #'<))

(declaim (inline -get-polys-from -get-edges->poly-from -idxy))
(defun -get-polys-from (wer &key g) (with-grp (wer g* g) (grp-polys g*)))
(defun -get-edges->poly-from (wer &key g) (with-grp (wer g* g) (grp-edges->poly g*)))
(defun -idxy (x y &rest rest) (declare (ignore rest)) (values x y))

(declaim (inline -sort-poly))
(defun -sort-poly (poly)
  (declare #.*opt* (list poly))
  "maintain vert order, but ensure that the smallest index is first.
use -poly-exists to test for duplicate polys."
  (-verify-poly poly :sort-poly)
  (weird:dsb (a b c) poly
    (declare (veq:pn a b c))
    (cond ((and (< a c) (< a b)) poly)
          ((and (< b a) (< b c)) (list b c a))
          (t (list c a b)))))


(defun get-all-polys (wer &key g extra)
  (declare #.*opt* (weir wer))
  (loop for k of-type list
        being the hash-keys of (-get-polys-from wer :g g)
        using (hash-value v)
        if extra collect (list k v)
        else collect k of-type list))

; TODO: should use -poly-exists instead of sort-poly?
(defun get-poly-edges (wer poly &key g &aux (poly (-sort-poly poly)))
  (declare #.*opt* (weir wer) (list poly))
  (-ht-get-key (-get-polys-from wer :g g) poly))

(defun get-edge-polys (wer edge &key g &aux (edge (-sort-list edge)))
  (declare #.*opt* (weir wer) (list edge))
  (-ht-get-key (-get-edges->poly-from wer :g g) edge))

(defun get-num-polys (wer &key g)
  (declare #.*opt* (weir wer))
  (hash-table-count (-get-polys-from wer :g g)))

; (declaim (inline -poly-exists))
(defun -poly-exists (polys poly)
  (declare #.*opt* (hash-table polys) (list poly))
  (labels ((-duplicate-cands (poly)
             (declare (list poly))
             (weird:dsb (a b c) poly
               (list poly (list a c b)))))
    (loop for cand of-type list in (-duplicate-cands poly)
          if (gethash cand polys)
          do (return-from -poly-exists cand)))
  nil)


(defun poly-exists (wer poly &key g)
  (-verify-poly poly :poly-exists)
  (with-grp (wer g* g)
    (-poly-exists (grp-polys g*) poly)))

(defun add-poly! (wer poly &key g &aux (poly (-sort-poly poly)))
  (declare #.*opt* (weir wer) (list poly))
  (-verify-poly poly :add-poly)
  (labels ((-ensure-no-duplicates ()
            (unless (apply #'< (-sort-list poly))
                    (error "duplicates indices in poly: ~a" poly)))

           (-add-edges->poly (edges->poly a b)
             (declare (hash-table edges->poly) (veq:pn a b))
             (let ((e (-sort-list (list a b))))
               (veq:mvb (pp exists) (gethash e edges->poly)
                 (setf (gethash e edges->poly)
                       (the list (if exists (cons poly pp)
                                            (list poly)))))
               e))

           (-add-poly-edges (edges->poly)
             (declare (hash-table edges->poly) )
             (loop for a in poly and b in (-roll-once poly)
                   collect (-add-edges->poly edges->poly a b)))

           (-add-poly (polys edges->poly)
             (declare (hash-table polys edges->poly))
             ; if poly exists already, return nil
             (when (-poly-exists polys poly)
                   (return-from -add-poly nil))
             ; else, add poly
             (add-path-ind! wer poly :g g :closed t) ; <-------- add poly to grph
             (setf (gethash poly polys)
                   (-add-poly-edges edges->poly)) ; TODO: duplicates??
             poly))

    (-ensure-no-duplicates)
    (with-grp (wer g* g)
      (-add-poly (grp-polys g*) (grp-edges->poly g*)))))

(defun add-polys! (wer pp &key g)
  (declare #.*opt* (weir wer) (list pp))
  (loop for poly of-type list in pp
        collect (add-poly! wer poly :g g)))

(defun del-poly! (wer poly &key g)
  (declare #.*opt* (weir wer) (list poly))
  (-verify-poly poly :del-poly)
  (labels ((-del-poly-edges (edges->poly poly edge)
            (declare (hash-table edges->poly) (list poly edge))
            (let ((new-poly-list (remove-if (lambda (p) (declare (list p))
                                              (equal p poly))
                                            (gethash edge edges->poly))))
              (declare (list new-poly-list))
              (if new-poly-list (setf (gethash edge edges->poly) new-poly-list)
                (remhash edge edges->poly)))))

    (with-grp (wer g* g) wer
      (let* ((polys (-get-polys-from wer :g g))
             (edges->poly (grp-edges->poly g*))
             (poly (-poly-exists polys poly)))
        (declare (list poly))

        (unless poly (return-from del-poly! nil))
        (loop for a in poly and b in (-roll-once poly)
              do (let ((e (-sort-list (list a b))))
                   (-del-poly-edges edges->poly poly e)
                   (unless (-ht-get-key edges->poly e)
                           ; if edges->poly[edge] is now empty,
                           ; delete edge from grph
                           (ldel-edge! wer e)))) ; <---- remove edge from grph
        (unless (gethash poly polys)
                (warn "missing poly: ~a" poly))
        (remhash poly polys)
        t))))

(defun del-polys! (wer polys &key g)
  (declare #.*opt* (weir wer) (list polys))
  (loop for p of-type list in polys
        collect (del-poly! wer p :g g)))


(veq:fvdef 3triangulate (wer edge-set &key (fx '-idxy))
  (declare (weir wer) (list edge-set))
  "triangulate the hull defined by edge set, using the projection provided
by fx where fx: R3 -> R2. default projection is xyz -> xy."
  (let ((path (weird:tv (graph:edge-set->path edge-set)))
        (res (list)))
    (declare (vector path))
    (labels ((gv (i) (declare (veq:pn i)) (veq:mvcgrp (3 fx) (3gv wer i)))
             (ypos (v) (declare (veq:pn v)) (veq:fsel (:y) (gv v)))
             (ind-rotate (path ymost)
               (declare (vector path) (veq:pn ymost))
               (weird:reorder path (ymost nil) (0 ymost)))
             (y-most (path &aux (ypos (ypos (aref path 0))) (cv 0) )
               (loop for v across (subseq path 1)
                     for i from 1
                     if (< (ypos v) ypos)
                     do (setf ypos (ypos v) cv i))
               cv)
             (cross (path &aux (n (length path)))
                "does any segment in path cross the line (aref path 1) (aref path -1)."
                (veq:f2let ((a (gv (aref path 1)))
                            (b (gv (weird:vl path))))
                  (loop for i from 0 below n
                        do ; weird precision issue. override veq eps
                           ; TODO: can we fix this somehow?
                           (let ((veq::*eps* (* 1000f0 veq::*eps*)))
                             (when (veq:f2segx a b (veq:mvcgrp (3 fx)
                                                     (3$verts wer (aref path i)
                                                       (aref path (mod (1+ i) n)))))
                               (return-from cross t)))))
                nil)
             (uw-farthest (path &aux (n (length path)) dst (curr -1))
              "find the vertex in triangle ((aref path 1) (aref path 0) (aref path -1))
               that is the farthest away from (aref path 1) (aref path -1)."
               (loop for i from 2 below (1- n)
                     if ; TODO: this feels very sketchy
                       (let ((veq::*eps* (* 1000f0 veq::*eps*)))
                          (veq:f2in-triangle
                            (veq:mvcgrp (3 fx)
                              (3$verts wer (aref path 0) (aref path 1)
                               (weird:vl path) (aref path i)))))

                     do (let ((d (veq:f2segdst
                                   (veq:mvcgrp (3 fx)
                                     (3$verts wer (aref path 1) (weird:vl path)
                                                  (aref path i))))))
                          (when (or (= curr -1) (> d dst))
                                (setf curr i dst d))))
               (values curr dst))
             (split-diag (path i)
               "split into two paths by introducing a new edge that divides
                path in two loops."
               (when (= i -1) (error "bad split (-1) at: ~a" path))
               (when (< (length path) 3) (error "diag: too few elements in ~a" path))
               (when (>= i (length path)) (error "diag bad ind: ~a ~a" path i))
               (do-step (weird:reorder path (i) (0 i)))
               (do-step (weird:reorder path (0) (i nil))))
             (split-tri (path)
               "split path into a triangle and a new path."
               (do-step (weird:reorder path ((1- (length path))) (0 2)))
               (do-step (subseq path 1)))
             (do-step (path &aux (n (length path)))
               "recursively subdived the path into triangles and/or new loops."
               ; (when (< n 3) (error "do-step: too few elements in ~a" path))
               (when (< n 3) (return-from do-step nil))
               (when (< n 4) (push (add-poly! wer (weird:tl path)) res)
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
                           (progn (warn "possble intersection, unable to detect farthest uw.")
                                  (split-tri path)))))))) ; unable to detect intersection
      (do-step path)
      res)))

(defun obj-import! (wer fn &aux (res (list))
                                (n (get-num-verts wer)))
  (declare #.*opt* (weir wer) (list res) (fixnum n))
  ; TODO this is not a complete obj importer. it fails on
  ; comments. and it does not load face normals, or support quads. among
  ; other things
  (labels
    ((add-poly (o)
       (push (add-poly! wer (mapcar (lambda (i) (+ n (1- i))) o)) res))
     (add-vert (o) (3add-vert! wer (apply #'values o)))
     (parse (l) (cond ((eq (first l) 'cl-user::f)
                       (add-poly
                         (loop for s in (cdr l)
                               collect (read-from-string
                                         (first (veq::split-string
                                                  #\/ (weird:mkstr s)))))))
                      ((eq (first l) 'cl-user::v) (add-vert (cdr l)))))
     (do-line (l)
       (let ((*read-default-float-format* 'single-float))
         (parse (loop for x = (read l nil nil)
                      for i of-type veq:pn from 0
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

    (loop for poly in (get-all-polys wer)
          ; obj files are one-indexed
          do (format fstream "f ~{~d~^ ~}~%" (math:add poly '(1 1 1))))))

