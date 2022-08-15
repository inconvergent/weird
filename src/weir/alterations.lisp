
(in-package :weir)


(defmacro ? ((&rest args) &rest rest)
  ; (print args) ((X) (LIST #:WW-X-310 #:WW-Y-311 :A?))
  (apply #'build-alt (caar args) ; caar = w
    (loop with res of-type list = (list)
          for s of-type symbol in (weird:undup
                                    (weird:tree-find-all (cadr args)
                                      #'future-symbp))
          do (setf res (cons s (cons s res)))
          finally (return (reverse res)))
    (cadr args) rest))


(defalt add-grp? (wer g) (unless (grp-exists wer :g g) (add-grp! wer g)))

(defalt add-poly? (wer poly &key g) (add-poly! wer poly :g g))
(defalt del-poly? (wer poly &key g) (del-poly! wer poly :g g))

(defalt add-edge? (wer a b &key g) (add-edge! wer a b :g g))
(defalt ladd-edge? (wer ab &key g) (ladd-edge! wer ab :g g))
(defalt del-edge? (wer a b &key g) (del-edge! wer a b :g g))
(defalt ldel-edge? (wer ab &key g) (ldel-edge! wer ab :g g))

(defalt swap-edge? (wer a b &key g from) (swap-edge! wer a b :g g :from from))
(defalt lswap-edge? (wer ab &key g from) (lswap-edge! wer ab :g g :from from))

(defalt 2add-path? (wer l &key g closed) (2add-path! wer l :g g :closed closed))
(defalt 3add-path? (wer l &key g closed) (3add-path! wer l :g g :closed closed))

(defalt del-path? (wer l &key g) (del-path! wer l :g g))

(defalt 2add-vert? (wer f2!p) (2add-vert! wer f2!p))
(defalt 3add-vert? (wer f3!p) (3add-vert! wer f3!p))

(defalt 2vadd-edge? (wer f2!p f2!q &key g) (2vadd-edge! wer f2!p f2!q :g g))
(defalt 3vadd-edge? (wer f3!p f3!q &key g) (3vadd-edge! wer f3!p f3!q :g g))

(defalt 2move-vert? (wer i f2!p &key (rel t))
  (when (-valid-vert wer i)
        (progn (2move-vert! wer i f2!p :rel rel) i)))
(defalt 3move-vert? (wer i f3!p &key (rel t))
  (when (-valid-vert wer i)
        (progn (3move-vert! wer i f3!p :rel rel) i)))

(defalt 2append-edge? (wer i f2!p &key g (rel t))
  (when (-valid-vert wer i)
        (2append-edge! wer i f2!p :rel rel :g g)))

(defalt 3append-edge? (wer i f3!p &key g (rel t))
  (when (-valid-vert wer i)
        (3append-edge! wer i f3!p :rel rel :g g)))

(defalt 2split-edge? (wer u v f2!p &key g force)
  (when (-valid-verts wer (list u v))
        (2split-edge! wer u v f2!p :g g :force force)))
(defalt 2lsplit-edge? (wer uv f2!p &key g force)
  (when (-valid-verts wer uv)
        (2lsplit-edge! wer uv f2!p :g g :force force)))

(defalt 3split-edge? (wer u v f3!p &key g force)
  (when (-valid-verts wer (list u v))
        (3split-edge! wer u v f3!p :g g :force force)))
(defalt 3lsplit-edge? (wer uv f3!p &key g force)
  (when (-valid-verts wer uv)
        (3lsplit-edge! wer uv f3!p :g g :force force)))

(defalt split-edge-ind? (wer u v via &key g force)
  (when (-valid-verts wer (list u v))
        (split-edge-ind! wer u v :via via :g g :force force)))
(defalt lsplit-edge-ind? (wer uv via &key g force)
  (when (-valid-verts wer uv)
        (lsplit-edge-ind! wer uv :via via :g g :force force)))

(defalt collapse-verts? (wer u v &key g)
  (when (-valid-verts wer (u v)) (collapse-verts! wer u v :g g)))
(defalt lcollapse-verts? (wer uv &key g)
  (when (-valid-verts wer uv) (lcollapse-verts! wer uv :g g)))


(defalt set-edge-prop? (wer e prop &optional (val t))
  (setf (get-edge-prop wer e prop) val))
(defalt set-vert-prop? (wer v prop &optional (val t))
  (setf (get-vert-prop wer v prop) val))
(defalt set-grp-prop? (wer g prop &optional (val t))
  (setf (get-grp-prop wer g prop) val))

(defalt mset-vert-prop? (wer vv prop &optional (val t))
  (mset-vert-prop wer vv prop val))
(defalt mset-edge-prop? (wer ee prop &optional (val t))
  (mset-vert-prop wer ee prop val))

(defalt copy-edge-props? (wer from to &key clear)
  (copy-edge-props wer from to :clear clear))
(defalt copy-vert-props? (wer from to &key clear)
  (copy-vert-props wer from to :clear clear))

(defalt mcopy-edge-props? (wer from to &key clear)
  (mcopy-edge-props wer from to :clear clear))
(defalt mcopy-vert-props? (wer from to &key clear)
  (mcopy-vert-props wer from to :clear clear))

;; alterations that return a value, but don't do anything.
;; these should be postfixed with %.
;; TODO: fix inconsistent use of get in names?

(defalt get-vert-prop% (_ v prop) (get-vert-prop _ v prop))
(defalt get-edge-prop% (_ e prop) (get-edge-prop _ e prop))
(defalt get-grp-prop% (_ g prop) (get-grp-prop _ g prop))

(defalt verts-with-prop% (_ prop &key val)
  (get-verts-with-prop _ prop :val val))
(defalt vert-with-prop% (_ prop &key val)
  (car (get-verts-with-prop _ prop :val val)))

(defalt edges-with-prop% (_ prop &key val)
  (get-edges-with-prop _ prop :val val))
(defalt edge-with-prop% (_ prop &key val)
  (car (get-edges-with-prop _ prop :val val)))

(defalt edge-prop-nxt-vert% (_ v prop &key val (except -1) g)
  (edge-prop-nxt-vert% _ v prop :val val :except except :g g))

