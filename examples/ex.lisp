#!/usr/local/bin/sbcl --script

(load "~/quicklisp/setup.lisp")
(ql:quickload :weird)


(veq:vdef* init-weir ()
  (let ((wer (weir:make :max-verts 1000 :name :weirinst)))
    (weir:2add-vert! wer 70f0 200f0)
    (weir:2add-vert! wer 20f0 300f0)
    (weir:2add-verts! wer (veq:f2$+ (rnd:2nin-square 20 500f0)
                                    (veq:f2rep 500f0)))
    (weir:add-edge! wer 1 2)
    (weir:ladd-edge! wer '(0 1))
    (weir:ladd-edge! wer '(3 1))
    (weir:add-edges! wer '((5 6) (7 3)))
    wer))

; example definition of custom alteration that creates two vertices, and conenct them
(weir:defalt xadd-edge? (www f2!p f2!q)
  (weir:add-edge! www (weir:2add-vert! www f2!p)
                      (weir:2add-vert! www f2!q)))


(veq:fvdef main (size fn)
  (let* ((wer (init-weir))
         (wsvg (wsvg:make*))
         (g (weir:add-grp! wer :name :rel)))

    ; silly alteration example. use :db to print alteration code.
    (print (weir:get-num-verts wer))

    ; :mode :warn wil print a warning because a? depends on v?, but v? does not
    ; exist for every a?. use :mode :t to ignore, or :mode :strict to throw an
    ; error.
    (weir:with (wer % :db t :mode :warn)
      ; this loop will create all alterations from all the 50 iterations before
      ; any of the alterations are applied. for that reason we use with-gs to
      ; create distinct names ea?, rad? v?, xedge? for each iterations. these
      ; names are used to reference the corresponding results of each
      ; alteration.
      (loop for i from 0 below 50
            do (weir:with-gs (ea? rad? v? xedge?)
                 ; with prob 0.2 add an edge using xadd-edge? the resulting
                 ; edge is named xedge?
                 (rnd:prob* 0.2 (% (xadd-edge? (veq:f3rep (rnd:rnd 1000f0))
                                              (veq:f2rep (rnd:rnd 1000f0)))
                                   :res xedge?)
                               (% (set-edge-prop? xedge? :opacity (rnd:rnd))))
                 ; with prob 0.4 add a vert named v?
                 (rnd:prob 0.4 (% (2add-vert? (veq:f2rep (rnd:rnd 1000f0))) :res v?))
                 ; with prob 0.7 add an edge (that depends on v?) named ea?, if
                 ; edge ea? is created, set the vert property of the first vert
                 ; in a?. the prop is named rad? (but is not used for anything)
                 (rnd:prob 0.7
                   (progn (% (add-edge? v? (+ i 1)) :res ea?)
                          (% (set-vert-prop? (first ea?) :rad (rnd:rnd 20f0))
                             :res rad?)))
                 (% (? (w) (list (weir:get-num-verts w) ))))))
    (pprint (weir:get-alteration-result-list wer))

  (weir:2intersect-all! wer)
  (weir:2relneigh! wer 500f0 :g :rel)
  (print wer)

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

