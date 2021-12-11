(in-package #:weird-tests)

(plan 1)

(subtest "graph" ()

  (let ((grph (graph:make)))

    (is (graph:add grph 1 1) t)
    (is (graph:add grph 1 2) t)
    (is (graph:add grph 1 2) nil)
    (is (graph:add grph 2 1) nil)
    (is (graph:get-num-edges grph) 2)
    (is (graph:get-edges grph) '((1 2)))
    (is (graph:add grph 20 5) t)
    (is (graph:get-edges grph) '((5 20) (1 2)))
    (is (graph:del grph 1 2) t)
    (is (graph:del grph 1 2) nil)
    (is (graph:get-edges grph) '((5 20)))
    (is (graph:get-num-edges grph) 2)
    (is (graph:mem grph 1 4) nil)
    (is (graph:mem grph 1 1) t)
    (is (sort (graph:get-verts grph) #'<) '(1 5 20))
    (is (graph:del grph 1 1) t)
    (is (graph:get-edges grph) '((5 20)))
    (is (sort (graph:get-verts grph) #'<) '(5 20))
    (is (graph:del grph 5 20) t)
    (is (sort (graph:get-verts grph) #'<) nil))

  (is (graph:edge-set->path '((3 4) (4 5) (5 6) (1 2) (2 3)))
                                 '(1 2 3 4 5 6) )
  (is (graph:edge-set->path '((1 2))) '(1 2))
  (is (graph:edge-set->path '()) nil)
  (is (graph:edge-set->path '((3 4) (4 5))) '(3 4 5))

  (let ((grph (graph:make)))
    ; ensure that mutating one graph does not effect the other
    (graph:add grph 2 1)
    (graph:add grph 3 2)
    (graph:add grph 4 1)

    (let ((new-grph (graph:copy grph)))
      (graph:del new-grph 1 4)

      (is (length (graph:get-edges grph)) 3)
      (is (length (graph:get-edges new-grph)) 2)))

  (let ((grph (graph:make)))
    (graph:add grph 0 1)
    (graph:add grph 3 2)
    (graph:add grph 1 3)
    (graph:add grph 0 3)
    (graph:add grph 1 4)
    (graph:add grph 4 5)
    (graph:add grph 5 6)

    (is (length (graph:get-edges (graph:del-simple-filaments grph))) 3)))


(unless (finalize) (error "error in graph tests"))
