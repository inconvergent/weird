(in-package :weir)

(defmacro dimtest (wer dim fx)
  (declare (symbol wer) (pos-int dim))
  `(when (not (= (weir-dim ,wer) ,dim))
         (error "weir error: incorrect use of: ~a. ~%
                 for weir instance of dim: ~a" ',fx (weir-dim ,wer))))

(defun verts (wer)
  (declare #.*opt* (weir wer))
  (weir-verts wer))

(defmacro dimtemplate ((name) &body body)
  "
  create 2 and 3 dimension version of function named name.
  assumes all-pairs contains a list of 2d properties to replace, then 3d props

  the template must use 'fx as function name, and 'dim as dimension.
  "
  (let ((all-pairs `(((add-vert! . 2add-vert!) (add-verts! . 2add-verts!)
                      (get-vert . 2get-vert) (get-verts . 2get-verts)
                      (split-edge! . 2split-edge!) (v+ . veq:f2+)
                      (vaset . veq:2vaset) (vlet . veq:f2let)
                      (transform! . 2transform!) (dst . veq:f2dst)
                      (edge-length . 2edge-length) (ledge-length . 2ledge-length)
                      (move-vert! . 2move-vert!) ($ . veq:f2$)
                      ($take . veq:f2$take))
                     ((add-vert! . 3add-vert!) (add-verts! . 3add-verts!)
                      (get-vert . 3get-vert) (get-verts . 3get-verts)
                      (split-edge! . 3split-edge!) (v+ . veq:f3+)
                      (vaset . veq:3vaset) (vlet . veq:f3let)
                      (transform! . 3transform!) (dst . veq:f3dst)
                      (edge-length . 3edge-length) (ledge-length . 3ledge-length)
                      (move-vert! . 3move-vert!) ($ . veq:f3$)
                      ($take . veq:f2$take)))))
    `(weird:template
      (,@(loop for dim from 2 to 3
               for pairs in all-pairs
               collect `((fx . ,(intern (apply #'weird:mkstr
                                               `(,dim ,name))
                                        'weir))
                         (dim . ,dim)
                         ,@pairs)))
      (export 'fx)
      ,@body)))

(dimtemplate ($verts)
  (defmacro fx (wer &rest rest)
    `($ (weir-verts ,wer) ,@rest)))

(dimtemplate (get-verts)
  (veq:vdef fx (wer inds)
    (declare #.*opt* (weir wer) (list inds))
    "get the coordinates (vec) of verts in inds"
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts))
      (unless (every (lambda (v) (declare (optimize speed) (pos-int v))
                       (< v num-verts)) inds)
              (error "~a error. ~% invalid vert index in: ~a. ~% num verts: ~a~%"
                     'fx inds num-verts))
      ($take verts inds))))

(dimtemplate (get-grp-verts)
  (defun fx (wer &key g order)
    (declare #.*opt* (weir wer) (boolean order))
    "returns all vertices in grp g.
     note: verts only belong to a grp if they are part of an edge in grp."
    (get-verts wer (get-vert-inds wer :g g :order order))))


(defun is-vert-in-grp (wer v &key g)
  (declare #.*opt* (weir wer) (pos-int v))
  "tests whether v is in grp g
   note: verts only belong to a grp if they are part of an edge in grp."
  (with-struct (weir- grps) wer
    (mvb (g* exists) (gethash g grps)
      (if exists (graph:vmem (grp-grph g*) v)
                 (error "grp does not exist: ~a" g)))))


(defun get-num-verts (wer)
  (declare #.*opt* (weir wer))
  (weir-num-verts wer))


(defun get-grp-num-verts (wer &key g)
  (declare #.*opt* (weir wer))
  (with-grp (wer g* g)
    (graph:get-num-verts (grp-grph g*))))


(dimtemplate (add-vert!)
  (veq:vdef* fx (wer (veq:varg dim x))
    (declare #.*opt* (weir wer) (veq:ff x))
    "adds a new vertex to weir. returns the new vert ind"
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts max-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts max-verts))
      (when (>= num-verts max-verts)
            (error "~a error. ~% too many verts ~a~%." 'fx num-verts))
      (vaset (verts num-verts) (values x))
      (incf (weir-num-verts wer))
      num-verts)))

(dimtemplate (vadd-edge!)
  (veq:vdef* fx (wer (veq:varg dim a b) &key g)
    (declare #.*opt* (weir wer) (veq:ff a b))
    (dimtest wer dim fx)
    (add-edge! wer (add-vert! wer a) (add-vert! wer b) :g g)))


(dimtemplate (add-verts!)
  (veq:vdef fx (wer vv)
    (declare #.*opt* (weir wer) (veq:fvec vv))
    "adds new vertices to weir. returns the ids of the new vertices"
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts max-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts))
      (let* ((n (/ (length vv) dim))
             (new-num (+ num-verts n)))
        (declare (pos-int n new-num))
        (unless (<= new-num max-verts)
                (error "~a error. too many verts: ~a~%" 'fx new-num))
        (veq:fwith-arrays (:n new-num :itr i :start num-verts :cnt c
          :arr ((verts dim verts)
                (vv dim vv))
          :fxs ((acc (j) ($ vv j)))
          :exs ((verts i (acc c))))
          (setf (weir-num-verts wer) new-num)
          (values (math:range num-verts new-num) dim n))))))


(dimtemplate (get-vert)
  (veq:vdef fx (wer v)
    (declare #.*opt* (weir wer) (pos-int v))
    "get the coordinate of vert v"
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts))
      (when (>= v num-verts)
            (error "~a error. ~% invalid vert: ~a~%. ~% num verts: ~a~%"
                   'fx v num-verts))
      ($ verts v))))


(dimtemplate (get-all-verts)
  (veq:vdef fx (wer)
    (declare #.*opt* (weir wer))
    "returns the coordinates of all vertices"
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts))
      (veq:fwith-arrays (:n num-verts :itr k
        :arr ((verts dim verts)
              (res dim (veq:f$make :dim dim :n num-verts)))
        :fxs ((acc ((veq:varg dim x))
                     (declare (optimize speed) (veq:ff x))
                     (values x)))
        :exs ((res k (acc verts))))
        (values res dim num-verts)))))


(dimtemplate (move-vert!)
  (veq:vdef* fx (wer i (veq:varg dim x) &key (rel t))
    (declare #.*opt* (weir wer) (pos-int i) (veq:ff x) (boolean rel))
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts))
      (when (>= i num-verts)
            (error "~a error. attempting to move invalid vert, ~a. ~% num verts: ~a~%"
                   'fx i num-verts))
      (vlet ((res (if rel (v+ x ($ verts i)) (values x))))
        (vaset (verts i) (values res))
        (values res)))))


(dimtemplate (transform!)
  (veq:vdef fx (wer inds tfx)
    (declare #.*opt* (weir wer) (list inds) (function tfx))
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts))
      (unless (every (lambda (v) (declare (optimize speed) (pos-int v))
                       (< v num-verts)) inds)
              (error "~a error. ~% invalid vert index in: ~a. ~% num verts: ~a~%"
                     'fx inds num-verts))
      (veq:fwith-arrays (:n num-verts :itr k :inds inds
        :arr ((verts dim verts))
        :fxs ((trans ((veq:varg dim x))
               (declare (optimize speed) (veq:ff x))
               (funcall tfx x)))
        :exs ((verts k (trans verts))))))))


(dimtemplate (grp-transform!)
  (defun fx (wer trans &key g)
    (declare (weir wer) (function trans))
    (transform! wer (get-vert-inds wer :g g) trans)))


(dimtemplate (split-edge!)
  (veq:vdef* fx (wer u v (veq:varg dim x) &key g force)
  (declare #.*opt* (weir wer) (pos-int u v) (veq:ff x) (boolean force))
  "split edge (u v) at x. returns new vert ind (and new edges)."
  (dimtest wer dim fx)
  (if (or (del-edge! wer u v :g g) force)
      (let ((c (add-vert! wer x)))
        (declare (pos-int c))
        (values c (list (add-edge! wer c u :g g) (add-edge! wer c v :g g))))
      (values nil nil))))

(dimtemplate (lsplit-edge!)
  (veq:vdef* fx (wer ll (veq:varg dim x) &key g force)
    (declare #.*opt* (weir wer) (list ll) (veq:ff x) (boolean))
    (destructuring-bind (u v) ll
      (declare (pos-int u v))
      (split-edge! wer u v x :g g :force force))))

(dimtemplate (append-edge!)
  (veq:vdef* fx (wer v (veq:varg dim x) &key (rel t) g)
    "add edge between vert v and new vert at xy"
    (declare (weir wer) (pos-int v) (veq:ff x) (boolean rel))
    (dimtest wer dim fx)
    (add-edge! wer v (if rel (add-vert! wer (v+ x (get-vert wer v)))
                             (add-vert! wer x))
               :g g)))


(dimtemplate (edge-length)
  (veq:vdef fx (wer u v)
    (declare #.*opt* (weir wer) (pos-int u v))
    "returns the length of edge e=(u v). regardless of whether the edge exists"
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts))
      (unless (and (< u num-verts) (< v num-verts))
              (error "~a error. invalid vert in edge (~a ~a). ~% num verts: ~a~%"
                     'fx u v num-verts))
      (dst ($ verts u v)))))

(dimtemplate (ledge-length)
  (defun fx (wer e)
    (declare #.*opt* (weir wer) (list e))
    "returns the length of edge e=(u v). regardless of whether the edge exists"
    (dimtest wer dim fx)
    (apply #'edge-length wer e)))


(dimtemplate (prune-edges-by-len!)
  (defun fx (wer lim &optional (pfx #'>))
    (declare #.*opt* (weir wer) (veq:ff lim) (function pfx))
    "remove edges longer than lim, use fx #'< to remove edges shorter than lim"
    (dimtest wer dim fx)
    (itr-edges (wer e)
      (when (funcall (the function pfx) (ledge-length wer e) lim)
            (ldel-edge! wer e)))))


(dimtemplate (add-path!)
  (defun fx (wer points &key g closed)
    (declare #.*opt* (weir wer) (veq:fvec points))
    (add-path-ind! wer (add-verts! wer points) :g g :closed closed)))

; TODO: implement new export/import
; (defun export-verts-grp (wer &key g)
;   (declare #.*opt* (weir wer))
;   "export verts, as well as the edges in g, on the format (verts edges)"
;   (-dimtest wer)
;   (list (get-all-verts wer) (get-edges wer :g g)))

; (defun import-verts-grp (wer o &key g)
;   (declare #.*opt* (weir wer) (list o))
;   "import data exported using export-verts-grp"
;   (-dimtest wer)
;   (when (> (get-num-verts wer) 0)
;         (error "ensure there are no initial verts in wer."))
;   (dsb (verts edges) o
;     (declare (list verts edges))
;     (add-verts! wer verts)
;     (loop for e of-type list in edges do (ladd-edge! wer e :g g))))


(weird:abbrev 2av! 2add-vert!)
(weird:abbrev 2avs! 2add-verts!)
(weird:abbrev 2gvs 2get-verts)
(weird:abbrev 2gv 2get-vert)

(weird:abbrev 3av! 3add-vert!)
(weird:abbrev 3avs! 3add-verts!)
(weird:abbrev 3gvs 3get-verts)
(weird:abbrev 3gv 3get-vert)


(veq:vdef center! (wer &key max-side non-edge g)
  (declare #.*opt* (weir wer))
  "center the verts of wer on xy. returns the previous center"
  (dimtest wer 2 '2center!)
  (labels ((scale-by (ms w h)
             (declare (veq:ff ms w h))
             (if (> w h) (/ ms w) (/ ms h))))
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (pos-int num-verts))
      (mvb (minx maxx miny maxy)
        (if non-edge (veq:f2$mima verts :n num-verts)
                     (veq:f2$mima verts :inds (get-vert-inds wer :g g)))
        (veq:f2let ((mx (veq:f2scale (veq:f2+ minx miny maxx maxy) 0.5f0))
                    (wh (veq:f2- maxx maxy minx miny)))
          (let ((s (if max-side (scale-by max-side wh) 1f0)))
            (declare (veq:ff s))
            (veq:fwith-arrays (:n num-verts :itr k
              :arr ((verts 2 verts))
              :fxs ((cent ((veq:varg 2 x))
                     (veq:f2+ mx (veq:f2scale (veq:f2- x mx) s))))
              :exs ((verts k (cent verts)))))
            (mvc #'values mx wh s)))))))

; TODO: port this to actual 3d
; (defun -3scale-by (ms w h d)
;   (declare #.*opt* (veq:ff ms w h))
;   (if (> w h) (/ ms w) (/ ms h)))

; (veq:vdef center! (wer &key max-side non-edge g)
;   "center the verts of wer on xy. returns the previous center"
;   (dimtest wer 3 '3center!)
;   (with-struct (weir- verts num-verts) wer
;     (declare (veq:fvec verts) (pos-int num-verts))
;     (mvb (minx maxx miny maxy)
;       (if non-edge (veq:f3$mima verts :n num-verts)
;                    (veq:f3$mima verts :inds (get-vert-inds wer :g g)))
;       (veq:f3let ((mx (veq:f3scale (veq:f3+ minx miny maxx maxy) 0.5f0))
;                   (wh (veq:f3- maxx maxy minx miny)))
;         (let ((s (if max-side (-3scale-by max-side wh) 1f0)))
;           (declare (veq:ff s))
;           (veq:fwith-arrays (:n num-verts :itr k
;             :arr ((verts 3 verts))
;             :fxs ((cent ((veq:varg 3 x))
;                    (veq:f3+ mx (veq:f3scale (veq:f3- x mx) s))))
;             :exs ((verts k (cent verts)))))
;           (mvc #'values mx wh s))))))


; SHAPES ----------------------

(veq:vdef* 2is-intersection (wer a b)
  (declare (weir wer) (pos-int a b))
  (veq:f2segx (2gv wer a) (2gv wer a)))


(defun 3add-box! (wer &key (s (math:nrep 3 100f0)) (xy (math:nrep 3 0f0)) g)
  (declare (weir wer) (list s xy))
  "add a box with size, s = (sx sy sz) at xy = (x y z)"
  (dimtest wer 3 3add-box!)
  (labels ((pos (pos) (declare (list pos))
                      (mapcar (lambda (a s x) (declare (fixnum a))
                                (veq:ff (+ (* a s) x)))
                              pos s xy))
           (get-pos (pts) (veq:f$_ (mapcar #'pos pts))))
    (mapcar (lambda (a b) (add-edge! wer a b :g g))
      (graph:edge-set->path
        (3add-path! wer (get-pos '((1 1 1) (1 -1 1) (-1 -1 1) (-1 1 1)))
        :closed t :g g))
      (graph:edge-set->path
        (3add-path! wer (get-pos '((1 1 -1) (1 -1 -1) (-1 -1 -1) (-1 1 -1)))
        :closed t :g g)))))

(defun 3add-cube! (wer &key (s 1f0) (xy (math:nrep 3 0f0)) g)
  (declare (weir wer) (veq:ff s) (list xy))
  (3add-box! wer :s (math:nrep 3 s) :xy xy :g g))

