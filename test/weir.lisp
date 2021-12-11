
(in-package #:weird-tests)

(plan 5)

(defun sort-a-list (a)
  (sort a #'string-lessp :key #'(lambda (x) (string (first x)))))

(defun flatten-ht (ht)
  (alexandria:flatten
    (loop for k being the hash-keys of ht using (hash-value v)
          collect (list k v))))

(veq:vprogn

  (subtest "weir"
    (let ((wer (weir:make)))

    (is (weir:2add-vert! wer 0f0 0f0) 0)
    (is (weir:2add-vert! wer 10f0 0f0) 1)
    (is (weir:2add-vert! wer 3f0 3f0) 2)
    (is (weir:2add-vert! wer 4f0 3f0) 3)
    (is (weir:2add-vert! wer 7f0 200f0) 4)
    (is (weir:2add-vert! wer 2f0 10f0) 5)
    (is (weir:2add-vert! wer 4f0 11f0) 6)
    (is (weir:2add-vert! wer 3f0 10f0) 7)
    (is (weir:2add-vert! wer  0f0 0.5f0) 8)
    (is (weir:2add-vert! wer 2f0 1.0f0) 9)
    (is (weir:2add-vert! wer 3.0f0 10f0) 10)
    (is (weir:ladd-edge! wer '(0 0)) nil)
    (is (weir:ladd-edge! wer '(0 2)) '(0 2))
    (is (weir:ladd-edge! wer '(0 1)) '(0 1))
    (is (weir:ladd-edge! wer '(5 0)) '(0 5))
    (is (weir:ladd-edge! wer '(1 0)) nil)
    (is (weir:ladd-edge! wer '(5 0)) nil)
    (is (weir:ladd-edge! wer '(0 2)) nil)
    (is (weir:add-edge! wer 5 2) '(2 5))
    (is (weir:add-edge! wer 4 1) '(1 4))
    (is (weir:ladd-edge! wer '(4 0)) '(0 4))
    (is (weir:ladd-edge! wer '(5 1)) '(1 5))
    (is (weir:ladd-edge! wer '(9 9)) nil)
    (is (weir:ladd-edge! wer '(3 9)) '(3 9))
    (is (weir:ladd-edge! wer '(0 1)) nil)
    (is (weir:ladd-edge! wer '(0 4)) nil)
    (is (weir:ladd-edge! wer '(10 9)) '(9 10))
    (is (weir:edge-exists wer '(0 2)) t)
    (is (weir:edge-exists wer '(5 0)) t)
    (is (weir:edge-exists wer '(9 2)) nil)
    (is (weir:edge-exists wer '(2 2)) nil)
    (is (veq:lst (weir:2get-vert wer 2)) '(3f0 3.0f0))
    (is (weir:2add-vert! wer 0f0 1f0) 11)
    (is (weir:ladd-edge! wer '(0 1)) nil)
    (is (weir:2add-vert! wer  0f0 7f0) 12)
    (is (weir:2ledge-length wer '(0 4)) 200.12246250733574f0)
    (is (weir:2edge-length wer 2 5) 7.0710678118654755f0)
    (is (weir:2ledge-length wer '(1 2)) 7.615773105863909f0)
    (is (veq:lst (weir:2move-vert! wer 3 1f0 3f0)) '(5f0 6f0))
    (is (veq:lst (weir:2move-vert! wer 3 0.5f0 0.6f0 :rel t)) '(5.5f0 6.6f0))
    (is (weir:2get-vert wer 3) 5.5f0 6.6f0)))

  (subtest "test-weir-2 "

  (let ((wer (weir:make)))

    (is (weir:2add-vert! wer 0f0 0f0) 0)
    (is (weir:2add-vert! wer 20f0 20f0) 1)
    (is (weir:2add-vert! wer 30f0 30f0) 2)
    (is (weir:2add-vert! wer 40f0 40f0) 3)
    (is (weir:ladd-edge! wer '(0 1)) '(0 1))
    (is (weir:ladd-edge! wer '(1 2)) '(1 2))
    (is (weir:ladd-edge! wer '(2 3)) '(2 3))
    (is (weir:ladd-edge! wer '(3 1)) '(1 3))
    (is (weir:get-edges wer) '((2 3) (1 3) (1 2) (0 1)))
    (is (weir:del-edge! wer 0 1) t)
    (is (weir:ldel-edge! wer '(0 1)) nil)
    (is (weir:ldel-edge! wer '(3 2)) t)
    (is (weir:ldel-edge! wer '(1 2)) t)
    (is (weir:2lsplit-edge! wer '(1 2) 1f0 2f0) nil)
    (is (weir:2lsplit-edge! wer '(3 1) 1f0 2f0) 4)
    (is (weir:get-num-edges wer) 2)
    (is (weir:get-num-verts wer) 5)))


  (subtest "test-weir-3 "
    (let ((wer (weir:make)))
      (is (weir:2add-vert! wer 10f0 10f0) 0)
      (is (weir:2add-vert! wer 20f0 10f0) 1)
      (is (weir:2add-vert! wer 30f0 10f0) 2)
      (is (weir:2add-vert! wer 40f0 10f0) 3)
      (is (weir:ladd-edge! wer '(0 1)) '(0 1))
      (is (weir:ladd-edge! wer '(1 2)) '(1 2))
      (is (weir:ladd-edge! wer '(2 3)) '(2 3))
      (is (weir:ladd-edge! wer '(2 3)) nil))

    (let ((wer (weir:make :max-verts 12)))
      (weir:2add-path! wer (veq:f$_ '((0f0 10f0) (1f0 20f0) (2f0 30f0) )))
      (weir:2add-path! wer (veq:f$_ '((7f0 11f0) (8f0 21f0) (9f0 31f0) )) :closed t)
      (weir:2add-path! wer (veq:f$_ '((17f0 13f0) (18f0 23f0) (19f0 33f0) )))
      (is (weir:2get-all-verts wer)
          #(0.0 10.0 1.0 20.0 2.0 30.0 7.0 11.0 8.0 21.0 9.0 31.0 17.0 13.0
            18.0 23.0 19.0 33.0)
          :test #'equalp)
      (is (weir:get-edges wer) '((7 8) (6 7) (4 5) (3 4) (3 5) (1 2) (0 1)))

      (is (loop for lp in (weir:2walk-graph wer)
                collect (weir:2gvs wer lp))
          `(#(17.0 13.0 18.0 23.0 19.0 33.0)
            #(9.0 31.0 7.0 11.0 8.0 21.0 9.0 31.0)
            #(0.0 10.0 1.0 20.0 2.0 30.0))
          :test #'equalp)))


  (defun init-weir ()
    (let ((wer (weir:make :max-verts 16)))
      (weir:2add-vert! wer 0f0 2f0) ;0
      (weir:2add-vert! wer 2f0 3f0) ;1
      (weir:2add-vert! wer 3f0 4f0) ;2
      (weir:2add-vert! wer 4f0 7f0) ;3
      (weir:2add-vert! wer 5f0 4f0) ;4
      (weir:2add-vert! wer 0f0 6f0) ;5
      (weir:2add-vert! wer -1f0 7f0) ;6
      (weir:2add-vert! wer 0f0 8f0) ;7
      (weir:2add-vert! wer 0f0 9f0) ;8
      (weir:2add-vert! wer 10f0 1f0) ;9
      (weir:2add-vert! wer 3f0 1f0) ;10

      (weir:ladd-edge! wer '(1 2))
      (weir:ladd-edge! wer '(0 1))
      (weir:ladd-edge! wer '(3 1))
      (weir:ladd-edge! wer '(5 6))
      (weir:ladd-edge! wer '(7 3))
      wer))


  (subtest "test-weir-incident "
    (let ((wer (init-weir)))
      (is (weir:get-incident-edges wer 1)
          '((1 2) (0 1) (1 3)))
      (is (weir:get-incident-edges wer 100) nil)))

  (subtest "add-verts"
    (let ((wer (init-weir)))
      (weir:2add-verts! wer (veq:f2$polygon 3 100f0)))

    (let ((wer (init-weir)))
      (weir:2add-verts! wer (veq:f2$polygon 3 100f0))
      (is (weir:2gvs wer (math:range 0 14))
          #(0.0 2.0 2.0 3.0 3.0 4.0 4.0 7.0 5.0 4.0 0.0 6.0 -1.0 7.0 0.0 8.0
            0.0 9.0 10.0 1.0 3.0 1.0 100.0 0.0 -50.000008 86.60254 -49.999992
            -86.60255)
          :test #'equalp))))

(unless (finalize) (error "error in weir tests"))

