(in-package :weir)

; TODO: copy properties?
; TODO: copy grps?
(veq:vdef 3->2 (wer fx &key new)
  (declare (weir wer) (function fx))
  (weird:with-struct (weir- verts max-verts num-verts) wer
    (let* ((new (if new new (make :max-verts max-verts)))
           (new-verts (weir-verts new)))
      (declare (weir new) (veq:fvec new-verts))
      (setf (weir-num-verts new) num-verts)
      (veq:3with-rows (num-verts verts)
        (lambda (i (veq:varg 3 x))
          (declare (pos-int i) (veq:ff x))
          (veq:2vaset (new-verts i) (funcall fx x))))
      (itr-edges (wer e) (ladd-edge! new e))
      new)))

(veq:vdef* 2cut-to-area! (wer &key g (top 0f0) (left 0f0)
                                     (bottom 1000f0) (right 1000f0))
  (declare (weir wer) (veq:ff top left bottom right))
  "
  removes all edges (in g) outside envelope (ox oy), (w h).
  all edges intersecting the envelope will be deleted, a new vert will be
  inserted on the intersection. connected to the inside vert.
  edges inside the envelope will be left as they are.
  "
  (labels
    ((inside (i)
      (declare (pos-int i))
      (veq:f2let ((p (2$verts wer i)))
        (and (> (veq:vref p 0) left) (> (veq:vref p 1) top)
             (< (veq:vref p 0) right) (< (veq:vref p 1) bottom))))

     (split-line (ai bi &aux (rev nil))
       (declare (pos-int ai bi) (boolean rev))
       (unless (inside ai) (rotatef ai bi) (setf rev t)) ; swap indices
       (veq:f2let ((a (2$verts wer ai))
                   (b (2$verts wer bi))
                   (ab (veq:f2- b a)))
         (mvc #'values rev
           (veq:f2lerp a b
             (cond ((> (veq:vref b 0) right) (/ (- right (veq:vref a 0)) (veq:vref ab 0)))
                   ((> (veq:vref b 1) bottom) (/ (- bottom (veq:vref a 1)) (veq:vref ab 1)))
                   ((< (veq:vref b 0) left) (/ (- left (veq:vref a 0)) (veq:vref ab 0)))
                   (t (/ (- top (veq:vref a 1)) (veq:vref ab 1))))))))
     (cutfx (line)
       (declare (list line))
       (case (length (remove-if-not #'inside line))
         (0 (values :outside nil 0f0 0f0))
         (1 (mvc #'values :split (apply #'split-line line)))
         (t (values :keep nil 0f0 0f0)))))

  (with (wer %)
    (itr-edges (wer e :g g)
      (weir:with-gs (ae?)
        (mvb (state rev px py) (cutfx e)
          (declare (symbol state) (boolean rev) (veq:ff px py))
          (case state
            (:outside (% (ldel-edge? e :g g)))
            (:split (% (ldel-edge? e :g g))
                    (% (2append-edge?
                         (if rev (second e) (first e)) (veq:f2< px py) :rel nil :g g)
                       :res ae?)
                    (% (set-edge-prop? ae? :cut))))))))))

