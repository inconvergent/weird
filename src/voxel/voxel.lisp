
(in-package :voxel)

(declaim (inline -set-imap))
(defun -set-imap (imap ix iy iz)
  (declare #.*opt* (pos-vec imap) (veq:pn ix iy iz))
  (loop for i of-type veq:pn from 0 below 24 by 3
        do (setf (aref imap i) (+ ix (aref *offsets* i))
                 (aref imap (1+ i)) (+ iy (aref *offsets* (1+ i)))
                 (aref imap (+ i 2)) (+ iz (aref *offsets* (+ i 2))))))

(declaim (inline -get-cubeindex))
(defun -get-cubeindex (a imap fx)
  (declare #.*opt* (veq:fvec a) (pos-vec imap) (function fx))
  (loop with ind of-type veq:pn = 0
        for i of-type veq:pn from 0 below 24 by 3
        for b of-type veq:pn from 0
        do (let ((va (aref a (aref imap i) (aref imap (1+ i))
                             (aref imap (+ i 2)))))
             ; (when (and  (>= hi va lo)) (incf ind (the veq:pn (expt (abs 2) b))))
             (when (funcall fx (the veq:ff va)) (incf ind (the veq:pn (expt (abs 2) b)))))
        finally (return ind)))

(declaim (inline -set-voxel-list))
(defun -set-voxel-list (voxellist ec)
  (declare #.*opt* (pos-vec voxellist) (veq:pn ec))
  (loop for i of-type veq:pn from 0 below 12
        for k of-type veq:pn from 0 by 2
        do (let ((pow (the veq:pn (expt (abs 2) i))))
             (declare (veq:pn pow))
             (when (= (logand ec pow) pow)
                   (setf (aref voxellist k) (aref *cubeind* k)
                         (aref voxellist (1+ k)) (aref *cubeind* (1+ k)))))))

(declaim (inline -do-global-edge))
(defun -do-global-edge (imap v &aux (3v (* 3 v)))
  (declare #.*opt* (pos-vec imap) (veq:pn v 3v))
  (list (aref imap 3v) (aref imap (1+ 3v)) (aref imap (+ 3v 2))))

(declaim (inline -single-ind))
(defun -single-ind (v)
  (declare #.*opt* (list v))
  (veq:dsb (x y z) v
    (declare (veq:pn x y z))
    (+ x (the veq:pn
              (* *max-voxels*
                 (the veq:pn (+ y (the veq:pn (* *max-voxels* z)))))))))

(declaim (inline -hash-edge))
(defun -hash-edge (edge)
  (declare #.*opt* (list edge))
  (sort (mapcar #'-single-ind edge) #'<))


(declaim (inline -get-pos-mid))
(veq:fvdef -get-pos-mid (a e)
  (declare #.*opt* (ignore a) (list e))
  (veq:dsb (ev1 ev2) e
    (declare (list ev1 ev2))
    (veq:f3+ (veq:f3mid (veq:ffl ev1) (veq:ffl ev2))
             (veq:f3rep *shift*))))


(veq:fvdef* -intersect ((:va 3 p1 p2) av1 av2 &aux (av1 (abs av1)) (av2 (abs av2)))
  (declare #.*opt* (veq:ff p1 p2 av1 av2))
  (if (< (abs (- av2 av1)) *eps*)
    (veq:f3mid p1 p2)
    (veq:f3iscale (veq:f3+ (veq:f3scale p1 av1) (veq:f3scale p2 av2))
                  (+ av1 av2))))


; (declaim (inline -get-pos-weighted))
(veq:fvdef -get-pos-weighted (a e)
  (declare #.*opt* (veq:fvec a) (list e))
  (veq:dsb (ev1 ev2) e
    (declare (list ev1 ev2))
    (veq:f3+ (-intersect (veq:ffl ev1) (veq:ffl ev2)
                         (apply #'aref a ev1) (apply #'aref a ev2))
             (veq:f3rep *shift*))))

; (declaim (inline -add-poly))
(defun -add-poly (a edge->vert wer tri posfx)
  (declare #.*opt* (veq:fvec a) (hash-table edge->vert) (list tri))
  (weir:add-poly! wer
    (loop for e of-type list in tri
          collect (let ((h (-hash-edge e)))
                    (declare (list h))
                    (veq:mvb (v exists) (gethash h edge->vert)
                      (declare (boolean exists))
                      (if exists v (setf (gethash h edge->vert)
                                         (weir:3add-vert! wer
                                           (veq:mvc (the function posfx) a e))))))
                  of-type veq:pn)))

; (declaim (inline -make-poly))
(defun -make-poly (imap voxellist cubeindex i)
  (declare #.*opt* (pos-vec imap voxellist) (veq:pn cubeindex i))
  (loop for k of-type veq:pn from 0 below 3
        collect (let ((i2 (* 2 (aref *triangles* cubeindex (+ i k)))))
                  (declare (veq:pn i2))
                  (list (-do-global-edge imap (aref voxellist i2))
                        (-do-global-edge imap (aref voxellist (1+ i2)))))
                of-type list))

; (declaim (inline -add-polys))
(defun -add-polys (a edge->vert imap voxellist cubeindex wer posfx)
  (declare #.*opt* (veq:fvec a) (pos-vec imap voxellist)
                   (veq:pn cubeindex) (hash-table edge->vert))
  (loop for i of-type veq:pn from 0 by 3
        until (= (aref *triangles* cubeindex i) 99)
        collect (-add-poly a edge->vert wer
                           (-make-poly imap voxellist cubeindex i)
                           posfx)))

(defun set-voxels (dims fx)
  (declare #.*opt* (list dims) (function fx))
  " dims = (list nx ny nz) "
  (veq:dsb (nx ny nz) dims
    (declare (veq:pn nx ny nz))
    (loop with voxs = (make dims)
          with maxv = -99999f0
          with minv = 99999f0
          for x of-type veq:pn from 0 below nx do
    (loop for y of-type veq:pn from 0 below ny do
    (loop for z of-type veq:pn from 0 below nz
          do (let ((v (funcall fx x y z)))
               (declare (veq:ff v))
               (setvoxel voxs x y z v)
               (when (> v maxv) (setf maxv v))
               (when (< v minv) (setf minv v)))))
          finally (progn (setf (voxels-maxv voxs) maxv
                               (voxels-minv voxs) minv)
                         (return voxs)))))

(defun get-mesh (wer voxs &key w (fx (lambda (v) (>= 0.0 v ))))
  (declare #.*opt* (voxels voxs) (boolean w) (function fx))
  "reconstruct mesh surounding (fx ...) == t."
  (let ((imap (-make-pos-vec 24))
        (voxellist (-make-pos-vec 24))
        (a (voxels-a voxs))
        (edge->vert (make-hash-table :test #'equal :size 1024 :rehash-size 2f0))
        (polys (list))
        (posfx (if w #'-get-pos-weighted #'-get-pos-mid)))
    (declare (pos-vec imap voxellist) (veq:fvec a) (hash-table edge->vert)
             (function posfx))
    (loop for ix of-type veq:pn from 0 to (voxels-nx voxs)
          do (loop for iy of-type veq:pn from 0 to (voxels-ny voxs)
                   do (loop for iz of-type veq:pn from 0 to (voxels-nz voxs)
                            do (-set-imap imap ix iy iz)
                               (let* ((cubeindex (-get-cubeindex a imap fx))
                                      (ec (aref *edges* cubeindex)))
                                 (declare (veq:pn ec cubeindex))
                                 (unless (or (= ec 0) (= ec 255))
                                   (-set-voxel-list voxellist ec)
                                   (loop for poly in
                                         (-add-polys a edge->vert imap voxellist
                                               cubeindex wer posfx)
                                         do (push poly polys)))))))
    polys))

