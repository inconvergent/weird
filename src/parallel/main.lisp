
(in-package :parallel)

;https://z0ltan.wordpress.com/2016/09/09/basic-concurrency-and-parallelism-in-common-lisp-part-4a-parallelism-using-lparallel-fundamentals/


(defun init (&key (cores 4) (name "custom-kernel"))
  (setf lparallel:*kernel*
        (lparallel:make-kernel cores :name name)))


(defun end ()
  (lparallel:end-kernel :wait t))


(defun info ()
  (let ((name (lparallel:kernel-name))
        (count (lparallel:kernel-worker-count))
        (context (lparallel:kernel-context))
        (bindings (lparallel:kernel-bindings)))
    (format t "kernel name = ~a~%" name)
    (format t "worker threads count = ~d~%" count)
    (format t "kernel context = ~a~%" context)
    (format t "kernel bindings = ~a~%" bindings)))


(defun create-channel ()
  (lparallel:make-channel))


(defun submit-task (channel fx)
  (lparallel:submit-task channel fx)
  (lparallel:receive-result channel))

