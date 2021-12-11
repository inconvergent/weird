(in-package #:weird-tests)

(plan 1)

(subtest "math" ()

  (is (math:imod 20 3 21) 2)
  (is (math:linspace 1 0f0 10f0) (list 0.0))
  (is (math:linspace 3 0f0 10f0) (list 0.0 5.0 10.0))
  (is (math:linspace 2 0f0 10f0 :end nil) (list 0.0 5.0))
  (is (math:linspace 2 0f0 10f0 :end t) (list 0.0 10.0))
  (is (math:range 2 5) (list 2 3 4))
  (is (math:range 5) (list 0 1 2 3 4)))

(unless (finalize) (error "error in math tests"))
