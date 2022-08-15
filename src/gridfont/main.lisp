
(in-package :gridfont)

; json docs https://common-lisp.net/project/cl-json/cl-json.html

(defun -jsn-get (jsn k) (cdr (assoc k jsn)))

(defstruct (gridfont (:constructor -make-gridfont))
  (scale 1f0 :type veq:ff :read-only nil)
  (sp 1f0 :type veq:ff :read-only nil)
  (nl 13f0 :type veq:ff :read-only nil)
  (xy nil :type list :read-only nil)
  (left 0f0 :type veq:ff :read-only nil)
  (prev nil :read-only nil)
  (symbols (make-hash-table :test #'equal) :read-only t))

(defun make (&key (fn (internal-path-string "src/gridfont/smooth"))
                  (scale 2f0) (nl 15f0) (sp 2f0) (xy (list 0f0 0f0)))
  (with-open-file (fstream (ensure-filename fn ".json" t) :direction :input)
    (loop with res = (make-hash-table :test #'equal)
          with jsn = (json:decode-json fstream) ; jsn is an alist
          with symbols = (-jsn-get jsn :symbols)
          for (k . v) in symbols
          do (setf (gethash (symbol-name k) res) v)
          finally (return (-make-gridfont
                            :symbols res :scale scale :sp sp :xy xy :nl nl
                            :left (first xy))))))

(veq:fvdef -detect-closed (paths)
  (declare (list paths))
  (labels ((-closed (p &key (tol 0.001f0))
             (declare (veq:fvec p) (veq:ff tol))
             (< (veq:f2dst (veq:f2$ p) (veq:f2$last p)) tol)))
    (loop for p of-type veq:fvec in paths
          collect (list p (-closed p)))))


(defun update (gf &key xy scale sp nl)
  (declare (gridfont gf))
  "update gridfont properties"
  (when xy (setf (gridfont-xy gf) xy
                 (gridfont-left gf) (first xy)))
  (when scale (setf (gridfont-scale gf) scale))
  (when sp (setf (gridfont-sp gf) sp))
  (when nl (setf (gridfont-nl nl) sp)))


(defun nl (gf &key (left (gridfont-left gf)))
  (declare (gridfont gf) (veq:ff left))
  "write a newline"
  (setf (gridfont-prev gf) nil)
  (with-struct (gridfont- nl scale) gf
    (setf (gridfont-xy gf)
          (list left (+ (second (gridfont-xy gf))
                        (* nl scale))))))


(defun -get-meta (symbols c &aux (c* (string c)))
  (multiple-value-bind (meta exists)
    (gethash (funcall json:*json-identifier-name-to-lisp* c*) symbols)
    (unless exists (error "symbol does not exist: ~a (representation: ~a)" c c*))
    meta))

(defun -pos (pp &optional (s 1f0))
  (declare (list pp) (veq:ff s))
  (mapcar (lambda (x) (veq:ff (* s x))) pp))

(veq:fvdef -path-to-arr (paths s (:varg 2 x))
  (declare (list paths) (veq:ff s x))
  (loop for path of-type list in paths
        collect (veq:f2$+ (values (veq:f$_ (loop for p of-type list in path
                                                 collect (-pos p s))))
                          x)))

; TODO: return (values paths width height)
(defun wc (gf c &key xy)
  (declare (gridfont gf))
  "write single character, c"
  (when xy (setf (gridfont-xy gf) xy))
  (with-struct (gridfont- symbols scale sp xy) gf
    (let* ((meta (-get-meta symbols c))
           (paths (-jsn-get meta :paths))
           (w (veq:ff (-jsn-get meta :w)))
           (res (-detect-closed (apply #'-path-to-arr paths scale xy))))
      (weird:dsb (x y) xy
        (declare (veq:ff x y))
        (setf (gridfont-xy gf) (list (+ x (* scale (+ w sp))) y)
              (gridfont-prev gf) (string c)))
      res)))


(defun get-phrase-box (gf str)
  (declare (gridfont gf) (string str))
  "width and height of phrase"
  (with-struct (gridfont- symbols scale sp) gf
    (loop for c across str
          summing (+ (-jsn-get (-get-meta symbols c) :w) sp) into width
          maximizing (-jsn-get (-get-meta symbols c) :h) into height
          finally (return (-pos (list width height) scale)))))

