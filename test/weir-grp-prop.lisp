
(in-package #:weird-tests)
(plan 2)

(subtest "test-weir-grp "
  (let ((wer (weir:make :max-verts 22 :adj-size 30)))

    (let ((g1 (weir:add-grp! wer))
          (g2 (weir:add-grp! wer))
          (g3 (weir:add-grp! wer)))
      (weir:2add-vert! wer 100f0 200f0)
      (weir:2add-vert! wer 200f0 300f0)
      (weir:2add-vert! wer 300f0 400f0)
      (weir:2add-vert! wer 400f0 500f0)
      (weir:2add-vert! wer 600f0 700f0)
      (weir:2add-vert! wer 700f0 800f0)
      (weir:2add-vert! wer 800f0 900f0)
      (weir:2add-vert! wer 500f0 600f0)
      (weir:2add-vert! wer 900f0 600f0)

      (weir:ladd-edge! wer '(1 2) :g g1)
      (weir:ladd-edge! wer '(1 2))
      (weir:ladd-edge! wer '(1 2) :g g2)
      (weir:ladd-edge! wer '(3 2) :g g2)
      (weir:ladd-edge! wer '(1 5) :g g3)

      (is (sort (weir:itr-grp-verts (wer i :g g2 :collect t) i) #'<)
               '(1 2 3))

      (is (sort (weir:itr-grp-verts (wer i :g nil :collect t) i) #'<)
               '(1 2))

      (is (sort (alexandria:flatten
                       (weir:itr-edges (wer e :g g1 :collect t) e)) #'<)
               '(1 2))

      (is (sort (weir:get-vert-inds wer :g g1) #'<) '(1 2))

      (is (sort (weir:get-vert-inds wer :g g3) #'<) '(1 5))

      (is (length (weir:get-vert-inds wer)) 2)

      (is (length (weir:itr-grps (wer g :collect t) g)) 3))))

; (defun "test-weir-loop "
;   (let ((wer (weir:make)))
;     (weir:add-path! wer (list (vec:vec 0f0 0f0) (vec:vec 10f0 0f0)
;                               (vec:vec 10f0 10f0) (vec:vec 0f0 10f0))
;                     :closed t)

;     (is (weir:get-west-most-vert wer) 0)

;     (weir:add-path! wer (list (vec:vec -10f0 -1f0) (vec:vec 10f0 10f0)))

;     (is (weir:get-west-most-vert wer) 4))

;   (let ((wer (weir:make)))
;     (weir:2add-verts! wer (list (vec:vec 0f0 0f0) (vec:vec 1f0 0f0)
;                                (vec:vec 1f0 -1f0) (vec:vec 1f0 1f0)))

;     (weir:add-edge! wer 0 1)
;     (weir:add-edge! wer 0 2)
;     (weir:add-edge! wer 0 3)

;     (is (weir:get-incident-rotated-vert wer 0 :dir :cw) 2)
;     (is (weir:get-incident-rotated-vert wer 0 :dir :ccw) 3))

;   (let ((wer (weir:make)))
;     (weir:2add-verts! wer (bzspl:adaptive-pos
;                            (bzspl:make (rnd:nin-circ 10 100f0))
;                            :lim 1f0))

;     (is (weir:get-num-verts wer) 95)

;     (is (weir:get-num-edges wer) 0)

;     (weir:relative-neighborhood! wer 500f0)

;     (is (weir:get-num-edges wer) 105)

;     (weir:add-path! wer (vec:polygon 4 20f0))

;     (weir:add-path! wer (vec:polygon 4 20f0) :closed t)

;     (is (weir:get-planar-cycles wer)
;              `((56 43 44 45 46 47 48 49 50 51 52 53 54 55 56) (60 87 86 85 60)
;                (18 89 62 61 88 87 60 84 16 83 17 18)
;                (11 12 13 14 15 16 84 60 85 59 58 57 42 41 40 39 11) (91 66 65 64 90 20 21 91)
;                (80 92 69 68 67 91 21 22 23 24 80) (101 102 99 100 101)
;                (25 24 23 22 21 20 90 19 89 18 17 83 16 15 14 13 12 11 10 9 8 7 6 5 4 3 25)
;                (1 80 24 25 2 1) (0 71 70 92 80 1 79 0)
;                (30 29 28 27 26 2 25 3 4 5 6 37 36 35 34 33 32 31 30)
;                (75 74 73 72 0 78 77 76 75)))

;     (is (weir:get-segments wer :cycle-info nil)
;              '((0 71) (0 72) (0 78 77 76 75 74 73 72) (0 79 1) (1 2) (1 80)
;               (2 25) (2 26 27 28 29 30 31 32 33 34 35 36 37 6) (6 5 4 3 25)
;               (6 7 8 9 10) (10 11) (10 38) (11 12 13 14 15 16) (11 39 40 41 42)
;               (16 83 17 18 89) (16 84 60) (20 21) (20 82) (20 90) (21 22) (21 91)
;               (22 23 24) (22 81) (24 25) (24 80) (42 56) (42 57 58 59 85)
;               (56 43 44 45 46 47 48 49 50 51 52 53 54 55 56) (60 85) (60 87)
;               (63 89) (71 70 92) (71 93) (72 94) (80 92) (85 86 87) (87 88 61 62 89)
;               (89 19 90) (90 64 65 66 91) (91 67 68 69 92)
;               (95 96 97 98) (99 102 101 100 99)))))

(subtest "test-weir-prop "
  (let ((wer (weir:make)))
    (weir:2add-path! wer (rnd:2nin-circ 5 400f0))
    (setf (weir:get-vert-prop wer 1 :a) 2)
    (setf (weir:get-vert-prop wer 1 :a) 4)
    (setf (weir:get-vert-prop wer 1 :b) 3)
    (setf (weir:get-edge-prop wer '(1 2) :b) 2888)
    (setf (weir:get-edge-prop wer '(0 1) :b) 2887)
    (setf (weir:get-edge-prop wer '(2 3) :a) 2888)
    (setf (weir:get-edge-prop wer '(3 4) :b) 2888)

    (is (weir:get-edge-prop wer '(0 1) :b) 2887)
    (is (weir:get-edge-prop wer '(1 2) :b) 2888)
    (is (weir:get-edge-prop wer '(1 3) :b) nil)
    (is (weir:get-vert-prop wer 1 :b) 3)
    (is (weir:vert-has-prop wer 1 :b :val 3) t)
    (is (weir:get-edges-with-prop wer :b :val 2888) '((3 4) (1 2)))

    (is (weir:get-edge-props wer '(1 2)) '((:B . 2888)))
    (weir:copy-edge-props wer '(2 3) '(1 2))
    (is (weir:get-edge-props wer '(1 2)) '((:A . 2888) (:B . 2888)))

    (is (weir:get-vert-props wer 2) nil)
    (weir:copy-vert-props wer 1 2)
    (is (weir:get-vert-props wer 2) '((:B . 3) (:A . 4) (:A . 2))))

  (let ((wer (weir:make)))
    (weir:mset-edge-prop wer
      (weir:2add-path! wer
        (veq:f$_ '((1f0 2f0) (2f0 3f0) (4f0 5f0))) :closed t)
      :path)

    (is (veq:lst (weir:edge-prop->path wer :path)) '((2 0 1) T))

    (veq:vprogn
      (weir:with (wer %)
        (% (2split-edge? 0 1 (veq:f2 1f0 2f0)) :res :a?)
        (% (mcopy-edge-props? '(0 1) (list (list 0 :a?) (list 1 :a?)))))

      (is (veq:lst (weir:edge-prop->path wer :path)) '((2 0 3 1) T)))))

(unless (finalize) (error "error in weir-grp-prop tests"))

