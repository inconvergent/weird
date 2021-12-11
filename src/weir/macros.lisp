
(in-package :weir)


(defmacro with-rnd-edge ((wer i &key g) &body body)
  (declare (symbol wer))
  "
  select an arbitrary edge from a weir instance. the edge will be
  available in the context as i.

  if a grp, g, is supplied it will select an edge from g, otherwise it will use
  the main grp.
  "
  (alexandria:with-gensyms (grp edges grph ln)
    `(with-grp (,wer ,grp ,g)
      (let ((,grph (grp-grph ,grp)))
        (let* ((,edges (to-vector (graph:get-edges ,grph)))
               (,ln (length ,edges)))
          (declare (pos-int ,ln))
          (when (> ,ln 0) (let ((,i (aref ,edges (rnd:rndi ,ln))))
                            (declare (list ,i))
                            (progn ,@body))))))))


(defmacro with-rnd-vert ((wer i) &body body)
  (declare (symbol wer))
  "select an arbitrary vert from a weir instance. the vert will be available in
   the context as i."
  (alexandria:with-gensyms (num)
    `(let ((,num (weir-num-verts ,wer)))
       (when (> ,num 0) (let ((,i (rnd:rndi ,num)))
                          (declare (pos-int ,i))
                          (progn ,@body))))))


(defmacro itr-verts ((wer i &key collect) &body body)
  (declare (symbol wer) (boolean collect))
  "iterates over ALL verts in wer as i"
  (alexandria:with-gensyms (wname)
    `(let ((,wname ,wer))
      (loop for ,i of-type pos-int from 0 below (weir-num-verts ,wname)
            ,(if collect 'collect 'do)
            (let ((,i ,i)) ,@body)))))


(defmacro itr-grp-verts ((wer i &key g collect) &body body)
  (declare (symbol wer) (boolean collect))
  "
  iterates over all verts in grp g as i.

  NOTE: this will only yield vertices that belong to at least one edge that is
  part of g. if you want all vertices in weir you should use itr-verts instead.
  itr-verts is also faster, since it does not rely on the underlying graph
  structure.

  if g is not provided, the main grp wil be used.
  "
  (alexandria:with-gensyms (grp)
    `(with-grp (,wer ,grp ,g)
      (map ',(if collect 'list 'nil)
           (lambda (,i) (declare (pos-int ,i)) (progn ,@body))
           (graph:get-verts (grp-grph ,grp))))))


(defmacro itr-edges ((wer ee &key g collect verts) &body body)
  (declare (symbol wer) (boolean collect))
  "iterates over all edges in grp g as ee. if verts is provided it must be a
   list with two symbols. these two symbols will represent the two verts in the
   edge. if g is not provided, the main grp will be used."
  (when (and verts (not (and (consp verts)
                             (= (length verts) 2)
                             (every #'symbolp verts))))
    (error "itr-edges error: verts must be on the format (a b).
            got: ~a~%" verts))
  (alexandria:with-gensyms (grp grph)
    `(with-grp (,wer ,grp ,g)
       (let ((,grph (grp-grph ,grp)))
         (map ',(if collect 'list 'nil)
              (lambda (,ee) (declare (list ,ee))
                ,(if verts `(weird:dsb ,verts ,ee
                              (declare (pos-int ,@verts) (ignorable ,@verts))
                              (progn ,@body))
                            `(progn ,@body)))
              (graph:get-edges ,grph))))))


(defmacro itr-grps ((wer g &key collect main) &body body)
  (declare (symbol wer) (boolean collect))
  "iterates over all grps of wer as g"
  (alexandria:with-gensyms (grps wname main*)
    `(loop with ,wname = ,wer
           with ,main* = ,main
           with ,grps = (weir-grps ,wname)
           for ,g being the hash-keys of ,grps
           if (or ,main* ,g)
           ,(if collect 'collect 'do)
           (let ((,g ,g)) ,@body))))

