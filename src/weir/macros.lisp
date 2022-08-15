
(in-package :weir)


(defmacro with-rnd-edge ((wer ee &key g) &body body)
  (declare (symbol wer ee))
  "select an arbitrary edge from a weir instance. the edge will be
available in the context as ee.

if a grp, g, is supplied it will select an edge from g, otherwise it will use
the main grp."
  (weird:awg (grp edges grph ln)
    `(with-grp (,wer ,grp ,g)
      (let ((,grph (grp-grph ,grp)))
        (let* ((,edges (to-vector (graph:get-edges ,grph)))
               (,ln (length ,edges)))
          (declare (veq:pn ,ln))
          (when (> ,ln 0) (let ((,ee (aref ,edges (rnd:rndi ,ln))))
                            (declare (list ,ee))
                            (progn ,@body))))))))

(defmacro with-rnd-vert ((wer v) &body body)
  (declare (symbol wer v))
  "select an arbitrary vert from a weir instance. the vert will be available in
the context as v."
  (weird:awg (num)
    `(let ((,num (weir-num-verts ,wer)))
       (when (> ,num 0) (let ((,v (rnd:rndi ,num)))
                          (declare (veq:pn ,v))
                          (progn ,@body))))))


(defmacro itr-verts ((wer v &key collect) &body body)
  (declare (symbol wer v) (boolean collect))
  "iterates over ALL verts in wer as v."
  `(loop for ,v of-type veq:pn from 0 below (weir-num-verts ,wer)
         ,(if collect 'collect 'do)
         (let ((,v ,v))
           (declare (veq:pn ,v))
           ,@body)))

(defmacro itr-grp-verts ((wer v &key g collect) &body body)
  (declare (symbol wer v) (boolean collect))
  "iterates over all verts in grp g as v.

NOTE: this will only yield vertices that belong to at least one edge that is
part of g. if you want all vertices in weir you should use itr-verts instead.
itr-verts is also faster, since it does not rely on the underlying graph
structure.

if g is not provided, the main grp wil be used."
  (weird:awg (grp res grph)
    `(with-grp (,wer ,grp ,g)
      (let (,@(when collect `((,res (list))))
            (,grph (grp-grph ,grp)))
        (graph:with-graph-verts (,grph ,v)
          ,(if collect `(push (progn ,@body) ,res)
                       `(progn ,@body)))
        ,@(when collect `(,res))))))

(defmacro itr-edges ((wer ee &key g collect verts) &body body)
  (declare (symbol wer ee) (boolean collect))
  "iterates over all edges in grp g as ee. if verts is provided it must be a
list with two symbols. these two symbols will represent the two verts in the
edge. if g is not provided, the main grp will be used."
  (when (and verts (not (and (consp verts)
                             (= (length verts) 2)
                             (every #'symbolp verts))))
    (error "~&itr-edges error: verts must be on the format (a b).
got: ~a~%" verts))
  (weird:awg (grp grph res)
    (let ((body* (if verts `(weird:dsb ,verts ,ee
                              (declare (veq:pn ,@verts) (ignorable ,@verts))
                              (progn ,@body))
                           `(progn ,@body))))
     `(with-grp (,wer ,grp ,g)
       (let (,@(when collect `((,res (list))))
             (,grph (grp-grph ,grp)))
         (graph:with-graph-edges (,grph ,ee)
           ,(if collect `(push ,body* ,res) body*))
         ,@(when collect `(,res)))))))

(defmacro itr-polys ((wer p &key g collect) &body body)
  (declare (symbol wer p) (boolean collect))
  `(loop for ,p of-type list
         being the hash-keys of (-get-polys-from ,wer :g ,g)
         ,(if collect 'collect 'do)
           (let ((,p ,p))
             (declare (list ,p))
             (progn ,@body))))

(defmacro itr-grps ((wer g &key collect main) &body body)
  (declare (symbol wer) (boolean collect))
  "iterates over all grps of wer as g."
  (weird:awg (main*)
    `(loop with ,main* = ,main
           for ,g being the hash-keys of (weir-grps ,wer)
           if (or ,main ,g)
           ,(if collect 'collect 'do)
           (let ((,g ,g)) ,@body))))

