(in-package :weir)

; SPANNING TREE

(defun get-spanning-tree (wer &key g edges start)
  (with-grp (wer grp g)
    (if edges (graph:get-edges
                (graph:get-spanning-tree (grp-grph grp) :start start))
              (graph:get-spanning-tree (grp-grph grp) :start start))))


(defun get-min-spanning-tree (wer &key g edges start)
  (with-grp (wer grp g)
    (let ((grph (grp-grph grp))
          (weigthfx (lambda (a b) (2edge-length wer a b))))
      (if edges (graph:get-edges (graph:get-min-spanning-tree grph
                                   :start start :weightfx weigthfx))
                (graph:get-min-spanning-tree grph
                   :start start :weightfx weigthfx)))))

; CONTINOUS PATHS

; TODO: include perfect loops
(defun get-segments (wer &key cycle-info g)
  (with-grp (wer grp g)
    (graph:get-segments (grp-grph grp) :cycle-info cycle-info)))


(veq:vdef 2walk-graph (wer &key g)
  (let ((verts (weir-verts wer)))
    (declare (veq:fvec verts))
    (labels ((diff (a b)
               (declare (fixnum a b))
               (veq:f2norm (veq:f2- (veq:f2$ verts b a))))
             (angle (a b c)
               (declare (fixnum a b c))
               (handler-case (veq:f2. (diff a b) (diff b c))
                             (floating-point-invalid-operation (e)
                               (declare (ignore e)) 1f0))))
      (with-grp (wer grp g)
        (graph:walk-graph (grp-grph grp) :angle #'angle)))))

; SIMPLIFY SEGMENTS

(defun 2simplify-segments (wer &key g)
  (declare #.*opt* (weir wer))
  ; TOOD: deal with paths that are closed
  (loop for (seg _) of-type (list boolean) in (get-segments wer :cycle-info t :g g)
        do (weird:mvb (_ sind) (simplify:path (weir:2gvs wer seg) :lim 100f0)
             (declare (ignore _) (vector sind))
             (when (not (= (length seg) (length sind)))
                   (let ((seg* (loop for i across sind collect (nth i seg))))
                     (declare (list seg*))
                     (weir:del-path! wer seg)
                     (weir:add-path-ind! wer seg*))))))

; INTERSECTS

(deftype simple-list () `(simple-array list))

(defun 2intersect-all! (wer &key g)
  (declare #.*opt* (weir wer))
  (unless (= 2 (weir-dim wer))
          (error "2intersect-all! error. incorrect dimension."))

  (let ((crossing->vert (make-hash-table :test #'equal)))
    (declare (hash-table crossing->vert))

    (labels
      ((ic (i c) (declare (fixnum i c)) (if (< i c) (list i c) (list c i)))

       (add (line i hits)
         (declare (list hits) (fixnum i))
         (loop for (c . p) in hits
               if (not (gethash (the list (ic i c)) crossing->vert))
               do (veq:vprogn
                    (setf (gethash (the list (ic i c)) crossing->vert)
                          (2add-vert! wer (veq:f2lerp (veq:f2$ line 0 1) p))))))

       (add-new-verts (edges isects)
         (declare (simple-list edges isects))
         (loop for hits across isects
               for i of-type fixnum from 0
               if hits do (add (2gvs wer (aref edges i)) i hits)))

       (edges-as-lines (edges)
         (declare (simple-list edges))
         (loop for edge of-type list across edges
               collect (2gvs wer edge)))

       (del-hit-edges (edges isects g)
         (declare (simple-list edges isects))
         (loop for hits of-type list across isects
               for i of-type fixnum from 0
               if hits do (ldel-edge! wer (aref edges i) :g g)
                          (loop for (c . p) in hits
                                do (ldel-edge! wer (aref edges c) :g g))))

       (sort-hits (isects)
         (declare (simple-list isects))
         (loop for i of-type fixnum from 0 below (length isects)
               if (aref isects i)
               do (setf (aref isects i)
                        (sort (aref isects i) #'< :key #'cdr)))
         isects)

       (add-new-edges (edges isects g)
         (declare (simple-list edges isects))
         (loop for hits of-type list across isects
               for i of-type fixnum from 0
               if hits
               do (loop with cc = (math:lpos hits)
                        for a of-type fixnum in cc
                        and b of-type fixnum in (cdr cc)
                        initially
                          (add-edge! wer
                            (gethash (ic i (first cc)) crossing->vert)
                            (first (aref edges i)) :g g)
                          (add-edge! wer
                            (gethash (ic i (last* cc)) crossing->vert)
                            (last* (aref edges i)) :g g)
                        do (add-edge! wer
                             (gethash (ic i a) crossing->vert)
                             (gethash (ic i b) crossing->vert) :g g)))))

      (let* ((edges (to-vector (get-edges wer :g g)))
             (lines (to-vector (edges-as-lines edges)))
             (isects (sort-hits (veq:f2lsegx lines))))
        (declare (simple-list isects edges) (simple-array lines))
        (del-hit-edges edges isects g)
        (add-new-verts edges isects)
        (add-new-edges edges isects g))))
  nil)

