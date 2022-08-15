#### VOXEL:GET-MESH

```
reconstruct mesh surounding (fx ...) == t.

 ; VOXEL:GET-MESH
 ;   [symbol]
 ; 
 ; GET-MESH names a compiled function:
 ;   Lambda-list: (WER VOXS &KEY W (FX (LAMBDA (V) (>= 0.0 V))))
 ;   Derived type: (FUNCTION
 ;                  (T VOXEL::VOXELS &KEY (:W BOOLEAN) (:FX FUNCTION))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     reconstruct mesh surounding (fx ...) == t.
 ;   Source file: /data/x/weird/src/voxel/voxel.lisp
```

#### VOXEL:GETVOXEL

```
:missing:todo:

 ; VOXEL:GETVOXEL
 ;   [symbol]
 ; 
 ; GETVOXEL names a compiled function:
 ;   Lambda-list: (VOXS IX IY IZ)
 ;   Derived type: (FUNCTION
 ;                  (VOXEL::VOXELS (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31)
 ;                   (UNSIGNED-BYTE 31))
 ;                  (VALUES SINGLE-FLOAT &OPTIONAL))
 ;   Source file: /data/x/weird/src/voxel/init.lisp
```

#### VOXEL:MAKE

```
:missing:todo:

 ; VOXEL:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (DIM)
 ;   Derived type: (FUNCTION (LIST) (VALUES VOXEL::VOXELS &OPTIONAL))
 ;   Source file: /data/x/weird/src/voxel/init.lisp
```

#### VOXEL:SETVOXEL

```
:missing:todo:

 ; VOXEL:SETVOXEL
 ;   [symbol]
 ; 
 ; SETVOXEL names a compiled function:
 ;   Lambda-list: (VOXS IX IY IZ &OPTIONAL (V 1.0))
 ;   Derived type: (FUNCTION
 ;                  (VOXEL::VOXELS (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31)
 ;                   (UNSIGNED-BYTE 31) &OPTIONAL SINGLE-FLOAT)
 ;                  (VALUES SINGLE-FLOAT &OPTIONAL))
 ;   Source file: /data/x/weird/src/voxel/init.lisp
```

