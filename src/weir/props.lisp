
(in-package :weir)

; this code is very verbose. there is some room for simplification. but there
; are also some subtle difference between functions that would be unnecessarily
; tedious to generalize. at least for now.

(defmacro -srt (e) `(sort ,e #'<))
(defmacro -prop (wer key) `(gethash ,key (weir-props ,wer)))
(defmacro -clear-prop (wer key) `(remhash ,key (weir-props ,wer)))

(defun clear-prop (wer key)
  (declare (weir wer))
  "clear all props from item/key (edge, grp, vert)"
  (-clear-prop wer key))

(defun -get-prop (wer key prop &key default)
  (declare #.*opt* (weir wer) (symbol prop))
  "get first matching (in alist) prop of key"
  (mvb (alist exists) (-prop wer key)
    (unless exists (return-from -get-prop
                                (values (if default default nil) nil)))
    (let ((res (assoc prop alist)))
      (unless res (return-from -get-prop (values (if default default nil) nil)))
      (values (cdr res) t))))

(defun -set-prop (wer key prop &optional (val t))
  (declare #.*opt* (weir wer) (symbol prop))
  "set prop of key to val.  shadows previous entries (in alist) of prop"
  (mvb (_ exists) (-prop wer key)
    (declare (ignore _))
    (if exists (setf (-prop wer key) (acons prop val (-prop wer key)))
               (setf (-prop wer key) `((,prop . ,val)))))
    val)

(defun clear-specific-prop (wer prop)
  (declare #.*opt* (weir wer) (symbol prop))
  "remove prop from every item (vert, edge, grp)."
  (loop for key being the hash-keys of (weir-props wer) using (hash-value v)
        do (when (-get-prop wer key prop)
             (setf (-prop wer key)
                   (remove-if (lambda (al) (eq (car al) prop))
                              (-prop wer key))))))
(defun clear-specific-props (wer props)
  (declare #.*opt* (weir wer) (list props))
  (loop for prop in props
        do (clear-specific-prop wer prop)))

; SET

(defun set-edge-prop (wer e prop &optional (val t))
  (declare #.*opt* (weir wer) (list e) (symbol prop))
  "set prop of edge e"
  (-set-prop wer (-srt e) prop val))
(defun mset-edge-prop (wer edges prop &optional (val t))
  (declare #.*opt* (weir wer) (list edges) (symbol prop))
  "set prop of edges"
  (loop for e of-type list in edges
        do (set-edge-prop wer e prop val)))

(defun set-vert-prop (wer v prop &optional (val t))
  (declare #.*opt* (weir wer) (fixnum v) (symbol prop))
  "set prop of vert v"
  (-set-prop wer v prop val))
(defun mset-vert-prop (wer verts prop &optional (val t))
  (declare #.*opt* (weir wer) (list verts) (symbol prop))
  "set prop of verts"
  (loop for v of-type fixnum in (remove-duplicates (alexandria:flatten verts))
        do (set-vert-prop wer v prop val)))

(defun set-grp-prop (wer g prop &optional (val t))
  (declare #.*opt* (weir wer) (symbol g prop))
  "set prop of grp g"
  (-set-prop wer g prop val))

; GET

(defun get-edge-prop (wer e prop &key default)
  (declare #.*opt* (weir wer) (list e) (symbol prop))
  "get prop ov edge e"
  (-get-prop wer (-srt e) prop :default default))
(defun get-vert-prop (wer v prop &key default)
  (declare #.*opt* (weir wer) (fixnum v) (symbol prop))
  "get prop of vert v"
  (-get-prop wer v prop :default default))
(defun get-grp-prop (wer g prop &key default)
  (declare #.*opt* (weir wer) (symbol g prop))
  "get prop of grp g"
  (-get-prop wer g prop :default default))

(defsetf -get-prop -set-prop)
(defsetf get-edge-prop set-edge-prop)
(defsetf get-vert-prop set-vert-prop)
(defsetf get-grp-prop set-grp-prop)

(defun get-edge-props (wer e) (declare (weir wer) (list e)) (-prop wer e))
(defun get-vert-props (wer v) (declare (weir wer) (pos-int v)) (-prop wer v))

; COPY

; TODO: replace all, side-effects of copied props (alists) ?
(defun copy-edge-props (wer from to &key clear)
  (declare (weir wer) (list from to))
  "copy props from to. use clear to clear prosp from to first."
  (when clear (-clear-prop wer to))
  (loop for (k . v) in (reverse (get-edge-props wer from))
        do (set-edge-prop wer to k v)))
(defun copy-vert-props (wer from to &key clear)
  (declare (weir wer) (pos-int from to))
  "copy props from to. use clear to clear props from to first."
  (when clear (-clear-prop wer to))
  (loop for (k . v) in (reverse (get-vert-props wer from))
        do (set-vert-prop wer to k v)))

(defun mcopy-edge-props (wer from to* &key clear)
  (declare (weir wer) (list from to*))
  "copy props from, from, into edges, to*"
  (loop for to of-type list in to*
        do (copy-edge-props wer from to :clear clear)))
(defun mcopy-vert-props (wer from to* &key clear)
  (declare (weir wer) (list from to*))
  "copy props from, from, into edges, to*"
  (loop for to of-type list in to*
        do (copy-vert-props wer from to :clear clear)))

; HAS PROP

(defun edge-has-prop (wer e prop &key val)
  (declare #.*opt* (weir wer) (list e) (symbol prop))
  "t if edge e has prop (and val)"
  (mvb (v exists) (get-edge-prop wer e prop)
    (if val (and exists (equal v val)) exists)))

(defun vert-has-prop (wer v prop &key val)
  (declare #.*opt* (weir wer) (fixnum v) (symbol prop))
  "t if vert v has prop (and val)"
  (mvb (v exists) (get-vert-prop wer v prop)
    (if val (and exists (equal v val)) exists)))

; GET ENTITIES WITH PROP

;TODO: reverse index for faster lookup?
(defun get-edges-with-prop (wer prop &key val g &aux (res (list)))
  (declare #.*opt* (weir wer) (symbol prop) (list res))
  "find edges with prop (and val)"
  (labels ((accept (e) (get-edge-prop wer e prop))
           (acceptval (e) (let ((pv (get-edge-prop wer e prop)))
                            (and pv (equal pv val)))))
    (let ((do-test (if val #'acceptval #'accept)))
      (with-grp (wer g* g)
        (graph:with-graph-edges ((grp-grph g*) e)
          (when (funcall do-test e) (push e res)))))
    res))
(defun get-verts-with-prop (wer prop &key val &aux (res (list)))
  (declare #.*opt* (weir wer) (symbol prop) (list res))
  "find verts with prop (and val)"
  (labels ((accept (v) (get-vert-prop wer v prop))
           (acceptval (v) (let ((pv (get-vert-prop wer v prop)))
                            (and pv (equal pv val)))))
    (let ((do-test (if val #'acceptval #'accept)))
      (loop for v from 0 below (weir-num-verts wer)
            do (when (funcall do-test v) (push v res))))
    res))

; GET EDGES WITH PROP AS PATH

(defun edge-prop->path (wer prop &key val g)
  (declare (weir wer) (symbol prop))
  "get edges with prop as path. returns (values path cycle"
  (graph:edge-set->path (get-edges-with-prop wer prop :val val :g g)))

(defun edge-prop-nxt-vert (wer v prop &key val (except -1) g)
  (declare #.*opt* (weir wer) (fixnum v except) (symbol prop))
  "get first (encountered) incident vert w from v, with prop (and val).
   ignores w when w == except.
   returns nil if there is no incident vert."
  (loop for w of-type fixnum in (get-incident-verts wer v :g g)
        if (not (= except w))
        do (when (edge-has-prop wer (-srt (list v w)) prop :val val)
                 (return-from edge-prop-nxt-vert w)))
  nil)


; TODO: this will behave incorrectly if main grp already contains an edge in.
; ladd-edge! will return T, not edge, (a b). i think?
(defun all-grps->main! (wer &key g)
  "copy all edges in all grps into main grp"
  (itr-grps (wer g*)
    (itr-edges (wer e :g g*)
      (set-edge-prop wer (ladd-edge! wer e :g g) g*))))

(defun show-props (wer)
  (loop for key being the hash-keys of (weir-props wer) using (hash-value v)
        do (format t "~%~%------~%~a~%~a~%" key v)))

