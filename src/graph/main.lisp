
(in-package :graph)

"a simple (undirected) graph structure based on adjacency lists."

(deftype pos-int (&optional (bits 31)) `(unsigned-byte ,bits))


(defstruct (graph (:constructor -make-graph))
  (size 0 :type pos-int :read-only t)
  (num-edges 0 :type pos-int)
  (adj nil :type hash-table)
  (make-hset #'identity :type function :read-only t))


(defun make (&key (adj-size 4) (adj-inc 2f0)
                  (set-size 10) (set-inc 2f0))
  (declare #.*opt*)
  "create undirected graph instance with no spatial awareness.

since the graph is undirected. all edges are normalized such that the smallest
vertex is first. any checks that compare edges in any sense will return the
same value for (a b) and (b a).

assuming the following graph:

  x-y-u
  |   |
a-b-c-d-o
  |
  y

this terminology is used:
  - ab, by and do are (simple) filaments.
  - bcd and bxyud are segments.
  - (simple) filaments are segments.
  - bcduyx(b) is a cycle.
  - b and d are multi intersection points/vertices
  - a, y, o are dead-ends.

arguments:
  - adj-size: initial size of adjacency hash-table
    (total number of verts)
  - adj-inc: size multiplier for hash-table
  - set-size: initial size of vert adjecency list
    (typical number of edges per vert)
  - set-inc: size multiplier vert adjecency list
default values should usually work fine."
  (-make-graph :num-edges 0
    :adj (make-hash-table :test #'eql :size adj-size :rehash-size adj-inc)
    :make-hset (lambda (x) (hset:make :init x :size set-size :inc set-inc))))

(defun copy (grph)
  (declare #.*opt* (graph grph))
  "return copy of graph instance."
  ; :key is called in the value before setting
  ; https://common-lisp.net/project/alexandria/draft/alexandria.html#Hash-Tables
  ; TODO: handle adj-size, set-size, set-inc, adj-inc across graph struct
  (-make-graph :num-edges (graph-num-edges grph)
               :adj (alexandria:copy-hash-table (graph-adj grph)
                      :key #'hset:copy)
               :make-hset (graph-make-hset grph)))


(defun -add (makefx adj a b)
  (declare #.*opt* (function makefx) (pos-int a b))
  (multiple-value-bind (val exists) (gethash a adj)
    (if (not exists)
        (progn (setf val (funcall makefx (list b))
                         (gethash a adj) val)
               t)
        (hset:add val b))))


(defun add (grph a b)
  (declare #.*opt* (graph grph) (pos-int a b))
  "add edge ab. returns t if edge did not exist."
  (with-struct (graph- adj make-hset) grph
    (declare (function make-hset))
    (let ((ab (-add make-hset adj a b))
          (ba (-add make-hset adj b a)))
      (declare (boolean ab ba))
      (when (or ab ba) (incf (graph-num-edges grph) 2)
                       t))))


(declaim (inline -del))
(defun -del (adj a b)
  (declare #.*opt* (pos-int a b))
  (multiple-value-bind (val exists) (gethash a adj)
    (when exists (hset:del val b))))


(defun -prune (adj a)
  (declare #.*opt* (pos-int a))
  (multiple-value-bind (val exists) (gethash a adj)
    (when (and exists (< (the pos-int (hset:num val)) 1))
          (remhash a adj))))


(defun del (grph a b)
  (declare #.*opt* (graph grph) (pos-int a b))
  "del edge ab. returns t if edge existed."
  (with-struct (graph- adj) grph
    (let ((ab (-del adj a b))
          (ba (-del adj b a)))
      (declare (boolean ab ba))
      (when (or ab ba) (-prune adj a)
                       (-prune adj b)
                       (decf (graph-num-edges grph) 2)
                       t))))


(defun get-num-edges (grph)
  (declare #.*opt* (graph grph))
  "return total number of edges in graph."
  (/ (graph-num-edges grph) 2))

(defun get-num-verts (grph)
  (declare #.*opt* (graph grph))
  "return total number of verts in graph. only counts vertices with connected
edges." ;TODO: i think?
  (hash-table-count (graph-adj grph)))


(defun mem (grph a b)
  (declare #.*opt* (graph grph) (pos-int a b))
  "check if edge ab exists."
  (with-struct (graph- adj) grph
    (multiple-value-bind (val exists) (gethash a adj)
      (when exists (hset:mem val b)))))


(defun get-edges (grph)
  (declare #.*opt* (graph grph))
  "get list of lists of all edges."
  (loop with res of-type list = (list)
        with adj of-type hash-table = (graph-adj grph)
        for a of-type pos-int being the hash-keys of adj
        do (loop for b of-type pos-int being the hash-keys of (gethash a adj)
                 if (< a b) do (push (list a b) res))
        finally (return res)))


(defun get-verts (grph)
  (declare #.*opt* (graph grph))
  "return all vertices with at least one connected edge."
  (loop for v being the hash-keys of (graph-adj grph) using (hash-value ee)
        collect v))


(defun get-incident-edges (grph v)
  (declare #.*opt* (graph grph) (pos-int v))
  "get all incident edges of v."
  (labels ((-srt (a b)
             (declare (optimize speed) (pos-int a b))
             (if (< a b) (list a b) (list b a))))
    (with-struct (graph- adj) grph
      (let ((a (gethash v adj)))
        (when a (loop for w of-type pos-int
                        being the hash-keys of (the hash-table a)
                      collect (-srt v w)))))))

(defun -only-incident-verts (v ee)
  (declare #.*opt* (pos-int v) (list ee))
  (remove-if (lambda (i)
               (declare (optimize speed) (pos-int i))
               (= i v))
             (alexandria:flatten ee)))

(defun get-incident-verts (grph v)
  (declare #.*opt* (graph grph) (pos-int v))
  "get all incident vertices of v."
  ; TODO: avoid using incident edges, to avoid consing
  ; this is used by cycle finder, so it should be fast
  (-only-incident-verts v (get-incident-edges grph v)))


(defun vmem (grph v)
  (declare #.*opt* (graph grph) (pos-int v))
  "check if v has at least one connected edge."
  (if (gethash v (graph-adj grph)) t nil))


(defmacro with-graph-edges ((grph e) &body body)
  "iterate over all edges as e. more efficient than get-edges because it does
not build the entire structure.
ex (with-graph-edges (grph e) (print e))"
  (alexandria:with-gensyms (adj a b)
    `(loop with ,e of-type list
           with ,adj of-type hash-table = (graph-adj ,grph)
           for ,a of-type pos-int being the hash-keys of ,adj collect
      (loop for ,b of-type pos-int being the hash-keys of (gethash ,a ,adj)
            if (< ,a ,b)
            do (setf ,e (list ,a ,b))
               (progn ,@body)))))

