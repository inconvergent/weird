
(in-package #:weird-tests)

(plan 8)

(veq:vprogn

  (subtest "test-weir-with "
    (let ((wer (init-weir)))
      (weir:with (wer %)
        (% (2add-vert? (veq:f2 11f0 3f0)))
        (list 4.5
              (% (2move-vert? 0 (veq:f2 1f0 0f0)))
              nil t
              (list 5 (% (2add-vert? (veq:f2 12f0 3f0)))
                      (% (2add-vert? (veq:f2 13f0 3f0))))
              (list nil)
              (list (list))))

      (is (sort (weir:get-vert-inds wer) #'<)
          (list 0 1 2 3 5 6 7)))

    (let ((wer (init-weir)))

      (is (weir:edge-exists wer '(7 2)) nil)

      (weir:with (wer %)
        (list) 1 nil
        (% (2add-vert? (veq:f2 12f0 3f0)))
        (% (2add-vert? (veq:f2 13f0 6f0))) ; 11
        (% (add-edge? 1 2))
        (% (add-edge? 2 7)))

      (is (veq:lst (weir:2get-vert wer 12)) '(12f0 3f0))
      (is (veq:lst (weir:2get-vert wer 11)) '(13f0 6f0))

      (is (weir:edge-exists wer '(1 2)) t)
      (is (weir:edge-exists wer '(2 7)) t)
      (is (weir:edge-exists wer '(7 2)) t))

    (let ((wer (weir:make)))
      (weir:with (wer %)
        (% (2add-vert? (veq:f2 1f0 2f0) ) :res :a?)
        (% (2add-vert? (veq:f2 2f0 2f0 )) :res :b?)
        (% (add-edge? :a? :b?) :res :e1?)
        (% (2append-edge? (first :e1?) (veq:f2 4f0 3f0)) :res :e2?))

      ; TODO: there is a bug vprogn/vdef. it does not handle dotted pairs
      (is (flatten-ht (weir:get-alteration-result-map wer))
          ; '((:A . 1) (:B . 0) (:E1 0 1) (:E2 . 0 2))
          '(:B? 0 :A? 1 :E1? 0 1 :E2? 0 2)))


    (let ((wer (weir:make)))
      (veq:f2let ((v (veq:f2 1f0 2f0)))
        (weir:with (wer %)
          (% (2add-vert? (veq:f2 1f0 2f0)) :res :a?)
          (veq:f2let ((ww (veq:f2 v)))
            (% (? (x) (list ww :a?)) :res :l?)
            (% (? (x) (veq:lst (veq:f2- ww 1f0 2f0))) :res :l2?))
          (veq:f2vset v (veq:f2 2f0 2f0))))

      (is (gethash :l? (weir:get-alteration-result-map wer)) `(1.0f0 2.0f0 0))
      (is (gethash :l2? (weir:get-alteration-result-map wer)) '(0f0 0f0))
      (weir:with (wer %) (% (2move-vert? 0 (veq:f2 4f0 7f0)) :res :a?))
      (is (gethash :a? (weir:get-alteration-result-map wer)) 0))

    (let ((wer (init-weir)))
      (weir:with (wer %)
        (loop for i from 3 below 7
              do (weir:with-gs (a? b?)
                   (% (add-edge? i (+ i 1)) :res a?)
                   (% (ldel-edge? a?) :res b?)))

        (is (weir:get-alteration-result-list wer) nil))
      (let ((res (mapcar #'cdr (weir:get-alteration-result-list wer))))
        (is res '((6 7) NIL (4 5) (3 4) T NIL T T)))))

  (defun make-sfx-weir ()
    (let ((wer (weir:make)))
      (weir:2add-vert! wer (veq:f2 1f0 1f0))
      (weir:2add-vert! wer (veq:f2 2f0 2f0))
      (weir:2add-vert! wer (veq:f2 3f0 3f0))
      wer))


  (defun isub (wer a b)
    (veq:f2- (weir:2get-vert wer b) (weir:2get-vert wer a)))

  (subtest "test-weir-with-sfx "
    ; these two cases demonstrate the "side-effect" of alterting the
    ; graph sequentially while relying on the state of the graph
    (let ((wer (make-sfx-weir)))
      ; this exhibits "side-effects"
      (weir:2move-vert! wer 0 (isub wer 1 0))
      (weir:2move-vert! wer 1 (isub wer 2 0))
      (is (weir:2get-all-verts wer)
          #(0.0 0.0 -1.0 -1.0 3.0 3.0)
          :test #'equalp))

    (let ((wer (make-sfx-weir)))
      ; this exhibits "side-effects"
      (weir:2move-vert! wer 1 (isub wer 2 0))
      (weir:2move-vert! wer 0 (isub wer 1 0))
      (is (weir:2get-all-verts wer)
          #(2.0 2.0 0.0 0.0 3.0 3.0) ; 203
          :test #'equalp))

    ; these three cases demonstrate the expected behavoir of an alteration.
    ; no "side effect" in the sense described above.
    (let ((wer (make-sfx-weir)))
      (weir:with (wer %)
        ; alterations avoid side-effects
        (% (2move-vert? 1 (isub wer 2 0)))
        (% (2move-vert? 0 (isub wer 1 0))))
      (is (weir:2get-all-verts wer)
          #(0.0 0.0 0.0 0.0 3.0 3.0)  ; 003
          :test #'equalp))

    (let ((wer (make-sfx-weir)))
      (weir:with (wer %)
        ; alterations avoid side-effects
        (% (2move-vert? 0 (isub wer 1 0)))
        (% (2move-vert? 1 (isub wer 2 0))))
      (is (weir:2get-all-verts wer)
          #(0.0 0.0 0.0 0.0 3.0 3.0)  ; 003
          :test #'equalp))

    (let ((wer (make-sfx-weir)))
      (weir:with (wer %)
        (veq:f2let ((va (isub wer 2 0))
                    (vb (isub wer 1 0)))
          (% (? (w) (weir:2move-vert! w 1 va)))
          (% (? (w) (weir:2move-vert! w 0 vb)))))
      (is (weir:2get-all-verts wer)
          #(0.0 0.0 0.0 0.0 3.0 3.0)  ; 003
          :test #'equalp)))


  (subtest "test-weir-add "
    (let ((wer (init-weir)))
      (weir:with (wer %)
        (% (2add-vert? (veq:f2 10f0 3f0))))

      (is (veq:lst (weir:2get-vert wer 11)) `( 10f0 3f0))

      (is (weir:get-num-verts wer) 12)

      (weir:with (wer %)
         (% (2add-vert? (veq:f2 80f0 3f0)) :res :a?)
         (% (2add-vert? (veq:f2 70f0 3f0)) :res :b?))
      (is (flatten-ht (weir:get-alteration-result-map wer))
          `(:b? 12 :a? 13 ))

      (is (weir:get-num-verts wer) 14)

      (weir:with (wer %)
        (% (2vadd-edge? (veq:f2 7f0 3f0) (veq:f2 100f0 0.99f0))))

      (is (weir:get-edges wer)
               '((14 15) (5 6) (3 7) (0 1) (1 3) (1 2)))))

  (subtest "test-weir-move "
    (let ((wer (init-weir)))
      (weir:with (wer %)
        (% (2move-vert? 0 (veq:f2 3f0 3f0)) :res :a?)
        (% (2move-vert? 1 (veq:f2 1f0 3f0)) :res :b?)
        (% (2move-vert? 3 (veq:f2 2f0 3f0) :rel nil) :res :c?)
        (% (2move-vert? 2 (veq:f2 3f0 4f0)) :res :d?))
      (is (weir:2get-all-verts wer)
          #(3.0 5.0 3.0 6.0 6.0 8.0 2.0 3.0 5.0 4.0 0.0 6.0 -1.0 7.0 0.0 8.0 0.0
            9.0 10.0 1.0 3.0 1.0)
          :test #'equalp)

      (is (veq:lst (weir:2get-vert wer 0)) '(3f0 5f0))
      (is (veq:lst (weir:2get-vert wer 1)) '(3f0 6f0))
      (is (veq:lst (weir:2get-vert wer 3)) '(2f0 3f0))
      (is (veq:lst (weir:2get-vert wer 2)) '(6f0 8f0))))

  (subtest "test-weir-join "
    (let ((wer (init-weir)))
      (weir:with (wer %)
        (% (add-edge? 3 3))
        (% (add-edge? 3 3))
        (% (add-edge? 3 6))
        (% (add-edge? 7 1)))

    (is (weir:get-num-edges wer) 7)
    (weir:with (wer %)
      (% (add-edge? 3 3) :res :a?)
      (% (add-edge? 1 6) :res :b?)
      (% (add-edge? 1 100) :res :c?))
    (is (flatten-ht (weir:get-alteration-result-map wer))
        '(:C? :B? 1 6 :A?))))


  (subtest "test-weir-append "
    (let ((wer (init-weir)))

      (is (weir:get-num-verts wer) 11)

      (weir:with (wer %)
        (% (2append-edge? 3 (veq:f2 3f0 4f0)) :res :a?)
        (% (2append-edge? 3 (veq:f2 8f0 5f0) :rel nil) :res :b?)
        (% (2append-edge? 7 (veq:f2 1f0 2f0)) :res :c?))

      (is (flatten-ht (weir:get-alteration-result-map wer))
          '(:C? 7 11 :B? 3 12 :A? 3 13))
      (is (weir:get-num-edges wer) 8)
      (is (weir:get-num-verts wer) 14)
      (is (weir:2get-all-verts wer)
          #(0.0f0 2.0f0 2.0f0 3.0f0 3.0f0 4.0f0 4.0f0 7.0f0 5.0f0 4.0f0 0.0f0
            6.0f0 -1.0f0 7.0f0 0.0f0 8.0f0 0.0f0 9.0f0 10.0f0 1.0f0 3.0f0 1.0f0
            1.0f0 10.0f0 8.0f0 5.0f0 7.0f0 11.0f0)
          :test #'equalp)))


  (subtest "test-weir-split "
    (let ((wer (init-weir)))
      (weir:with (wer %)
        (% (2split-edge? 1 2 (veq:f2 30f0 20f0)) :res :a?)
        (% (2lsplit-edge? '(1 2) (veq:f2 31f0 23f0)) :res :b?)
        (% (2lsplit-edge? '(5 6) (veq:f2 32f0 24f0)) :res :c?))
      (is (flatten-ht (weir:get-alteration-result-map wer))
          '(:C? 11 :B? 12 :A?))

    (is (weir:get-num-edges wer) 7)

    (is (weir:get-num-verts wer) 13)

    (is (weir:2get-all-verts wer)
        #(0.0 2.0 2.0 3.0 3.0 4.0 4.0 7.0 5.0 4.0 0.0 6.0 -1.0 7.0 0.0 8.0 0.0
          9.0 10.0 1.0 3.0 1.0 32.0 24.0 31.0 23.0)
        :test #'equalp)))


  (subtest "test-weir-itrs "

    (rnd:set-rnd-state 1)

    (let ((wer (init-weir)))
      (weir:with (wer %)
        (weir:with-rnd-vert (wer v)
          (% (2move-vert? v (veq:f2 2f0 2f0)))
          (% (2append-edge? v (veq:f2 3f0 2f0)))))

      (is (weir:get-num-edges wer) 6)

      (is (weir:get-num-verts wer) 12)

      (weir:with (wer %)
        (weir:itr-verts (wer v)
          (% (2move-vert? v (veq:f2 2f0 2f0)))))

      (is (sort (weir:itr-verts (wer i :collect t) i) #'<)
          '(0 1 2 3 4 5 6 7 8 9 10 11))

      (is (weir:itr-verts (wer i) i) nil)

      (is (sort (weir:itr-grp-verts (wer i :collect t) i) #'<)
          '(0 1 2 3 5 6 7 11))

      (is (weir:itr-edges (wer e :collect t) e)
          '((5 11) (5 6) (3 7) (0 1) (1 3) (1 2)))

      (is
        (sort (weir:itr-edges (wer e :collect t)
                (weir:2ledge-length wer e)) #'<)
        '(1.0 1.4142135 2.236068 3.1622777 4.1231055 4.472136))

      (weir:with (wer %)
        (weir:with-rnd-edge (wer e)
          (% (2lsplit-edge? e (veq:f2 31f0 23f0)))))

      (is (weir:get-num-edges wer) 7)
      (is (weir:get-num-verts wer) 13))))

(unless (finalize) (error "error in weir-with tests"))

