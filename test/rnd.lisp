
(in-package #:weird-tests)

(plan 1)

(veq:vprogn

  (subtest "rnd" ()

    (rnd:set-rnd-state 1)

    (is (length (rnd:rndspace 10 0f0 10f0)) 10)

    (is (rnd:rndspace 10 0f0 10f0)
        '(1.8467712 7.931614 3.7252033 7.7582145 6.9112134 3.3949196 7.9353485
          8.710781 0.7763338 6.926218))

    (is (rnd:rndspace 10 0f0 10f0 :order t)
        '(0.49096227 0.5477512 0.6882775 3.7043893 4.0890446 4.5915437
          6.2654696 7.5623474 8.383889 8.869057))

    (is (rnd:rndspacei 10 0 10) '(2 4 7 7 9 1 7 0 6 9))
    (is (rnd:rndspacei 10 0 10 :order t) '(0 1 1 3 6 7 8 8 9 9))

    (is (length (rnd:nrndi 9 4)) 9)
    (is (length (rnd:nrnd 11 4f0)) 11)
    (is (length (rnd:nrnd 12 4f0)) 12)
    (is (length (rnd:nrnd* 12 4f0)) 12)

    (is (rnd:bernoulli 4 0.5f0) '(1.0 1.0 1.0 0.0))

    (is (veq:lst (rnd:2on-line 101f0 204f0 433f0 454f0)) '(241.52104 309.81403))
    (is (veq:lst (veq:f2+ 303f0 73f0 (rnd:2on-circ 303f0))) '(433.55383 -200.43134))
    (is (veq:lst (veq:f2+ 303f0 73f0 (rnd:2in-circ 303f0))) '(441.35565 -43.934296))

    (is (rnd:2non-line 5 101f0 204f0 433f0 454f0)
        #(427.40457 449.78656 157.03436 246.19455 136.4327 230.68124 144.76556
        236.95601 150.21408 241.0588)
        :test #'equalp)

    (is (veq:f2$+ (rnd:2nin-circ 5 20f0) 433f0 454f0 )
        #(433.9736 448.2122 439.11932 471.20563 434.0098 443.6098 424.3462
        457.24042 447.47418 462.05017)
        :test #'equalp)

    (is (rnd:nrnd* 10 2f0)
        '(-1.599505 0.44479895 -1.9444766 -1.3134341 1.6751962 1.6003728 -0.12388039
       1.7128291 1.6372342 0.6896429))))


(unless (finalize) (error "error in rnd tests"))
