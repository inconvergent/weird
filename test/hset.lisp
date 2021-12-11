(in-package #:weird-tests)

(plan 1)

(subtest "hset" ()

  (let ((hs (hset:make)))

    (is (hset:add hs 1) t)
    (is (hset:add hs 1) nil)
    (is (hset:add hs 20) t)
    (is (hset:add hs 40) t)
    (is (hset:add hs 73) t)
    (is (hset:num hs) 4)
    (is (hset:del hs 1) t)
    (is (hset:del hs 1) nil)
    (is (hset:mem hs 40) t)
    (is (hset:mem* hs (list 40 88)) (list t nil))
    (is (sort (hset:to-list hs) #'<) (list 20 40 73)))

  (let ((hs (hset:make :init (list 1 2 3))))
    (is (hset:to-list hs) (list 1 2 3))))

(unless (finalize) (error "error in hset tests"))
