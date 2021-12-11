(in-package #:weird-tests)

(plan 3)

(veq:vprogn
(subtest "weir3"
  (let ((wer (weir:make :dim 3)))

(is (weir:3add-vert! wer 0f0 0f0 3f0) 0)
  (is (weir:3add-vert! wer 10f0 0f0 4f0) 1)
  (is (weir:3add-vert! wer 3f0 3f0 1f0) 2)
  (is (weir:3add-vert! wer 4f0 3f0 4f0) 3)
  (is (weir:3add-vert! wer 7f0 200f0 1f0) 4)
  (is (weir:3add-vert! wer 2f0 10f0 4f0) 5)
  (is (weir:3get-vert wer 2) 3f0 3f0 1f0)
  (is (weir:ladd-edge! wer '(0 1)) (list 0 1))
  (is (weir:3ledge-length wer '(0 1)) 10.04987562112089f0)
  (is (weir:3move-vert! wer 3 1f0 3f0 3f0) 5f0 6f0 7f0)
  (is (weir:3move-vert! wer 4 0.5f0 0.6f0 1f0 :rel t)
      7.5f0 )))


(subtest "weir 3 with"
  (let ((wer (weir:make :dim 3)))

    (weir:with (wer %)
      (% (3add-vert? (veq:f3< 11f0 3f0 9f0)))
      (list 4.5
            (% (3move-vert? 0 (veq:f3< 1f0 0f0 9f0)))
            nil t
            (list 5 (% (3add-vert? (veq:f3< 12f0 3f0 3f0)))
                    (% (3add-vert? (veq:f3< 13f0 3f0 2f0))))
            (list nil)
            (list (list))))

    (is (weir:get-num-verts wer) 3))

    (let ((wer (weir:make :dim 3)))

      (weir:with (wer %)
        (list)
        1 nil
        (% (3add-vert? (veq:f3< 12f0 3f0 2f0)))
        (% (3add-vert? (veq:f3< 13f0 6f0 3f0)))
        (% (3add-vert? (veq:f3< 13f0 3f0 3f0))))

      (weir:with (wer %)
        (% (add-edge? 1 2))
        (% (add-edge? 0 1)))

      (is (weir:edge-exists wer '(0 1)) t)
      (is (weir:3get-vert wer 2) 12f0 3f0 2f0)
      (is (weir:3get-vert wer 0) 13f0 3f0 3f0)
      (is (weir:edge-exists wer '(1 2)) t)
      (is (weir:edge-exists wer '(7 2)) nil)))


(subtest "weir 3 split"
  (let ((wer (weir:make :dim 3)))

    (weir:3add-vert! wer  0f0 3f0 6f0)
    (weir:3add-vert! wer  1f0 4f0 7f0)
    (weir:3add-vert! wer  2f0 5f0 8f0)
    (weir:add-edge! wer 0 1)
    (weir:add-edge! wer 1 2)
    (weir:add-edge! wer 2 0)

    (weir:with (wer %)
      (% (3split-edge? 0 1 (veq:f3< 30f0 20f0 3f0)) :res :a?)
      (% (3lsplit-edge? '(1 2) (veq:f3< 31f0 23f0 4f0)) :res :b?)
      (% (3lsplit-edge? '(2 1) (veq:f3< 32f0 24f0 5f0)) :res :c?))

    (is (flatten-ht (weir:get-alteration-result-map wer))
        '(:C? 3 :B? :A? 4))
    (is (veq:lst (weir:3get-vert wer 3)) '(32f0 24f0 5f0)))))

(unless (finalize) (error "error in weir 3d tests"))

