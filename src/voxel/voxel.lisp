
(in-package :voxel)

(declaim (inline -set-imap))
(defun -set-imap (imap ix iy iz)
  (declare #.*opt* (pos-vec imap) (pos-int ix iy iz))
  (loop for i of-type pos-int from 0 below 24 by 3
        do (setf (aref imap i) (+ ix (aref *offsets* i))
                 (aref imap (1+ i)) (+ iy (aref *offsets* (1+ i)))
                 (aref imap (+ i 2)) (+ iz (aref *offsets* (+ i 2))))))

(declaim (inline -get-cubeindex))
(defun -get-cubeindex (a imap lo hi)
  (declare #.*opt* (veq:fvec a) (pos-vec imap) (veq:ff lo hi))
  (loop with ind of-type pos-int = 0
        for i of-type pos-int from 0 below 24 by 3
        for b of-type pos-int from 0
        do (let ((va (aref a (aref imap i) (aref imap (1+ i))
                             (aref imap (+ i 2)))))
             (when (and  (>= hi va lo)) (incf ind (the pos-int (expt (abs 2) b)))))
        finally (return ind)))

(declaim (inline -set-voxel-list))
(defun -set-voxel-list (voxellist ec)
  (declare #.*opt* (pos-vec voxellist) (pos-int ec))
  (loop for i of-type pos-int from 0 below 12
        for k of-type pos-int from 0 by 2
        do (let ((pow (the pos-int (expt (abs 2) i))))
             (declare (pos-int pow))
             (when (= (logand ec pow) pow)
                   (setf (aref voxellist k) (aref *cubeind* k)
                         (aref voxellist (1+ k)) (aref *cubeind* (1+ k)))))))

(declaim (inline -do-global-edge))
(defun -do-global-edge (imap v &aux (3v (* 3 v)))
  (declare #.*opt* (pos-vec imap) (pos-int v 3v))
  (list (aref imap 3v) (aref imap (1+ 3v)) (aref imap (+ 3v 2))))

(declaim (inline -single-ind))
(defun -single-ind (v)
  (declare #.*opt* (list v))
  (veq:dsb (x y z) v
    (declare (pos-int x y z))
    (+ x (the pos-int
              (* *max-voxels*
                 (the pos-int (+ y (the pos-int (* *max-voxels* z)))))))))

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
  (weir:add-polygon! wer
    (loop for e of-type list in tri
          collect (let ((h (-hash-edge e)))
                    (declare (list h))
                    (veq:mvb (v exists) (gethash h edge->vert)
                      (declare (boolean exists))
                      (if exists v (setf (gethash h edge->vert)
                                         (weir:3add-vert! wer
                                           (veq:mvc (the function posfx) a e))))))
                  of-type pos-int)))

; (declaim (inline -make-poly))
(defun -make-poly (imap voxellist cubeindex i)
  (declare #.*opt* (pos-vec imap voxellist) (pos-int cubeindex i))
  (loop for k of-type pos-int from 0 below 3
        collect (let ((i2 (* 2 (aref *triangles* cubeindex (+ i k)))))
                  (declare (pos-int i2))
                  (list (-do-global-edge imap (aref voxellist i2))
                        (-do-global-edge imap (aref voxellist (1+ i2)))))
                of-type list))

; (declaim (inline -add-polys))
(defun -add-polys (a edge->vert imap voxellist cubeindex wer posfx)
  (declare #.*opt* (veq:fvec a) (pos-vec imap voxellist)
                   (pos-int cubeindex) (hash-table edge->vert))
  (loop for i of-type pos-int from 0 by 3
        until (= (aref *triangles* cubeindex i) 99)
        collect (-add-poly a edge->vert wer
                           (-make-poly imap voxellist cubeindex i)
                           posfx)))

(defun set-voxels (dims fx)
  (declare #.*opt* (list dims) (function fx))
  " dims = (list nx ny nz) "
  (veq:dsb (nx ny nz) dims
    (declare (pos-int nx ny nz))
    (loop with voxs = (make dims)
          with maxv = -99999f0
          with minv = 99999f0
          for x of-type pos-int from 0 below nx do
    (loop for y of-type pos-int from 0 below ny do
    (loop for z of-type pos-int from 0 below nz
          do (let ((v (funcall fx x y z)))
               (declare (veq:ff v))
               (setvoxel voxs x y z v)
               (when (> v maxv) (setf maxv v))
               (when (< v minv) (setf minv v)))))
          finally (progn (setf (voxels-maxv voxs) maxv
                               (voxels-minv voxs) minv)
                         (return voxs)))))

(defun get-mesh (wer voxs &key (lo -99999f0) (hi 99999f0) w)
  (declare #.*opt* (voxels voxs) (veq:ff lo hi) (boolean w))
  "reconstruct mesh at the isosurfaces of [low high] (inclusive)."
  (when (< hi lo) (error "bad hi ~a lo ~a" hi lo))
  (let ((imap (-make-pos-vec 24))
        (voxellist (-make-pos-vec 24))
        (a (voxels-a voxs))
        (edge->vert (make-hash-table :test #'equal :size 1024 :rehash-size 2f0))
        (polys (list))
        (posfx (if w #'-get-pos-weighted #'-get-pos-mid)))
    (declare (pos-vec imap voxellist) (veq:fvec a) (hash-table edge->vert)
             (function posfx))
    (loop for ix of-type pos-int from 0 to (voxels-nx voxs)
          do (loop for iy of-type pos-int from 0 to (voxels-ny voxs)
                   do (loop for iz of-type pos-int from 0 to (voxels-nz voxs)
                            do (-set-imap imap ix iy iz)
                               (let* ((cubeindex (-get-cubeindex a imap lo hi))
                                      (ec (aref *edges* cubeindex)))
                                 (declare (pos-int ec cubeindex))
                                 (unless (or (= ec 0) (= ec 255))
                                   (-set-voxel-list voxellist ec)
                                   (loop for poly in
                                         (-add-polys a edge->vert imap voxellist
                                               cubeindex wer posfx)
                                         do (push poly polys)))))))
    polys))

