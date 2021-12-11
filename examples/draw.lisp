#!/usr/bin/sbcl --script

(load "../utils/load")


(veq:vdef main (size fn)
 (let ((wer (weir:make))
       (wsvg (wsvg:make*)))

   (weir:2add-path! wer
     (veq:f2$+ (veq:f$_ '((-1f0 -202f0) (400f0 300f0))) 50f0 700f0))
   (weir:2add-path! wer (veq:f$_ '((401f0 2f0) (4f0 300f0))))

   (weir:2add-path! wer
     (veq:f2$+ (veq:f2$square 50f0) 700f0 700f0))
   (weir:2add-path! wer
     (veq:f2$+ (veq:f2$polygon 5 100f0) 800f0 800f0)
     :closed t)

   (weir:2intersect-all! wer)

   (weir:itr-edges (wer e)
     (wsvg:path wsvg (weir:2gvs wer e) :sw 10 :so 0.2))

   (loop for path in (weir:2walk-graph wer)
         do (wsvg:path wsvg (weir:2gvs wer path)))

   (wsvg:rect wsvg 10 100 :xy '(200 200) :sw 3f0 :stroke "red")
   (wsvg:rect wsvg 30 10 :xy '(400 200) :fill "black" :fo 0.5)
   (wsvg:rect wsvg 10 30 :xy '(400 200) :fill "black" :fo 0.5 :sw 4)

   (wsvg:circ wsvg 10 :xy '(200 200))
   (wsvg:wcirc wsvg 20 :xy '(200 200))

   (weir:itr-verts (wer v)
     (wsvg:circ wsvg 3 :xy (veq:lst (weir:2gv wer v)) :fill "black"))

   (wsvg:save wsvg "draw")))


(time (main 1000 (second (weird:cmd-args))))

