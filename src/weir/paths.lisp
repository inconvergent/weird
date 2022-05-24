(in-package :weir)

; SPANNING TREE

(defun get-spanning-tree (wer &key g edges start)
  "returns a spanning tree of g. optionally start at vertex start.
if edges is t, returns the result as an edge set."
  (with-grp (wer grp g)
    (if edges (graph:get-edges
                (graph:get-spanning-tree (grp-grph grp) :start start))
              (graph:get-spanning-tree (grp-grph grp) :start start))))


(defun get-min-spanning-tree (wer &key g edges start)
  "returns a minimal spanning tree of g, which starts at start (optional).
if edges is true, it returns the graph as an edge set."
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
  "return all segments in g. use :cycle-info to return an additional boolean for
whether the segment is a cycle."
  (with-grp (wer grp g)
    (graph:get-segments (grp-grph grp) :cycle-info cycle-info)))


(veq:vdef 2walk-graph (wer &key g)
  (declare (weir wer))
  "returns all segments of the graph in g.
greedily attempts to connect segments such that the angle is minimal. useful
for drawing the graph as a plotter drawing. call 2simplify-segments! first if
you want to reduce the level of detail.
cycles will begin and end with the same vert index."
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

(defun 2simplify-segments! (wer &key g (lim 0.1))
  (declare #.*opt* (weir wer) (veq:ff lim))
  "calls (simplify:path ...) on all segments from (weird:get-segments ... :g g).
as such the overall structure of the graph will remain the same."
  ; TOOD: deal with paths that are closed
  (loop for (seg _) of-type (list boolean) in (get-segments wer :cycle-info t :g g)
        do (weird:mvb (_ sind) (simplify:path (2gvs wer seg) :lim lim)
             (declare (ignore _) (vector sind))
             (when (not (= (length seg) (length sind)))
                   (let ((seg* (loop for i across sind collect (nth i seg))))
                     (declare (list seg*))
                     (del-path! wer seg)
                     (add-path-ind! wer seg*))))))

; INTERSECTS

(deftype simple-list () `(simple-array list))

(veq:vdef 2intersect-all! (wer &key g prop)
  (declare #.*opt* (weir wer))
  "creates intersections for all edges in g such that g becomes a planar graph.
:prop can contain a symbol which will be used as a
vert prop which contains one of the initial edges
edge prop which contains one of the intial edges.
a useful method for making plotter drawings is to do:

(2simplify-segments! wer ...) ; optional
(2intersect-all! wer ...)
(loop for path in (2walk-graph wer ...)
      do (wsvg:path wsvg (2gvs wer path)))"
  (unless (= 2 (weir-dim wer))
          (error "2intersect-all! error. incorrect dimension."))

  (let ((crossing->vert (make-hash-table :test #'equal)))
    (declare (hash-table crossing->vert))

    (labels
      ((ic (i c) (declare (fixnum i c)) (if (< i c) (list i c) (list c i)))

       (add-vert (old-edge line i hits)
         (declare (list old-edge hits) (fixnum i))
         (loop for (c . p) in hits
               if (not (gethash (the list (ic i c)) crossing->vert))
               do (let ((new (2add-vert! wer (veq:f2lerp (veq:f2$ line 0 1) p))))
                    (declare (pos-int new))
                    (setf (gethash (the list (ic i c)) crossing->vert) new)
                    (when prop (set-vert-prop wer new
                                 (the keyword prop) old-edge)))))

       (add-new-verts (edges isects)
         (declare (simple-list edges isects))
         (loop for hits across isects
               for i of-type fixnum from 0
               if hits
               do (let ((old-edge (aref edges i)))
                    (add-vert old-edge (2gvs wer old-edge) i hits))))

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

       (-add! (a b &key e g)
         (declare (pos-int a b) (list e))
         (if prop (set-edge-prop wer
                    (add-edge! wer a b :g g) (the keyword prop) e)
                  (add-edge! wer a b :g g)))

       (add-new-edges (edges isects g)
         (declare (simple-list edges isects))
         (loop for hits of-type list across isects
               for i of-type fixnum from 0
               if hits
               do (loop with cc = (math:lpos hits)
                        with ei = (aref edges i)
                        for a of-type fixnum in cc
                        and b of-type fixnum in (cdr cc)
                        initially
                          (-add! (gethash (ic i (first cc)) crossing->vert)
                                 (first ei) :g g :e ei)
                          (-add! (gethash (ic i (last* cc)) crossing->vert)
                                 (last* ei) :g g :e ei)
                        do (-add! (gethash (ic i a) crossing->vert)
                                  (gethash (ic i b) crossing->vert)
                                  :g g :e ei)))))
             ; edges ((v1 v2) (v8 v1) ...)
      (let* ((edges (to-vector (get-edges wer :g g)))
             ; lines: (#(ax ay bx by) #(cx cy dx dy) ...)
             (lines (to-vector (edges-as-lines edges)))
             ; isects: #(((16 . 0.18584675) (5 . 0.35215548)) NIL NIL ...)
             (isects (sort-hits (veq:f2lsegx lines)))) ;  p/q is the lerp
        (declare (simple-list isects edges) (simple-array lines))
        (del-hit-edges edges isects g)
        (add-new-verts edges isects)
        (add-new-edges edges isects g))))
  nil)


; TODO: clean this up and rename
(veq:vdef 3intersect-all! (wer fx &key g prop)
  (declare #.*opt* (weir wer) (function fx))
  "does the same as 2intersect-all!
assuming that fx is a function (values x y z) -> (values x1 y1)."

  (unless (= 3 (weir-dim wer))
          (error "3intersect-all! error. incorrect dimension."))

  (labels
    ((add-path-verts (old-edge line hits)
       (declare (list old-edge hits))
       "add verts along edge for each intersect"
       (loop for (c . p) in hits
             collect (let ((new (3add-vert! wer
                                  (veq:f3lerp (veq:f3$ line 0 1) p))))
                       (declare (pos-int new))
                       (when prop (set-vert-prop wer new
                                    (the keyword prop) old-edge))
                       new)))

     (add-new-paths (edges isects g)
       (declare (simple-list edges isects))
       "add new edge along old edge with new verts for each intersect"
       (loop for hits across isects
             for i of-type fixnum from 0
             if hits
             do (let* ((old-edge (aref edges i))
                       (path-ind (add-path-verts old-edge
                                    (3gvs wer old-edge) hits)))
                  (declare (list old-edge path-ind))
                  ; insert path-ind into old-edge
                  (when path-ind
                    (add-path-ind! wer
                      (cons (first old-edge)
                            (concatenate 'list path-ind (last old-edge)))
                      :g g)))))

     (edges-as-lines (edges)
       (declare (simple-list edges))
       (loop for edge of-type list across edges
             collect (3gvs wer edge)))

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
       isects))
           ; edges: ((v1 v2) (v8 v1) ...)
    (let* ((edges (to-vector (get-edges wer :g g)))
           ; lines: (#(ax ay bx by) #(cx cy dx dy) ...)
           (lines (map 'vector fx (edges-as-lines edges)))
           ; isects: #(((16 . 0.18584675) (5 . 0.35215548)) NIL NIL ...)
           (isects (sort-hits (veq:f2lsegx lines)))) ;  p/q is the lerp
      (declare (simple-list isects edges) (simple-array lines))
      (add-new-paths edges isects g)
      (del-hit-edges edges isects g)))
  nil)

