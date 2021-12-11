
(in-package :wsvg)

(setf cl-svg:*indent-spacing* 0)

(declaim (veq:ff *short* *long* *half-long* *half-short*))
(defparameter *long* 1414.285f0)
(defparameter *short* 1000f0)
(defparameter *half-long* #.(* 0.5f0 1414.285f0))
(defparameter *half-short* #.(* 0.5f0 1000f0))
(defparameter *zero* (list 0 0))
(defparameter *svg* 'cl-svg:svg-1.1-toplevel)


; TODO: better line join configurability
; https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linejoin


(defparameter *layouts*
  `((:a4-landscape . (,*long* ,*short*)) (:a4-portrait . (,*short* ,*long*))
    (:a3-landscape . (,*long* ,*short*)) (:a3-portrait . (,*short* ,*long*))
    (:a2-landscape . (,*long* ,*short*)) (:a2-portrait . (,*short* ,*long*))))


(declaim (inline -filter-nils))
(defun -filter-nils (l*)
  (declare (list l*))
  (let* ((l (weird:to-vector l*))
         (n (length l)))
    (declare (array l) (fixnum n))
    (loop with res of-type list = (list)
          for i of-type fixnum from 0 below n by 2
          if (aref l (1+ i))
          do (push (aref l i) res)
             (push (aref l (1+ i)) res)
          finally (return (reverse res)))))

; this is a rewrite of macro draw from
; https://github.com/wmannis/cl-svg/blob/master/svg.lisp#L269
; that filters out nil elements in parms/opts
(defmacro draw% (scene (shape &rest params) &rest opts)
  (let ((element (gensym)))
    `(let ((,element
             (funcall #'cl-svg::make-svg-element
                      ,shape (-filter-nils (append (list ,@params)
                                                   (list ,@opts))))))
       (cl-svg::add-element ,scene ,element)
       ,element)))

; (defun -hex (c) (if (equal (type-of c) 'pigment:rgba) (pigment:to-hex c) c))
(defun -hex (c) c)
(defun -vb (w h) (format nil "0 0 ~,3f ~,3f" w h))
(defun -select-arg (l) (find-if #'identity l))
(defun -select-fill (f) (if f f "none"))


(defstruct wsvg
  (layout nil :type symbol :read-only t)
  (width 0f0 :type veq:ff :read-only t)
  (height 0f0 :type veq:ff :read-only t)
  (stroke "black" :type string :read-only nil)
  (stroke-width 1.1f0 :type veq:ff :read-only nil)
  (stroke-opacity nil :read-only nil)
  (fill-opacity nil :read-only nil)
  (rep-scale 1f0 :type veq:ff :read-only nil)
  (line-join "bevel" :type string :read-only nil)
  (scene nil :read-only nil))

(defun -select-so (wsvg so) (if so so (wsvg-stroke-opacity wsvg)))
(defun -select-fo (wsvg fo) (if fo fo (wsvg-fill-opacity wsvg)))
(defun -select-sw (wsvg sw) (if sw sw (wsvg-stroke-width wsvg)))
(defun -select-stroke (wsvg s) (if s s (wsvg-stroke wsvg)))
(defun -select-rep-scale (wsvg rs) (if rs rs (wsvg-rep-scale wsvg)))
(defun -select-line-join (wsvg lj) (if lj lj (wsvg-line-join wsvg)))

(defun -get-scene (layout)
  (case layout
    (:a4-landscape (cl-svg:make-svg-toplevel *svg* :height "210mm" :width "297mm"
                     :view-box (-vb *long* *short*)))
    (:a4-portrait (cl-svg:make-svg-toplevel *svg* :height "297mm" :width "210mm"
                     :view-box (-vb *short* *long*)))
    (:a3-landscape (cl-svg:make-svg-toplevel *svg* :height "297mm" :width "420mm"
                     :view-box (-vb *long* *short*)))
    (:a3-portrait (cl-svg:make-svg-toplevel *svg* :height "420mm" :width "297mm"
                     :view-box (-vb *short* *long*)))
    (:a2-landscape (cl-svg:make-svg-toplevel *svg* :height "420mm" :width "594mm"
                     :view-box (-vb *long* *short*)))
    (:a2-portrait (cl-svg:make-svg-toplevel *svg* :height "594mm" :width "420mm"
                     :view-box (-vb *short* *long*)))
    (otherwise (error "invalid layout. use: :a4-portrait, :a4-landscape,
:a3-landscape, :a3-portrait, a2-landscape or a2-portrait; or use
(make* :height h :width w)"))))


(defun update (wsvg &key stroke sw rs fo so)
  (declare (wsvg wsvg))
  (when stroke (setf (wsvg-stroke wsvg) (the string stroke)))
  (when sw (setf (wsvg-stroke-width wsvg) (the veq:ff sw)))
  (when rs (setf (wsvg-rep-scale wsvg) (the veq:ff rs)))
  (when fo (setf (wsvg-fill-opacity wsvg) (the veq:ff fo)))
  (when so (setf (wsvg-stroke-opacity wsvg) (the veq:ff so))))


(defun make (&key (layout :a4-landscape) stroke stroke-width rep-scale
                  fill-opacity stroke-opacity so rs fo sw)
  (destructuring-bind (width height) (cdr (assoc layout *layouts*))
    (make-wsvg :layout layout
                   :height height :width width
                   :stroke (-hex (if stroke stroke "black"))
                   :fill-opacity (-select-arg (list fill-opacity fo))
                   :rep-scale (-select-arg (list rep-scale rs 0.5f0))
                   :stroke-opacity (-select-arg (list stroke-opacity so))
                   :stroke-width (-select-arg (list stroke-width sw 1.1f0))
                   :scene (-get-scene layout))))


(defun make* (&key (height 1000f0) (width 1000f0) stroke stroke-width
                   rep-scale fill-opacity stroke-opacity so rs fo sw)
  (make-wsvg :layout :custom
                 :height height :width width
                 :stroke (-hex (if stroke stroke "black"))
                 :fill-opacity (-select-arg (list fill-opacity fo))
                 :rep-scale (-select-arg (list rep-scale rs 0.5f0))
                 :stroke-opacity (-select-arg (list stroke-opacity so))
                 :stroke-width (-select-arg (list stroke-width sw 1.1f0))
                 :scene (cl-svg:make-svg-toplevel *svg*
                          :height height :width width)))

(defun -move-to (p)
  (declare (list p))
  (cl-svg:move-to (first p) (second p)))

; (defun -line-to (p)
;   (declare (vec:vec p))
;   (cl-svg:line-to (first p) (second p)))

(veq:vdef -mid (a b)
  (dsb (ax ay) a
    (dsb (bx by) b
      (list (veq:fmid ax bx) (veq:fmid ay by)))))


; (defun -arccirc (xy r &aux (r2 (* 2f0 r)))
;   (format nil "M~,3f,~,3f~%m-~,3f,0~%a~,3f,~,3f 0 1,0 ~,3f 0
; a~,3f,~,3f 0 1,0 -~,3f 0Z" (vec:vec-x xy) (vec:vec-y xy) r r r r2 r r r2))

;https://stackoverflow.com/questions/5736398/how-to-calculate-the-svg-path-for-an-arc-of-a-circle
; (defun -carc (xy rad a b)
;   (let ((axy (vec:from xy (vec:cos-negsin a) rad))
;         (bxy (vec:from xy (vec:cos-negsin b) rad))
;         (arcflag (if (< (- b a) veq:fpi) 0 1)))
;    (format nil "M~,3f,~,3f A~,3f,~,3f 0 ~,3d,0 ~,3f ~,3f"
;      (vec:vec-x axy) (vec:vec-y axy) rad rad arcflag
;      (vec:vec-x bxy) (vec:vec-y bxy))))


(defun -accumulate-path (pth a)
  (labels ((-lt (x y) (cl-svg:line-to x y))
           (-mt (x y) (cl-svg:move-to x y)))
    (cl-svg:with-path pth
      (apply (if (> (length pth) 0) #'-lt #'-mt) a))))


; TODO: handle more cases
(defun compound (wsvg components &key sw fill stroke fo so)
  (declare (wsvg wsvg) (sequence components))
  (draw% (wsvg-scene wsvg)
    (:path
      :d (loop with pth = (cl-svg:make-path)
               for (ct c) in components
               do (case ct (:path (loop for p in c
                                        do (-accumulate-path pth p)))
                           (:bzspl (list)))
               finally (return pth)))
    :fill (-select-fill fill)
    :fill-opacity (-select-fo wsvg fo)
    :stroke (-select-stroke wsvg stroke)
    :stroke-opacity (-select-so wsvg so)
    :stroke-width (-select-sw wsvg sw)))

(defun ensure-list (pts)
  (typecase pts (list pts)
                (veq:fvec (veq:2to-list pts))
                (t (error "incorrect path: ~a~%" pts))))


(defun path (wsvg pts* &key sw fill stroke so fo closed lj
                       &aux (pts (ensure-list pts*)))
  (declare (wsvg wsvg))
  (draw% (wsvg-scene wsvg)
    (:path :d (loop with pth = (cl-svg:make-path)
                    for p of-type list in pts
                    do (-accumulate-path pth p)
                    finally (when closed (cl-svg:with-path pth "Z"))
                            (return pth)))
    :fill (-select-fill fill)
    :fill-opacity (-select-fo wsvg fo)
    :stroke (-select-stroke wsvg stroke)
    :stroke-opacity (-select-so wsvg so)
    :stroke-width (-select-sw wsvg sw)
    :stroke-linejoin (-select-line-join wsvg lj)))


; (defun -get-pts (pts closed)
;   (declare (sequence pts))
;   (let ((res (make-adjustable-vector))
;         (is-cons (consp pts)))
;     (declare (vector res))
;     (if is-cons (loop for p of-type vec:vec in pts do (vextend p res))
;                 (loop for p of-type vec:vec across pts do (vextend p res)))
;     (when closed (vextend (if is-cons (first pts) (aref pts 0)) res))
;     res))


; (defun hatch (wsvg pts &key (angles (list 0f0 (* 0.5f0 veq:fpi)))
;                             stitch drop closed rs sw so stroke
;                        &aux (stroke* (-select-stroke wsvg stroke)))
;   (labels ((-dropfx (p) (rnd:prob drop nil
;                           (wsvg:path wsvg p :sw sw :so
;                             (-select-so wsvg so) :stroke stroke*)))
;            (-drawfx (p) (wsvg:path wsvg p :sw sw :so
;                           (-select-so wsvg so) :stroke stroke*)))

;     (loop with fx = (if drop #'-dropfx #'-drawfx)
;           with res = (hatch:hatch (-get-pts pts closed)
;                        :angles angles :rs (-select-rep-scale wsvg rs))
;           for h across (if stitch (hatch:stitch res) res)
;           do (if (and (> (length h) 0) (every #'identity h))
;                  (funcall fx h)))))

(defun -quadratic (p q)
  (declare (list p q))
  (format nil "Q~,3f,~,3f ~,3f,~,3f" (first p) (second p)
                                      (first q) (second q)))

(defun -bzspl-do-open (pts pth)
  (cl-svg:with-path pth (-move-to (first pts)))
  (if (= (length pts) 3)
      ; 3 pts
      (cl-svg:with-path pth (-quadratic (second pts) (third pts)))
      ; more than 3 pts
      (let ((inner (subseq pts 1 (1- (length pts)))))
        (loop for a in inner and b in (cdr inner)
              do (cl-svg:with-path pth (-quadratic a (-mid a b))))
        (cl-svg:with-path pth
          (-quadratic (math:last* inner) (math:last* pts))))))


(defun -roll-once (a)
  (declare (list a))
  (append (subseq a 1) (list (first a))))

(defun -bzspl-do-closed (pts pth)
  (cl-svg:with-path pth (-move-to (-mid (math:last* pts) (first pts))))
  (loop for a in pts
        and b in (-roll-once pts)
        do (cl-svg:with-path pth (-quadratic a (-mid a b)))))


(defun bzspl (wsvg pts* &key closed sw stroke fill so fo
                        &aux (pts (ensure-list pts*)))
  (declare (wsvg wsvg))
  "quadratic bezier"
  (when (< (length pts) 3) (error "needs at least 3 pts."))
  (with-struct (wsvg- scene) wsvg
    (let ((pth (cl-svg:make-path)))
      (if closed (-bzspl-do-closed pts pth)
                 (-bzspl-do-open pts pth))
      (draw% scene (:path :d (cl-svg:path pth))
                   :fill (-select-fill fill)
                   :fill-opacity (-select-fo wsvg fo)
                   :stroke (-select-stroke wsvg stroke)
                   :stroke-opacity (-select-so wsvg so)
                   :stroke-width (-select-sw wsvg sw)))))


(defun jpath (wsvg pts &key (width 1f0) closed stroke sw so rs ns
                            (limits jpath::*limits*))
  (declare (wsvg wsvg) (sequence pts))
  (when (and ns rs) (error "jpath error: either rs or ns must be nil"))
  (let ((rep (if ns ns (ceiling (* (-select-rep-scale wsvg rs) (veq:ff width))))))
    (when (< rep 2) (return-from jpath (path wsvg pts :stroke stroke
                                             :sw sw :so so :closed closed)))
    (let ((jp (jpath:jpath pts (veq:ff width) :rep rep :closed closed :limits limits)))
      (if closed (loop for path in jp
                       do (path wsvg path :closed t :stroke stroke
                                :sw sw :so so))
                 (path wsvg jp :stroke stroke :sw sw :so so)))))


; (defun carc (wsvg xy rad a b &key fill sw stroke so)
;   (declare (wsvg wsvg) (vec:vec xy) (veq:ff rad a b))
;   "arc between angles (a b) centered at xy. rotation is ccw"
;   (with-struct (wsvg- scene) wsvg
;     (draw% scene (:path :d (-carc xy rad a b))
;            :fill (-select-fill fill)
;            :stroke (-select-stroke wsvg stroke)
;            :stroke-width (-select-sw wsvg sw)
;            :stroke-opacity (-select-so wsvg so))))


(defun rect (wsvg w h &key (xy *zero*) fill sw stroke so fo)
  (declare (wsvg wsvg) (list xy) (number w h))
  (dsb (x y) xy
    (draw% (wsvg-scene wsvg)
           (:rect :x (- x w) :y (- y h)
                  :height (* 2 h) :width (* 2 w))
           :fill (-select-fill fill)
           :fill-opacity (-select-fo wsvg fo)
           :stroke (-select-stroke wsvg stroke)
           :stroke-width (-select-sw wsvg sw)
           :stroke-opacity (-select-so wsvg so))))

(defun square (wsvg s &key (xy *zero*) fill sw stroke so fo)
  (declare (wsvg wsvg) (veq:ff s))
  (rect wsvg s s :fill fill :xy xy :fo fo :so so :sw sw :stroke stroke))


(defun circ (wsvg rad &key (xy *zero*) fill sw stroke so fo)
  (declare (wsvg wsvg) (list xy) (number rad))
  (dsb (x y) xy
    (draw% (wsvg-scene wsvg) (:circle :cx x :cy y :r rad)
           :fill (-select-fill fill)
           :fill-opacity (-select-fo wsvg fo)
           :stroke (-select-stroke wsvg stroke)
           :stroke-width (-select-sw wsvg sw)
           :stroke-opacity (-select-so wsvg so))))


(defun wcirc (wsvg rad* &key (xy *zero*) outer-rad sw rs stroke so)
  (declare (wsvg wsvg) (list xy) (number rad*))
  (let* ((rad (veq:ff rad*))
         (inner (max 0.1f0 (if outer-rad rad 0.1f0)))
         (outer (if outer-rad outer-rad rad))
         (n (ceiling (* (abs (- outer inner))
                        (-select-rep-scale wsvg rs)))))
    (loop for r of-type veq:ff in (math:linspace n inner outer)
          do (circ wsvg r :xy xy :sw sw :stroke stroke :so so))))


(defun draw (wsvg d &key sw stroke fill so fo)
  (declare (wsvg wsvg) (vector d))
  "draw any svg dpath"
  (draw% (wsvg-scene wsvg) (:path :d d)
         :fill (-select-fill fill)
         :stroke (-select-stroke wsvg stroke)
         :stroke-width (-select-sw wsvg sw)
         :stroke-opacity (-select-so wsvg so)
         :fill-opacity (-select-fo wsvg fo)))


; (defun sign (wsvg str &key sw so (scale 2.5f0) (right 55f0) (bottom 9f0))
;   (declare (wsvg wsvg) (string str))
;   (with-struct (wsvg- width height) wsvg
;     (loop with gf = (gridfont:make :scale scale)
;           with b = (gridfont::get-phrase-box gf str)
;           with pos = (vec:vec (- width (vec:vec-x b) right)
;                               (- height (vec:vec-y b) bottom))
;           initially (gridfont:update gf :pos pos)
;           for c across str
;           do (loop for (path closed) in (gridfont:wc gf c)
;                    do (path wsvg path :so so :sw sw :closed closed)))))


(defun save (wsvg fn)
  (declare (wsvg wsvg))
  (with-open-file (fstream (ensure-filename fn ".svg")
                     :direction :output :if-exists :supersede)
    (declare (stream fstream))
    (cl-svg:stream-out fstream (wsvg-scene wsvg))))

