
(in-package :weir)


(defun get-alteration-result-list (wer &key (all t))
  (declare #.*opt* (weir wer) (boolean all))
  "returns alist with tuples of alteration :res and corresponding value."
  (loop for k being the hash-keys of (weir-alt-res wer)
          using (hash-value v)
        if (or all v) ; TODO: does this do anything with the current approach?
        collect `(,k . ,v)))

(defun get-alteration-result-map (wer)
  (declare #.*opt* (weir wer))
  "returns hash-table with results of all alterations by :res."
  (weir-alt-res wer))

(defun get-alt-res (wer res)
  (declare #.*opt* (weir wer) (symbol res))
  (unless (future-symbp res)
          (error "invalid alteration result name: ~a~%" res))
  (gethash res (weir-alt-res wer)))


(defun -if-all-resolved (alt-res &rest arg)
  (declare #.*opt* (hash-table alt-res) (list arg))
  "check if all references of an alteration have been resolved."
  (loop for k of-type symbol in arg
        do (weird:mvb (res exists) (gethash k alt-res)
             (declare (boolean exists))
             ; wait if result is not set
             (unless exists (return-from -if-all-resolved :wait))
             ; bail if result exists and is nil
             (unless res (return-from -if-all-resolved :bail))))
  :ok) ; result exists and is not nil


(defun fdim-symbp (s &key dim)
  (declare #.*opt* (veq:pn dim))
  "t if symbol starts with Fd! where d is a positive integer"
  (and (symbolp s)
       (> (length (symbol-name s)) 3)
       (string= (symbol-name s) (mkstr "F" dim "!") :start1 0 :end1 3)))

(defun future-symbp (s)
  (declare #.*opt*)
  "t if symbol ends with ?"
  (and (symbolp s)
       (> (length (symbol-name s)) 1)
       (string= (the string (reverse (symbol-name s))) "?"
                :start1 0 :end1 1)))

(defmacro with-gs ((&rest rest) &body body)
  `(let (,@(loop for s of-type symbol in rest
                 collect `(,s (gensym ,(string-upcase (mkstr s))))))
     ,@body))


(defmacro -valid-vert (wer v) `(< -1 (the veq:pn ,v)
                                     (the veq:pn (weir-num-verts ,wer))))
(defmacro -valid-verts (wer vv)
  (weird:awg (num v)
    `(let ((,num (weir-num-verts ,wer)))
      (declare (veq:pn ,num))
      (every (lambda (,v) (declare (optimize speed) (veq:pn ,v))
                          (< -1 ,v ,num))
             ,vv))))

