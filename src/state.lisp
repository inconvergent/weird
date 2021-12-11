
(in-package :state)


(defstruct (state (:constructor make ()))
  (s (make-hash-table :test #'equal) :type hash-table))

; TODO: only execute body if key exists
; TODO: flag to avoid setting result
(defmacro awith ((st k &key default) &body body)
  "access state[key] as state:it,
   the final form of body is assigned back to state[key]"
  (weird:awg (sname kname res dname s)
    `(let* ((,sname ,st)
            (,dname ,default)
            (,kname ,k)
            (,s (state-s ,sname))
            (it (gethash ,kname (state-s ,sname) ,dname))
            (,res (progn ,@body)))
      (setf (sget ,sname ,kname) ,res))))

(defun sget (st k &key default)
  "get k of state (or default)"
  (declare (state st))
  (gethash k (state-s st) default))

(defun -sset (st k v)
  "set k of st to v, returns v"
  (declare (state st))
  (setf (gethash k (state-s st)) v))

(defsetf sget -sset)

(defun lget (st keys &key default)
  "get keys of state (or default)"
  (declare (state st) (list keys))
  (loop for k in keys collect (sget st k :default default)))

(defun lset (st keys v)
  "set keys of st to v. returns keys"
  (declare (state st) (list keys))
  (loop for k in keys do (setf (sget st k) v)))

(defun to-list (st)
  (declare (state st))
  "get state as alist"
  (loop for k being the hash-keys of (state-s st) using (hash-value v)
        collect `(,k . ,v)))

