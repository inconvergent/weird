(in-package :weir)

(defmacro dimtest (wer dim fx)
  "used internally to check that weir instance has correct dimension."
  (declare (symbol wer) (veq:pn dim))
  `(when (not (= (weir-dim ,wer) ,dim))
         (error "weir error: incorrect use of: ~a. ~%
                 for weir instance of dim: ~a" ',fx (weir-dim ,wer))))

(defun verts (wer)
  (declare #.*opt* (weir wer))
  "get vertex array."
  (weir-verts wer))


(dimtemplate ($verts
  "get coordinates of vert i, j, ... as (values i1 i2 .. j1 j2 ..).")
  (defmacro fx (wer &rest rest)
    docs
    `(veq:fvprogn (veq::f@$ (weir-verts ,wer) ,@rest))))

(dimtemplate (get-verts
  "get the coordinates (vec) of verts in inds.")
  (veq:fvdef fx (wer inds)
    (declare #.*opt* (weir wer) (list inds))
    docs
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts))
      (unless (every (lambda (v) (declare (optimize speed) (veq:pn v))
                       (< v num-verts)) inds)
              (error "~a error. ~% invalid vert index in: ~a. ~% num verts: ~a~%"
                     'fx inds num-verts))
      (veq::f@$take verts inds))))

(dimtemplate (get-grp-verts
  "returns all vertices in grp g.
note: verts only belong to a grp if they are part of an edge in grp.")
  (defun fx (wer &key g order)
    (declare #.*opt* (weir wer) (boolean order))
    docs
    (@get-verts wer (get-vert-inds wer :g g :order order))))


(dimtemplate (add-vert!
  "adds a new vertex to weir. returns the new vert ind.")
  (veq:fvdef* fx (wer (:varg dim x))
    (declare #.*opt* (weir wer) (veq:ff x))
    docs
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts max-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts max-verts))
      (when (>= num-verts max-verts)
            (error "~a error. ~% too many verts ~a~%." 'fx num-verts))
      (veq::@$vset (verts num-verts) (values x))
      (incf (weir-num-verts wer))
      num-verts)))

(dimtemplate (vadd-edge!
  "add edge from two coordinates.")
  (veq:fvdef* fx (wer (:varg dim a b) &key g)
    (declare #.*opt* (weir wer) (veq:ff a b))
    docs
    (dimtest wer dim fx)
    (add-edge! wer (@add-vert! wer a) (@add-vert! wer b) :g g)))


(dimtemplate (add-verts!
  "adds new vertices to weir. returns the ids of the new vertices.")
  (veq:fvdef fx (wer vv)
    (declare #.*opt* (weir wer) (veq:fvec vv))
    docs
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts max-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts))
      (let* ((n (/ (length vv) dim))
             (new-num (+ num-verts n)))
        (declare (veq:pn n new-num))
        (unless (<= new-num max-verts)
                (error "~a error. too many verts: ~a~%" 'fx new-num))
        (veq:fwith-arrays (:n new-num :itr i :start num-verts :cnt c
          :arr ((verts dim verts)
                (vv dim vv))
          :fxs ((acc (j) (veq::f@$ vv j)))
          :exs ((verts i (acc c))))
          (setf (weir-num-verts wer) new-num)
          (values (math:range num-verts new-num) dim n))))))


(dimtemplate (get-vert
  "get the coordinate of vert v.")
  (veq:fvdef fx (wer v)
    (declare #.*opt* (weir wer) (veq:pn v))
    docs
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts))
      (when (>= v num-verts)
            (error "~a error. ~% invalid vert: ~a~%. ~% num verts: ~a~%"
                   'fx v num-verts))
      (veq::f@$ verts v))))


(dimtemplate (get-all-verts
  "returns the coordinates of all vertices.")
  (veq:fvdef fx (wer)
    (declare #.*opt* (weir wer))
    docs
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts))
      (veq:fwith-arrays (:n num-verts :itr k
        :arr ((verts dim verts)
              (res dim (veq:f$make :dim dim :n num-verts)))
        :fxs ((acc ((:varg dim x))
                     (declare (optimize speed) (veq:ff x))
                     (values x)))
        :exs ((res k (acc verts))))
        (values res dim num-verts)))))


(dimtemplate (move-vert!
  "move vertex by x. use :rel nil to move to absolute position.")
  (veq:fvdef* fx (wer i (:varg dim x) &key (rel t))
    (declare #.*opt* (weir wer) (veq:pn i) (veq:ff x) (boolean rel))
    docs
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts))
      (when (>= i num-verts)
            (error "~a error. attempting to move invalid vert, ~a. ~% num verts: ~a~%"
                   'fx i num-verts))
      (veq::f@let ((res (if rel (veq::f@+ x (veq::f@$ verts i)) (values x))))
        (veq::@$vset (verts i) (values res))
        (values res)))))


(dimtemplate (transform!
  "apply function, tfx, to coordinates of verts in inds.")
  (veq:fvdef fx (wer inds tfx)
    (declare #.*opt* (weir wer) (list inds) (function tfx))
    (dimtest wer dim fx)
    docs
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts))
      (unless (every (lambda (v) (declare (optimize speed) (veq:pn v))
                       (< v num-verts)) inds)
              (error "~a error. ~% invalid vert index in: ~a. ~% num verts: ~a~%"
                     'fx inds num-verts))
      (veq:fwith-arrays (:n num-verts :itr k :inds inds
        :arr ((verts dim verts))
        :fxs ((trans ((:varg dim x))
               (declare (optimize speed) (veq:ff x))
               (funcall tfx x)))
        :exs ((verts k (trans verts))))))))


(dimtemplate (grp-transform!
  "apply function, tfx, to coordinates of verts in grp, g.")
  (defun fx (wer tfx &key g)
    (declare (weir wer) (function tfx))
    docs
    (@transform! wer (get-vert-inds wer :g g) tfx)))


(dimtemplate (split-edge!
  "split edge (u v) at x. returns new vert ind (and new edges).")
  (veq:fvdef* fx (wer u v (:varg dim x) &key g force)
  (declare #.*opt* (weir wer) (veq:pn u v) (veq:ff x) (boolean force))
  docs
  (dimtest wer dim fx)
  (if (or (del-edge! wer u v :g g) force)
      (let ((c (@add-vert! wer x)))
        (declare (veq:pn c))
        (values c (list (add-edge! wer c u :g g) (add-edge! wer c v :g g))))
      (values nil nil))))

(dimtemplate (lsplit-edge!
  "introduce edge between ll=(u v) at coordinate x.")
  (veq:fvdef* fx (wer ee (:varg dim x) &key g force)
    (declare #.*opt* (weir wer) (list ee) (veq:ff x) (boolean))
    docs
    (destructuring-bind (u v) ee
      (declare (veq:pn u v))
      (@split-edge! wer u v x :g g :force force))))

(dimtemplate (append-edge!
  "add edge between vert v and new vert at xy.")
  (veq:fvdef* fx (wer v (:varg dim x) &key (rel t) g)
    (declare (weir wer) (veq:pn v) (veq:ff x) (boolean rel))
    docs
    (dimtest wer dim fx)
    (add-edge! wer v (if rel (@add-vert! wer (veq::f@+ x (@get-vert wer v)))
                             (@add-vert! wer x))
               :g g)))


(dimtemplate (edge-length
  "returns the length of edge e=(u v). regardless of whether the edge exists.")
  (veq:fvdef fx (wer u v)
    (declare #.*opt* (weir wer) (veq:pn u v))
    docs
    (dimtest wer dim fx)
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts))
      (unless (and (< u num-verts) (< v num-verts))
              (error "~a error. invalid vert in edge (~a ~a). ~% num verts: ~a~%"
                     'fx u v num-verts))
      (veq::f@dst (veq::f@$ verts u v)))))

(dimtemplate (ledge-length
  "returns the length of edge e=(u v). regardless of whether the edge exists.")
  (defun fx (wer e)
    (declare #.*opt* (weir wer) (list e))
    docs
    (dimtest wer dim fx)
    (apply #'@edge-length wer e)))


(dimtemplate (prune-edges-by-len!
  "remove edges longer than lim, use fx #'< to remove edges shorter than lim.")
  (defun fx (wer lim &optional (pfx #'>))
    (declare #.*opt* (weir wer) (veq:ff lim) (function pfx))
    docs
    (dimtest wer dim fx)
    (itr-edges (wer e)
      (when (funcall (the function pfx) (@ledge-length wer e) lim)
            (ldel-edge! wer e)))))


(dimtemplate (add-path!
  "add edge path for these indices.")
  (defun fx (wer path &key g closed)
    (declare #.*opt* (weir wer) (veq:fvec path))
    docs
    (add-path-ind! wer (@add-verts! wer path) :g g :closed closed)))

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

(defmacro define-abbrev ()
  `(progn (weird::map-docstring '2av! "short for 2add-vert!.")
          (weird::map-docstring '2avs! "short for 2add-verts!.")
          (weird::map-docstring '2gvs "short for 2get-vert.")
          (weird::map-docstring '2gv "short for 2get-vert.")
          (weird::map-docstring '3av! "short for 3add-vert!.")
          (weird::map-docstring '3avs! "short for 3add-verts!.")
          (weird::map-docstring '3gvs "short for 3get-vert.")
          (weird::map-docstring '3gv "short for 3get-vert.")
          (weird:abbrev 2av! 2add-vert!) (weird:abbrev 2avs! 2add-verts!)
          (weird:abbrev 2gvs 2get-verts) (weird:abbrev 2gv 2get-vert)
          (weird:abbrev 3av! 3add-vert!) (weird:abbrev 3avs! 3add-verts!)
          (weird:abbrev 3gvs 3get-verts) (weird:abbrev 3gv 3get-vert)))
(define-abbrev)


(veq:fvdef center! (wer &key max-side non-edge g)
  (declare #.*opt* (weir wer))
  "center the verts of wer on xy. returns the previous center."
  (dimtest wer 2 '2center!)
  (labels ((scale-by (ms w h)
             (declare (veq:ff ms w h))
             (if (> w h) (/ ms w) (/ ms h))))
    (with-struct (weir- verts num-verts) wer
      (declare (veq:fvec verts) (veq:pn num-verts))
      (mvb (minx maxx miny maxy)
        (if non-edge (veq:f2$mima verts :n num-verts)
                     (veq:f2$mima verts :inds (get-vert-inds wer :g g)))
        (veq:f2let ((mx (veq:f2scale (veq:f2+ minx miny maxx maxy) 0.5f0))
                    (wh (veq:f2- maxx maxy minx miny)))
          (let ((s (if max-side (scale-by max-side wh) 1f0)))
            (declare (veq:ff s))
            (veq:fwith-arrays (:n num-verts :itr k
              :arr ((verts 2 verts))
              :fxs ((cent ((:varg 2 x))
                     (veq:f2+ mx (veq:f2scale (veq:f2- x mx) s))))
              :exs ((verts k (cent verts)))))
            (mvc #'values mx wh s)))))))

; TODO: port this to actual 3d
; (defun -3scale-by (ms w h d)
;   (declare #.*opt* (veq:ff ms w h))
;   (if (> w h) (/ ms w) (/ ms h)))

; (veq:fvdef center! (wer &key max-side non-edge g)
;   "center the verts of wer on xy. returns the previous center"
;   (dimtest wer 3 '3center!)
;   (with-struct (weir- verts num-verts) wer
;     (declare (veq:fvec verts) (veq:pn num-verts))
;     (mvb (minx maxx miny maxy)
;       (if non-edge (veq:f3$mima verts :n num-verts)
;                    (veq:f3$mima verts :inds (get-vert-inds wer :g g)))
;       (veq:f3let ((mx (veq:f3scale (veq:f3+ minx miny maxx maxy) 0.5f0))
;                   (wh (veq:f3- maxx maxy minx miny)))
;         (let ((s (if max-side (-3scale-by max-side wh) 1f0)))
;           (declare (veq:ff s))
;           (veq:fwith-arrays (:n num-verts :itr k
;             :arr ((verts 3 verts))
;             :fxs ((cent ((:varg 3 x))
;                    (veq:f3+ mx (veq:f3scale (veq:f3- x mx) s))))
;             :exs ((verts k (cent verts)))))
;           (mvc #'values mx wh s))))))


; SHAPES ----------------------

(veq:fvdef* 2is-intersection (wer a b c d)
  (declare (weir wer) (veq:pn aa bb))
  "check if edge ab intersect edge bc. does not check if edges exist."
  (veq:f2segx (2$verts wer a b c d)))


(defun 3add-box! (wer &key (s (math:nrep 3 100f0)) (xy (math:nrep 3 0f0)) g)
  (declare (weir wer) (list s xy))
  "add a box with size, s = (sx sy sz) at xy = (x y z)."
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
  "add edges for a cube of size, s, at xy in grp, g."
  (3add-box! wer :s (math:nrep 3 s) :xy xy :g g))

