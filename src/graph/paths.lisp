
(in-package :graph)


; STRIP FILAMENTS

(defun -del-filament (grph v)
  (declare (graph grph) (veq:pn v))
  (let ((ee (get-incident-edges grph v)))
    (when (= (length ee) 1)
          (apply #'del grph (first ee)))))

(defun del-simple-filaments (grph)
  (declare (graph grph))
  "recursively remove all simple filament edges until there are none left.

"
  (loop until (notany #'identity
                      (loop for v in (get-verts grph)
                            collect (-del-filament grph v))))
  grph)

; CONTINOUS PATHS

;note: this can possibly be improved if k is an array
(defun -cycle-info (k)
  (declare (list k))
  (if (= (first k) (first (last k))) (list (cdr k) t) (list k nil)))

(defun -find-segment (grph start curr)
  (declare (graph grph) (veq:pn start curr))
  (loop with res = (make-adjustable-vector :type 'veq:pn :init (list start))
        with prev of-type veq:pn = start
        while t
        do (let* ((incident (get-incident-edges grph curr))
                  (n (length incident)))
             (declare (veq:pn n))

             ; loop. attach curr to indicate loop
             (when (= curr start)
                   (vextend curr res)
                   (return-from -find-segment res))

             ; dead end/multi
             (unless (= n 2)
                     (vextend curr res)
                     (return-from -find-segment res))

             ; single connection
             (when (= n 2)
                   (let ((c (remove-if (lambda (i) (= i curr))
                                       (-only-incident-verts prev incident))))
                     (vextend curr res)
                     (setf prev curr curr (first c)))))))

(defun -add-visited-verts (visited path)
  (loop for v in path do (setf (gethash v visited) t)))

; TODO: rewrite this to avoid cheching everything multiple times.
(defun get-segments (grph &key cycle-info)
  (declare (graph grph))
  "greedily finds segments :between: multi-intersection points.

note: by definition this will not return parts of the graph that have no
multi-intersections. consider walk-graph instead."
  (let ((all-paths (make-hash-table :test #'equal))
        (visited (make-hash-table :test #'equal)))

    (labels
      ((-incident-not-two (incident)
         (declare (list incident))
         (not (= (length incident) 2)))

       (-incident-two (incident)
         (declare (list incident))
         (= (length incident) 2))

       (-do-find-segment (v next)
         (declare (veq:pn v next))
         (let* ((path (to-list (-find-segment grph v next)))
                (key (sort (copy-list path) #'<)))
           (declare (list path key))
           (unless (gethash key all-paths)
                   (-add-visited-verts visited path)
                   (setf (gethash key all-paths) path))))

       (-walk-incident-verts (v testfx)
         (declare (veq:pn v) (function testfx))
         (let ((incident (get-incident-edges grph v)))
           (declare (list incident))
           (when (funcall testfx incident)
                 (loop for next in (-only-incident-verts v incident)
                       do (-do-find-segment v next))))))

      (loop for v in (sort (get-verts grph) #'<)
            do (-walk-incident-verts v #'-incident-not-two))

      ; note: this can be improved if we inverted visited, and remove vertices
      ; as they are visited
      (loop for v in (sort (get-verts grph) #'<)
            unless (gethash v visited)
            do (-walk-incident-verts v #'-incident-two)))

    (loop with fx = (if cycle-info #'-cycle-info #'identity)
          for k of-type list being the hash-values of all-paths
          collect (funcall fx k) of-type list)))

(defun -angle-fx (a b c)
  (declare (ignore a b c))
  1f0)

(defun walk-graph (grph &key (angle #'-angle-fx))
  (declare (graph grph))
  "greedily walks the graph so that every edge is returned exactly once.
in multi-intersectinons the walker selects the smallest available angle.
this is useful for exporting a graph as a plotter drawing."

  (let ((all-edges (loop with res = (make-hash-table :test #'equal)
                         for e in (get-edges grph)
                         do (setf (gethash e res) t)
                         finally (return res))))
    (labels
      ((-ic (a b) (if (< a b) (list a b) (list b a)))
       (-get-start-edge ()
         (loop for e being the hash-keys of all-edges
               do (return-from -get-start-edge e)))

       (-least-angle (a b vv)
         (cadar (sort
                  (mapcar (lambda (v)
                            (list (weird:aif
                                    (funcall angle a b v)
                                    weird:it 0f0)
                                  v))
                          vv)
                  #'> :key #'car)))

       (-next-vert-from (a &key but-not)
         (-least-angle but-not a (remove-if
                (lambda (v) (or (= v but-not)
                                (not (gethash (-ic a v) all-edges))))
                (get-incident-verts grph a))))

       (-until-dead-end (a but-not)
         (loop with prv = a
               with res = (list prv)
               with nxt = (-next-vert-from a :but-not but-not)
               until (equal nxt nil)
               do (push nxt res)
                  (remhash (-ic prv nxt) all-edges)
                  (let ((nxt* (-next-vert-from nxt :but-not prv)))
                    (setf prv nxt nxt nxt*))
               finally (return res))))

      (loop while (> (hash-table-count all-edges) 0)
            collect (let ((start (-get-start-edge)))
                      (remhash start all-edges)
                      (destructuring-bind (a b) start
                        (concatenate 'list
                          (-until-dead-end a b)
                          (reverse (-until-dead-end b a)))))))))

