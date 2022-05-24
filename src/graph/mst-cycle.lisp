
(in-package :graph)

(declaim (veq:ff *inf*))
(defvar *inf* 1f8)


; SPANNING TREE

(defun -do-spanning-tree (grph st visited start)
  (declare (graph grph st) (hash-table visited) (fixnum start))
  (loop with curr of-type fixnum = -1
        with stack of-type list = (list (list start start))
        while stack
        do (destructuring-bind (curr* parent) (pop stack)
             (declare (fixnum curr* parent))
             (setf curr curr*)
             ; if not visited, visit, and add descendants
             (when (hset:add visited curr)
                   (unless (= curr parent) (graph:add st curr parent))
                   (loop for next of-type fixnum
                           in (get-incident-verts grph curr)
                         do ; add (next curr) to stack
                            (setf stack (cons (list next curr) stack))))))
  st)

(defun get-spanning-tree (grph &key start)
  "return all spanning trees (if the graph is disjoint) of grph in a new graph.
if start is provided, it will return a spanning tree starting at start."
  (declare (graph grph))
  (let ((visited (hset:make))
        (st (make))
        (num 0))
    (declare (hash-table visited) (graph st) (fixnum num))
    (if start (progn (-do-spanning-tree grph st visited start)
                     (setf num 1))
              (loop for v of-type fixnum in (get-verts grph)
                    unless (hset:mem visited v)
                    do (-do-spanning-tree grph st visited v)
                       (incf num)))
    ; num is the number of subgraphs/trees
    (values st num)))


; MIN SPANNING TREE

(defun -do-min-spanning-tree (grph q weight edge weightfx
                              &aux (c 0f0) (mst (make)))
  (declare (graph grph mst) (hash-table weight edge q)
           (function weightfx) (veq:ff c))
  ; some version of prim's algorithm.
  ; missing binary heap to find next vertex to add
  (labels
    ((-find-next-min-edge ()
       (loop with cv of-type veq:ff = (+ 1f0 *inf*) ; cost
             with v of-type fixnum = -1 ; index
             for w of-type fixnum being the hash-keys of q
             do (when (< (gethash w weight) cv)
                      ; update minimum: v=w and cv=weight[w]
                      (setf v w cv (gethash w weight)))
             finally (return (values v cv))))

     (-update-descendant (v w cw)
       (multiple-value-bind (_ exists) (gethash w q)
         (declare (ignore _) (boolean exists))
         (when (and exists (< cw (gethash w weight)))
               ; update: weight[w]=cw and edge[w]=v
               (setf (gethash w weight) cw (gethash w edge) v)))))

    (loop while (> (hash-table-count q) 0)
          do (multiple-value-bind (v c*) (-find-next-min-edge)
               (declare (fixnum v) (veq:ff c*))
               (when (< v 0) (error "mst: hit negative vert"))
               ; remove (min) v from q
               (remhash v q)
               ; when edge exists
               (multiple-value-bind (w exists) (gethash v edge)
                 ; add edge to graph
                 (when (and exists w) (add mst v w) (incf c c*)))
               ; descendants of v
               (loop for w of-type fixnum in (get-incident-verts grph v)
                     do (-update-descendant v w (funcall weightfx v w))))))
  (values mst c))

(defun -init-hash-table (keys v)
  (declare (list keys))
  (loop with res of-type hash-table = (make-hash-table :test #'eql)
        for k of-type fixnum in keys
        do (setf (gethash k res) v)
        finally (return res)))

(defun get-min-spanning-tree (grph &key (weightfx (lambda (a b)
                                                    (declare (ignore a b)) 1f0))
                                        (start 0))
  "return all minimal spanning trees of grph in a new graph.
if start is provided, it will return a spanning tree starting at start."
  ; TODO: what happens if grph is disjoint?
  (declare (graph grph) (fixnum start) (function weightfx))
  (let* ((verts (get-verts grph))
         (weight (-init-hash-table verts *inf*)) ; ht
         (edge (-init-hash-table verts nil)) ; ht
         (q (-init-hash-table verts t))) ; hset: verts not in tree
    (when start (setf (gethash start weight) 0f0))
    (-do-min-spanning-tree grph q weight edge weightfx)))

