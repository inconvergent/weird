
(in-package :weir)

(defvar *wgs* (gensym (mkstr "WER")))

(defun build-alt (wname pairs aexpr &key alt-res res db)
  (declare #.*opt* (symbol wname) (list pairs aexpr) (symbol alt-res))


  ; example result for add-edge?:

  ; outer pairs: ((G NIL OUTER-G62))
  ; future-pairs: ((A MID? OUTER-A60) (B E1? OUTER-B61))

  ; (LET ((#:OUTER-G62 NIL))
  ;   (LAMBDA (#:WER541)
  ;     (DECLARE (OPTIMIZE (SAFETY 1) SPEED (DEBUG 2) SPACE)
  ;              (WEIR::WEIR #:WER541)
  ;              (IGNORABLE #:WER541))
  ;     (CASE (WEIR::-IF-ALL-RESOLVED #:ALT-RES15 (LIST :MID? :E1?))
  ;       (:OK
  ;        (VALUES T
  ;                (PROGN
  ;                 (WEIR:ADD-EDGE! #:WER541 (VALUES (GETHASH :MID? #:ALT-RES15))
  ;                                 (VALUES (GETHASH :E1? #:ALT-RES15)) :G
  ;                                 #:OUTER-G62))))
  ;       (:BAIL (PROGN NIL (VALUES T NIL)))
  ;       (T (VALUES NIL NIL)))))

  (labels ((select-let (s)
             (declare #.*opt* (symbol s))
             (cond ((fdim-symbp s :dim 2) 'veq:f2let)
                   ((fdim-symbp s :dim 3) 'veq:f3let)
                   (t 'let)))
           (wraplet (pairs inner)
             (declare #.*opt* (list pairs) (cons inner))
             (loop for (o b a) in (reverse pairs)
                   do (setf inner `(,(select-let o) ((,a ,b)) ,inner)))
             inner)
           (replace-inner-symbols (pairs aexpr)
             (declare #.*opt* (list pairs) (cons aexpr))
             (loop for (old org new) in pairs
                   do (setf aexpr (subst new old aexpr)))
             aexpr)
           (promise-s (tree)
             (declare #.*opt*)
             (tree-find tree #'promise-symbp))
           (replace-inner-futures (pairs aexpr)
             (declare #.*opt* (list pairs) (cons aexpr))
             (loop for (old org new) in pairs
                   do (setf aexpr
                            (subst `(values (gethash ,(promise-s org) ,alt-res))
                                   (promise-s org)
                                   (subst org old aexpr))))
             aexpr)
           (split-pairs (pairs)
             (declare #.*opt* (list pairs))
             (filter-by-predicate
               (mapcar (lambda (sv) (declare (optimize speed))
                         `(,@sv ,(gensym (mkstr "OUT-" (car sv)))))
                       (weird:group pairs 2))
               (lambda (s) (declare (optimize speed)) (promise-s (second s))))))

    (mvb (future-pairs outer-pairs) (split-pairs pairs)
      (declare (list outer-pairs future-pairs))

      (when db (format t "~%outer pairs: ~a~%~%future-pairs: ~a~%"
                       outer-pairs future-pairs))

        (let* ((aexpr (subst *wgs* wname
                             (replace-inner-futures future-pairs
                               (replace-inner-symbols outer-pairs
                                 aexpr))))
               (main (if res `(setf (gethash ,res ,alt-res) ,aexpr)
                             `(progn ,aexpr)))
               (inner (if future-pairs ; if arg
                        `(case (-if-all-resolved ,alt-res
                                 (list ,@(mapcar (lambda (l)
                                            (promise-s (second l)))
                                          future-pairs)))
                           (:ok (values t ,main))
                           (:bail (progn ,(if res `(setf (gethash ,res ,alt-res) nil))
                                         (values t nil)))
                           (t (values nil nil)))
                        `(values t ,main)))
               (full (wraplet outer-pairs
                       `(lambda (,*wgs*)
                          (declare #.*opt* (weir ,*wgs*) (ignorable ,*wgs*))
                          ,inner))))
          (declare (list aexpr main inner full))
          (when db (-print-debug full db))
          full))))


; ---- ALTERATIONS
; TODO: avoid var capture with gensyms in aexpr
; TODO: ignore nil alts

(defmacro val* (&body body) `(mvc #'values ,@body))


(defmacro ? ((&rest args) &rest rest)
  (apply #'build-alt (caar args) ; caar = w
    (loop with res of-type list = (list)
          for s of-type symbol in (weird:undup
                                    (weird:tree-find-all (cadr args)
                                      #'promise-symbp))
          do (setf res (cons s (cons s res)))
          finally (return (reverse res)))
    (cadr args) rest))


(defmacro add-grp? ((g) &rest rest)
  (apply #'build-alt 'w `(g ,g) '(unless (grp-exists w :g g) (add-grp! w g)) rest))

(defmacro add-edge? ((a b &key g) &rest rest)
  (apply #'build-alt 'w `(a ,a b ,b g ,g) '(add-edge! w a b :g g) rest))
(defmacro ladd-edge? ((ab &key g) &rest rest)
  (apply #'build-alt 'w `(ab ,ab g ,g) '(ladd-edge! w ab :g g) rest))

(defmacro del-edge? ((a b &key g) &rest rest)
  (apply #'build-alt 'w `(a ,a b ,b g ,g) '(del-edge! w a b :g g) rest))
(defmacro ldel-edge? ((ab &key g) &rest rest)
  (apply #'build-alt 'w `(ab ,ab g ,g) '(ldel-edge! w ab :g g) rest))

(defmacro swap-edge? ((a b &key g from) &rest rest)
  (apply #'build-alt 'w `(a ,a b ,b g ,g from ,from)
         '(swap-edge! w a b :g g :from from) rest))
(defmacro lswap-edge? ((ab &key g from) &rest rest)
  (apply #'build-alt 'w `(ab ,ab g ,g from ,from)
         '(lswap-edge! w ab :g g :from from) rest))

(defmacro add-path? ((l &key g) &rest rest)
  (apply #'build-alt 'w `(l ,l g ,g) '(add-path! w l :g g) rest))
(defmacro del-path? ((l &key g) &rest rest)
  (apply #'build-alt 'w `(l ,l g ,g) '(del-path! w l :g g) rest))

(defmacro 2add-vert? ((p) &rest rest)
  (apply #'build-alt 'w `(f2!p ,p) '(2add-vert! w (val* f2!p)) rest))
(defmacro 3add-vert? ((p) &rest rest)
  (apply #'build-alt 'w `(f3!p ,p) '(3add-vert! w (val* f3!p)) rest))

(defmacro 2vadd-edge? ((p q &key g) &rest rest)
  (apply #'build-alt 'w `(f2!p ,p f2!q ,q g ,g)
    '(2vadd-edge! w (val* f2!p f2!q) :g g) rest))
(defmacro 3vadd-edge? ((p q &key g) &rest rest)
  (apply #'build-alt 'w `(f3!p ,p f3!q ,q g ,g)
    '(3vadd-edge! w (val* f3!p f3!q) :g g) rest))

(defmacro 2move-vert? ((i p &key (rel t)) &rest rest)
  (apply #'build-alt 'w `(i ,i f2!p ,p rel ,rel)
    `(when (-valid-vert w i)
       (progn (2move-vert! w i (val* f2!p) :rel rel)
              i)) rest))
(defmacro 3move-vert? ((i p &key (rel t)) &rest rest)
  (apply #'build-alt 'w `(i ,i f3!p ,p rel ,rel)
    `(when (-valid-vert w i)
       (progn (3move-vert! w i (val* f3!p) :rel rel)
              i)) rest))

(defmacro 2append-edge? ((i p &key g (rel t)) &rest rest)
  (apply #'build-alt 'w `(i ,i f2!p ,p rel ,rel g ,g)
    `(when (-valid-vert w i)
       (2append-edge! w i (val* f2!p) :rel rel :g g)) rest))
(defmacro 3append-edge? ((i p &key g (rel t)) &rest rest)
  (apply #'build-alt 'w `(i ,i f3!p ,p rel ,rel g ,g)
    `(when (-valid-vert w i)
       (3append-edge! w i (val* f3!p) :rel rel :g g)) rest))

(defmacro 2split-edge? ((u v xy &key g force) &rest rest)
  (apply #'build-alt 'w `(u ,u v ,v f2!p ,xy g ,g force ,force)
    `(when (-valid-verts w (list u v))
       (2split-edge! w u v f2!p :g g :force force)) rest))
(defmacro 2lsplit-edge? ((uv xy &key g force) &rest rest)
  (apply #'build-alt 'w `(uv ,uv f2!p ,xy g ,g force ,force)
    `(when (-valid-verts w uv)
       (2lsplit-edge! w uv f2!p :g g :force force)) rest))

(defmacro 3split-edge? ((u v xy &key g force) &rest rest)
  (apply #'build-alt 'w `(u ,u v ,v f3!p ,xy g ,g force ,force)
    `(when (-valid-verts w (list u v))
       (3split-edge! w u v f3!p :g g :force force)) rest))
(defmacro 3lsplit-edge? ((uv xy &key g force) &rest rest)
  (apply #'build-alt 'w `(uv ,uv f3!p ,xy g ,g force ,force)
    `(when (-valid-verts w uv)
       (3lsplit-edge! w uv f3!p :g g :force force)) rest))

(defmacro split-edge-ind? ((u v via &key g force) &rest rest)
  (apply #'build-alt 'w `(u ,u v ,v via ,via g ,g force ,force)
    `(when (-valid-verts w (list u v))
       (split-edge-ind! w u v :via via :g g :force force)) rest))
(defmacro lsplit-edge-ind? ((uv via &key g force) &rest rest)
  (apply #'build-alt 'w `(uv ,uv via ,via g ,g force ,force)
    `(when (-valid-verts w uv)
       (lsplit-edge-ind! w uv :via via :g g :force force)) rest))

(defmacro collapse-verts? ((u v &key g) &rest rest)
  (apply #'build-alt 'w `(u ,u v ,v g ,g)
    `(when (-valid-verts w (u v)) (collapse-verts! w u v :g g)) rest))
(defmacro lcollapse-verts? ((uv &key g) &rest rest)
  (apply #'build-alt 'w `(uv ,uv g ,g)
    `(when (-valid-verts w uv) (lcollapse-verts! w uv :g g)) rest))


(defmacro set-edge-prop? ((e prop &optional (val t)) &rest rest)
  (apply #'build-alt 'w `(e ,e prop ,prop val ,val)
    `(setf (get-edge-prop w e prop) val) rest))
(defmacro set-vert-prop? ((v prop &optional (val t)) &rest rest)
  (apply #'build-alt 'w `(v ,v prop ,prop val ,val)
    `(setf (get-vert-prop w v prop) val) rest))
(defmacro set-grp-prop? ((g prop &optional (val t)) &rest rest)
  (apply #'build-alt 'w `(g ,g prop ,prop val ,val)
    `(setf (get-grp-prop w g prop) val) rest))
(defmacro mset-vert-prop? ((vv prop &optional (val t)) &rest rest)
  (apply #'build-alt 'w `(vv ,vv prop ,prop val ,val)
    `(mset-vert-prop w vv prop val) rest))
(defmacro mset-edge-prop? ((ee prop &optional (val t)) &rest rest)
  (apply #'build-alt 'w `(ee ,ee prop ,prop val ,val)
    `(mset-vert-prop w ee prop val) rest))

(defmacro copy-edge-props? ((from to &key clear) &rest rest)
  (apply #'build-alt 'w `(from ,from to ,to clear ,clear)
    `(copy-edge-props w from to :clear clear) rest))
(defmacro copy-vert-props? ((from to &key clear) &rest rest)
  (apply #'build-alt 'w `(from ,from to ,to clear ,clear)
    `(copy-vert-props w from to :clear clear) rest))
(defmacro mcopy-edge-props? ((from to &key clear) &rest rest)
  (apply #'build-alt 'w `(from ,from to ,to clear ,clear)
    `(mcopy-edge-props w from to :clear clear) rest))
(defmacro mcopy-vert-props? ((from to &key clear) &rest rest)
  (apply #'build-alt 'w `(from ,from to ,to clear ,clear)
    `(mcopy-vert-props w from to :clear clear) rest))


; ; alterations that return a value, but don't do anything.
; ; these should be postfixed with %.

(defmacro get-vert-prop% ((v prop) &rest rest)
  (apply #'build-alt 'w `(v ,v prop ,prop)
    `(get-vert-prop w v prop) rest))
(defmacro get-edge-prop% ((e prop) &rest rest)
  (apply #'build-alt 'w `(e ,e prop ,prop)
    `(get-edge-prop w e prop) rest))
(defmacro get-grp-prop% ((g prop) &rest rest)
  (apply #'build-alt 'w `(g ,g prop ,prop)
    `(get-grp-prop w g prop) rest))

(defmacro verts-with-prop% ((prop &key val) &rest rest)
  (apply #'build-alt 'w `(prop ,prop val ,val)
    `(verts-with-prop w prop :val val) rest))
(defmacro edges-with-prop% ((prop &key val) &rest rest)
  (apply #'build-alt 'w `(prop ,prop val ,val)
    `(edges-with-prop w prop :val val) rest))

(defmacro edge-prop-nxt-vert% ((v prop &key val (except -1) g) &rest rest)
  (apply #'build-alt 'w `(v ,v prop ,prop val ,val except ,except g ,g)
    `(edge-prop-nxt-vert% w v prop :val val :except except :g g) rest))

