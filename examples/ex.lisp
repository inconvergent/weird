#!/usr/local/bin/sbcl --script

(load "~/quicklisp/setup.lisp")
(ql:quickload :weird)


(veq:vdef* init-weir ()
  (let ((wer (weir:make :max-verts 1000)))
    (weir:2add-vert! wer 70f0 200f0)
    (weir:2add-vert! wer 20f0 300f0)
    (weir:2add-verts! wer (veq:f2$+ (rnd:2nin-square 20 500f0)
                                    (veq:f2rep 500f0)))
    (weir:add-edge! wer 1 2)
    (weir:ladd-edge! wer '(0 1))
    (weir:ladd-edge! wer '(3 1))
    (weir:add-edges! wer '((5 6) (7 3)))
    wer))


(veq:vdef main (size fn)
  (let* ((wer (init-weir))
         (wsvg (wsvg:make*))
         (g (weir:add-grp! wer :name :rel)))

    ; silly alteration example
    (weir:with (wer % :db t)
      (loop for i from 0 below 50
            do (weir:with-gs (a? b?)
                (rnd:prob 0.7
                  (progn (% (add-edge? i (+ i 1))
                            :res a?)
                         (% (set-vert-prop? (first a?)
                              :rad (rnd:rnd 20f0))
                            :res b?))))))

    (print (weir:get-alteration-result-list wer))

  (weir:2intersect-all! wer)
  (weir:2relneigh! wer 500f0 :g :rel)

  (loop for path in (weir:2walk-graph wer)
        do (wsvg:path wsvg (weir:2gvs wer path)))

  (loop for path in (weir:2walk-graph wer :g :rel)
        do (wsvg:path wsvg (weir:2gvs wer path) :sw 5f0 :so 0.2))

  (weir:itr-verts (wer v)
    (let ((rad (weird:aif (weir:get-vert-prop wer v :rad) weird:it 5f0)))
      (if (= (length (weir:get-incident-verts wer v)) 1)
        (wsvg:circ wsvg rad :xy (veq:lst (weir:2gv wer v)) :fill "black")
        (wsvg:circ wsvg rad :xy (veq:lst (weir:2gv wer v))))))

  (wsvg:save wsvg "example")))


(time (main 1000 (second (weird:cmd-args))))

