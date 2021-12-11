
(in-package #:weird-tests)

(plan 1)

(subtest "ortho"

  (let ((proj (ortho:make :xy '(500f0 500f0)
                          :cam '(731f0 1003f0 -1000f0)
                          :look '(43f0 23f0 -10f0))))
    (is (veq:lst (ortho:project proj -33f0 100f0 -100f0))
        '(606.4451 557.0312 1481.3955))))


(unless (finalize) (error "error in ortho tests"))

