(in-package :weir)

(declaim (inline -2is-rel-neigh))
(veq:vdef -2is-rel-neigh (verts u v near)
  (declare #.*opt* (veq:fvec verts) (pos-int u v) (list near))
  (loop with d of-type veq:ff = (veq:f2dst (veq:f2$ verts u v))
        for w of-type pos-int in near
        if (not (> (max (veq:f2dst (veq:f2$ verts u w))
                        (veq:f2dst (veq:f2$ verts v w)))
                   d))
          summing 1 into c of-type pos-int
        ; TODO: avoid this by stripping u from near
        if (> c 1) do (return-from -2is-rel-neigh nil))
  t)

(veq:vdef 2relneigh! (wer rad &key g (build-kd t))
  (declare #.*opt* (weir wer) (veq:ff rad) (boolean build-kd))
  "
  find the relative neigborhood graph (limited by the radius rad) of verts
  in wer. the graph is made in grp g.
  "
  (dimtest wer 2 relneigh!)
  (when build-kd (build-kdtree wer))
  (let ((c 0))
    (declare (pos-int c))
    (itr-verts (wer v)
      (loop with verts of-type veq:fvec = (weir-verts wer)
            with near of-type list =
              (to-list (remove-if (lambda (x) (declare (pos-int x))
                                    (= x v))
                                  (2rad wer (2$verts wer v) rad)))
            ; TODO: strip u from near
            for u of-type pos-int in near
            if (and (< u v) (-2is-rel-neigh verts u v near))
            do (when (add-edge! wer u v :g g) (incf c))))
    c))
