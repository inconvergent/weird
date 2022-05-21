#### WEIR:2$VERTS

```
:missing:todo:

 ; WEIR:2$VERTS
 ;   [symbol]
 ; 
 ; 2$VERTS names a macro:
 ;   Lambda-list: (WER &REST REST)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2ADD-PATH!

```
:missing:todo:

 ; WEIR:2ADD-PATH!
 ;   [symbol]
 ; 
 ; 2ADD-PATH! names a compiled function:
 ;   Lambda-list: (WER POINTS &KEY G CLOSED)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (SIMPLE-ARRAY SINGLE-FLOAT) &KEY (:G T)
 ;                   (:CLOSED T))
 ;                  *)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2ADD-VERT!

```
fx: %2ADD-VERT!
macro wrapper: 2ADD-VERT!

defined via veq:fvdef*

 ; WEIR:2ADD-VERT!
 ;   [symbol]
 ; 
 ; 2ADD-VERT! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2ADD-VERT!
 ;     macro wrapper: 2ADD-VERT!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2ADD-VERTS!

```
adds new vertices to weir. returns the ids of the new vertices

 ; WEIR:2ADD-VERTS!
 ;   [symbol]
 ; 
 ; 2ADD-VERTS! names a compiled function:
 ;   Lambda-list: (WER VV)
 ;   Derived type: (FUNCTION (WEIR::WEIR (SIMPLE-ARRAY SINGLE-FLOAT))
 ;                  (VALUES T (INTEGER 2 2) (UNSIGNED-BYTE 31) &OPTIONAL))
 ;   Documentation:
 ;     adds new vertices to weir. returns the ids of the new vertices
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2APPEND-EDGE!

```
fx: %2APPEND-EDGE!
macro wrapper: 2APPEND-EDGE!

defined via veq:fvdef*

 ; WEIR:2APPEND-EDGE!
 ;   [symbol]
 ; 
 ; 2APPEND-EDGE! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2APPEND-EDGE!
 ;     macro wrapper: 2APPEND-EDGE!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2AV!

```
:missing:todo:

 ; WEIR:2AV!
 ;   [symbol]
 ; 
 ; 2AV! names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2AVS!

```
:missing:todo:

 ; WEIR:2AVS!
 ;   [symbol]
 ; 
 ; 2AVS! names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2CUT-TO-AREA!

```
fx: %2CUT-TO-AREA!
macro wrapper: 2CUT-TO-AREA!

defined veq:vdef*

 ; WEIR:2CUT-TO-AREA!
 ;   [symbol]
 ; 
 ; 2CUT-TO-AREA! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2CUT-TO-AREA!
 ;     macro wrapper: 2CUT-TO-AREA!
 ;     
 ;     defined veq:vdef*
 ;   Source file: /data/x/weird/src/weir/extra.lisp
```

#### WEIR:2EDGE-LENGTH

```
returns the length of edge e=(u v). regardless of whether the edge exists

 ; WEIR:2EDGE-LENGTH
 ;   [symbol]
 ; 
 ; 2EDGE-LENGTH names a compiled function:
 ;   Lambda-list: (WER U V)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31))
 ;                  (VALUES (SINGLE-FLOAT 0.0) &OPTIONAL))
 ;   Documentation:
 ;     returns the length of edge e=(u v). regardless of whether the edge exists
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2GET-ALL-VERTS

```
returns the coordinates of all vertices

 ; WEIR:2GET-ALL-VERTS
 ;   [symbol]
 ; 
 ; 2GET-ALL-VERTS names a compiled function:
 ;   Lambda-list: (WER)
 ;   Derived type: (FUNCTION (WEIR::WEIR)
 ;                  (VALUES (SIMPLE-ARRAY SINGLE-FLOAT (*)) (INTEGER 2 2)
 ;                          (UNSIGNED-BYTE 31) &OPTIONAL))
 ;   Documentation:
 ;     returns the coordinates of all vertices
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2GET-GRP-VERTS

```
returns all vertices in grp g.
     note: verts only belong to a grp if they are part of an edge in grp.

 ; WEIR:2GET-GRP-VERTS
 ;   [symbol]
 ; 
 ; 2GET-GRP-VERTS names a compiled function:
 ;   Lambda-list: (WER &KEY G ORDER)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T) (:ORDER BOOLEAN)) *)
 ;   Documentation:
 ;     returns all vertices in grp g.
 ;          note: verts only belong to a grp if they are part of an edge in grp.
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2GET-PLANAR-CYCLES

```
:missing:todo:

 ; WEIR:2GET-PLANAR-CYCLES
 ;   [symbol]
 ; 
 ; 2GET-PLANAR-CYCLES names a compiled function:
 ;   Lambda-list: (WER &KEY CYCLE-INFO G &AUX (RES (LIST)))
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:CYCLE-INFO T) (:G T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/planar-cycles.lisp
```

#### WEIR:2GET-VERT

```
get the coordinate of vert v

 ; WEIR:2GET-VERT
 ;   [symbol]
 ; 
 ; 2GET-VERT names a compiled function:
 ;   Lambda-list: (WER V)
 ;   Derived type: (FUNCTION (WEIR::WEIR (UNSIGNED-BYTE 31))
 ;                  (VALUES SINGLE-FLOAT SINGLE-FLOAT &OPTIONAL))
 ;   Documentation:
 ;     get the coordinate of vert v
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2GET-VERTS

```
get the coordinates (vec) of verts in inds

 ; WEIR:2GET-VERTS
 ;   [symbol]
 ; 
 ; 2GET-VERTS names a compiled function:
 ;   Lambda-list: (WER INDS)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST) *)
 ;   Documentation:
 ;     get the coordinates (vec) of verts in inds
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2GRP-TRANSFORM!

```
:missing:todo:

 ; WEIR:2GRP-TRANSFORM!
 ;   [symbol]
 ; 
 ; 2GRP-TRANSFORM! names a compiled function:
 ;   Lambda-list: (WER TRANS &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR FUNCTION &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2GV

```
:missing:todo:

 ; WEIR:2GV
 ;   [symbol]
 ; 
 ; 2GV names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2GVS

```
:missing:todo:

 ; WEIR:2GVS
 ;   [symbol]
 ; 
 ; 2GVS names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2INTERSECT-ALL!

```
:missing:todo:

 ; WEIR:2INTERSECT-ALL!
 ;   [symbol]
 ; 
 ; 2INTERSECT-ALL! names a compiled function:
 ;   Lambda-list: (WER &KEY G PROP)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T) (:PROP T))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/paths.lisp
```

#### WEIR:2LEDGE-LENGTH

```
returns the length of edge e=(u v). regardless of whether the edge exists

 ; WEIR:2LEDGE-LENGTH
 ;   [symbol]
 ; 
 ; 2LEDGE-LENGTH names a compiled function:
 ;   Lambda-list: (WER E)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST)
 ;                  (VALUES (SINGLE-FLOAT 0.0) &OPTIONAL))
 ;   Documentation:
 ;     returns the length of edge e=(u v). regardless of whether the edge exists
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2LSPLIT-EDGE!

```
fx: %2LSPLIT-EDGE!
macro wrapper: 2LSPLIT-EDGE!

defined via veq:fvdef*

 ; WEIR:2LSPLIT-EDGE!
 ;   [symbol]
 ; 
 ; 2LSPLIT-EDGE! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2LSPLIT-EDGE!
 ;     macro wrapper: 2LSPLIT-EDGE!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2MOVE-VERT!

```
fx: %2MOVE-VERT!
macro wrapper: 2MOVE-VERT!

defined via veq:fvdef*

 ; WEIR:2MOVE-VERT!
 ;   [symbol]
 ; 
 ; 2MOVE-VERT! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2MOVE-VERT!
 ;     macro wrapper: 2MOVE-VERT!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2NN

```
fx: %2NN
macro wrapper: 2NN

defined via veq:fvdef*

 ; WEIR:2NN
 ;   [symbol]
 ; 
 ; 2NN names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2NN
 ;     macro wrapper: 2NN
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/kdtree.lisp
```

#### WEIR:2PRUNE-EDGES-BY-LEN!

```
remove edges longer than lim, use fx #'< to remove edges shorter than lim

 ; WEIR:2PRUNE-EDGES-BY-LEN!
 ;   [symbol]
 ; 
 ; 2PRUNE-EDGES-BY-LEN! names a compiled function:
 ;   Lambda-list: (WER LIM &OPTIONAL (PFX (FUNCTION >)))
 ;   Derived type: (FUNCTION (WEIR::WEIR SINGLE-FLOAT &OPTIONAL FUNCTION)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     remove edges longer than lim, use fx #'< to remove edges shorter than lim
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2RAD

```
fx: %2RAD
macro wrapper: 2RAD

defined via veq:fvdef*

 ; WEIR:2RAD
 ;   [symbol]
 ; 
 ; 2RAD names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2RAD
 ;     macro wrapper: 2RAD
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/kdtree.lisp
```

#### WEIR:2RELNEIGH!

```

  find the relative neigborhood graph (limited by the radius rad) of verts
  in wer. the graph is made in grp g.
  

 ; WEIR:2RELNEIGH!
 ;   [symbol]
 ; 
 ; 2RELNEIGH! names a compiled function:
 ;   Lambda-list: (WER RAD &KEY G (BUILD-KD T))
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR SINGLE-FLOAT &KEY (:G T)
 ;                   (:BUILD-KD BOOLEAN))
 ;                  (VALUES (UNSIGNED-BYTE 31) &OPTIONAL))
 ;   Documentation:
 ;     
 ;       find the relative neigborhood graph (limited by the radius rad) of verts
 ;       in wer. the graph is made in grp g.
 ; 
 ;   Source file: /data/x/weird/src/weir/relneigh.lisp
```

#### WEIR:2SIMPLIFY-SEGMENTS!

```
:missing:todo:

 ; WEIR:2SIMPLIFY-SEGMENTS!
 ;   [symbol]
 ; 
 ; 2SIMPLIFY-SEGMENTS! names a compiled function:
 ;   Lambda-list: (WER &KEY G (LIM 0.1))
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T) (:LIM SINGLE-FLOAT))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/paths.lisp
```

#### WEIR:2SPLIT-EDGE!

```
fx: %2SPLIT-EDGE!
macro wrapper: 2SPLIT-EDGE!

defined via veq:fvdef*

 ; WEIR:2SPLIT-EDGE!
 ;   [symbol]
 ; 
 ; 2SPLIT-EDGE! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2SPLIT-EDGE!
 ;     macro wrapper: 2SPLIT-EDGE!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2TRANSFORM!

```
:missing:todo:

 ; WEIR:2TRANSFORM!
 ;   [symbol]
 ; 
 ; 2TRANSFORM! names a compiled function:
 ;   Lambda-list: (WER INDS TFX)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST FUNCTION)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2VADD-EDGE!

```
fx: %2VADD-EDGE!
macro wrapper: 2VADD-EDGE!

defined via veq:fvdef*

 ; WEIR:2VADD-EDGE!
 ;   [symbol]
 ; 
 ; 2VADD-EDGE! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %2VADD-EDGE!
 ;     macro wrapper: 2VADD-EDGE!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:2WALK-GRAPH

```
:missing:todo:

 ; WEIR:2WALK-GRAPH
 ;   [symbol]
 ; 
 ; 2WALK-GRAPH names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (T &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/paths.lisp
```

#### WEIR:3$VERTS

```
:missing:todo:

 ; WEIR:3$VERTS
 ;   [symbol]
 ; 
 ; 3$VERTS names a macro:
 ;   Lambda-list: (WER &REST REST)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3->2

```
:missing:todo:

 ; WEIR:3->2
 ;   [symbol]
 ; 
 ; 3->2 names a compiled function:
 ;   Lambda-list: (WER FX &KEY NEW)
 ;   Derived type: (FUNCTION (WEIR::WEIR FUNCTION &KEY (:NEW T))
 ;                  (VALUES WEIR::WEIR &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/extra.lisp
```

#### WEIR:3ADD-BOX!

```
add a box with size, s = (sx sy sz) at xy = (x y z)

 ; WEIR:3ADD-BOX!
 ;   [symbol]
 ; 
 ; 3ADD-BOX! names a compiled function:
 ;   Lambda-list: (WER &KEY
 ;                 (S
 ;                  (NREP 3
 ;                    100.0))
 ;                 (XY
 ;                  (NREP 3
 ;                    0.0))
 ;                 G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:S LIST) (:XY LIST) (:G T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     add a box with size, s = (sx sy sz) at xy = (x y z)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3ADD-CUBE!

```
:missing:todo:

 ; WEIR:3ADD-CUBE!
 ;   [symbol]
 ; 
 ; 3ADD-CUBE! names a compiled function:
 ;   Lambda-list: (WER &KEY (S 1.0)
 ;                 (XY
 ;                  (NREP 3
 ;                    0.0))
 ;                 G)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR &KEY (:S SINGLE-FLOAT) (:XY LIST) (:G T))
 ;                  *)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3ADD-PATH!

```
:missing:todo:

 ; WEIR:3ADD-PATH!
 ;   [symbol]
 ; 
 ; 3ADD-PATH! names a compiled function:
 ;   Lambda-list: (WER POINTS &KEY G CLOSED)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (SIMPLE-ARRAY SINGLE-FLOAT) &KEY (:G T)
 ;                   (:CLOSED T))
 ;                  *)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3ADD-VERT!

```
fx: %3ADD-VERT!
macro wrapper: 3ADD-VERT!

defined via veq:fvdef*

 ; WEIR:3ADD-VERT!
 ;   [symbol]
 ; 
 ; 3ADD-VERT! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %3ADD-VERT!
 ;     macro wrapper: 3ADD-VERT!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3ADD-VERTS!

```
adds new vertices to weir. returns the ids of the new vertices

 ; WEIR:3ADD-VERTS!
 ;   [symbol]
 ; 
 ; 3ADD-VERTS! names a compiled function:
 ;   Lambda-list: (WER VV)
 ;   Derived type: (FUNCTION (WEIR::WEIR (SIMPLE-ARRAY SINGLE-FLOAT))
 ;                  (VALUES T (INTEGER 3 3) (UNSIGNED-BYTE 31) &OPTIONAL))
 ;   Documentation:
 ;     adds new vertices to weir. returns the ids of the new vertices
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3APPEND-EDGE!

```
fx: %3APPEND-EDGE!
macro wrapper: 3APPEND-EDGE!

defined via veq:fvdef*

 ; WEIR:3APPEND-EDGE!
 ;   [symbol]
 ; 
 ; 3APPEND-EDGE! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %3APPEND-EDGE!
 ;     macro wrapper: 3APPEND-EDGE!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3AV!

```
:missing:todo:

 ; WEIR:3AV!
 ;   [symbol]
 ; 
 ; 3AV! names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3AVS!

```
:missing:todo:

 ; WEIR:3AVS!
 ;   [symbol]
 ; 
 ; 3AVS! names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3EDGE-LENGTH

```
returns the length of edge e=(u v). regardless of whether the edge exists

 ; WEIR:3EDGE-LENGTH
 ;   [symbol]
 ; 
 ; 3EDGE-LENGTH names a compiled function:
 ;   Lambda-list: (WER U V)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31))
 ;                  (VALUES (SINGLE-FLOAT 0.0) &OPTIONAL))
 ;   Documentation:
 ;     returns the length of edge e=(u v). regardless of whether the edge exists
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3GET-ALL-VERTS

```
returns the coordinates of all vertices

 ; WEIR:3GET-ALL-VERTS
 ;   [symbol]
 ; 
 ; 3GET-ALL-VERTS names a compiled function:
 ;   Lambda-list: (WER)
 ;   Derived type: (FUNCTION (WEIR::WEIR)
 ;                  (VALUES (SIMPLE-ARRAY SINGLE-FLOAT (*)) (INTEGER 3 3)
 ;                          (UNSIGNED-BYTE 31) &OPTIONAL))
 ;   Documentation:
 ;     returns the coordinates of all vertices
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3GET-GRP-VERTS

```
returns all vertices in grp g.
     note: verts only belong to a grp if they are part of an edge in grp.

 ; WEIR:3GET-GRP-VERTS
 ;   [symbol]
 ; 
 ; 3GET-GRP-VERTS names a compiled function:
 ;   Lambda-list: (WER &KEY G ORDER)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T) (:ORDER BOOLEAN)) *)
 ;   Documentation:
 ;     returns all vertices in grp g.
 ;          note: verts only belong to a grp if they are part of an edge in grp.
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3GET-VERT

```
get the coordinate of vert v

 ; WEIR:3GET-VERT
 ;   [symbol]
 ; 
 ; 3GET-VERT names a compiled function:
 ;   Lambda-list: (WER V)
 ;   Derived type: (FUNCTION (WEIR::WEIR (UNSIGNED-BYTE 31))
 ;                  (VALUES SINGLE-FLOAT SINGLE-FLOAT SINGLE-FLOAT
 ;                          &OPTIONAL))
 ;   Documentation:
 ;     get the coordinate of vert v
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3GET-VERTS

```
get the coordinates (vec) of verts in inds

 ; WEIR:3GET-VERTS
 ;   [symbol]
 ; 
 ; 3GET-VERTS names a compiled function:
 ;   Lambda-list: (WER INDS)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST) *)
 ;   Documentation:
 ;     get the coordinates (vec) of verts in inds
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3GRP-TRANSFORM!

```
:missing:todo:

 ; WEIR:3GRP-TRANSFORM!
 ;   [symbol]
 ; 
 ; 3GRP-TRANSFORM! names a compiled function:
 ;   Lambda-list: (WER TRANS &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR FUNCTION &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3GV

```
:missing:todo:

 ; WEIR:3GV
 ;   [symbol]
 ; 
 ; 3GV names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3GVS

```
:missing:todo:

 ; WEIR:3GVS
 ;   [symbol]
 ; 
 ; 3GVS names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3LEDGE-LENGTH

```
returns the length of edge e=(u v). regardless of whether the edge exists

 ; WEIR:3LEDGE-LENGTH
 ;   [symbol]
 ; 
 ; 3LEDGE-LENGTH names a compiled function:
 ;   Lambda-list: (WER E)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST)
 ;                  (VALUES (SINGLE-FLOAT 0.0) &OPTIONAL))
 ;   Documentation:
 ;     returns the length of edge e=(u v). regardless of whether the edge exists
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3LSPLIT-EDGE!

```
fx: %3LSPLIT-EDGE!
macro wrapper: 3LSPLIT-EDGE!

defined via veq:fvdef*

 ; WEIR:3LSPLIT-EDGE!
 ;   [symbol]
 ; 
 ; 3LSPLIT-EDGE! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %3LSPLIT-EDGE!
 ;     macro wrapper: 3LSPLIT-EDGE!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3MOVE-VERT!

```
fx: %3MOVE-VERT!
macro wrapper: 3MOVE-VERT!

defined via veq:fvdef*

 ; WEIR:3MOVE-VERT!
 ;   [symbol]
 ; 
 ; 3MOVE-VERT! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %3MOVE-VERT!
 ;     macro wrapper: 3MOVE-VERT!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3PRUNE-EDGES-BY-LEN!

```
remove edges longer than lim, use fx #'< to remove edges shorter than lim

 ; WEIR:3PRUNE-EDGES-BY-LEN!
 ;   [symbol]
 ; 
 ; 3PRUNE-EDGES-BY-LEN! names a compiled function:
 ;   Lambda-list: (WER LIM &OPTIONAL (PFX (FUNCTION >)))
 ;   Derived type: (FUNCTION (WEIR::WEIR SINGLE-FLOAT &OPTIONAL FUNCTION)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     remove edges longer than lim, use fx #'< to remove edges shorter than lim
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3SPLIT-EDGE!

```
fx: %3SPLIT-EDGE!
macro wrapper: 3SPLIT-EDGE!

defined via veq:fvdef*

 ; WEIR:3SPLIT-EDGE!
 ;   [symbol]
 ; 
 ; 3SPLIT-EDGE! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %3SPLIT-EDGE!
 ;     macro wrapper: 3SPLIT-EDGE!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3TRANSFORM!

```
:missing:todo:

 ; WEIR:3TRANSFORM!
 ;   [symbol]
 ; 
 ; 3TRANSFORM! names a compiled function:
 ;   Lambda-list: (WER INDS TFX)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST FUNCTION)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:3TRIANGULATE!

```
:missing:todo:

 ; WEIR:3TRIANGULATE!
 ;   [symbol]
```

#### WEIR:3VADD-EDGE!

```
fx: %3VADD-EDGE!
macro wrapper: 3VADD-EDGE!

defined via veq:fvdef*

 ; WEIR:3VADD-EDGE!
 ;   [symbol]
 ; 
 ; 3VADD-EDGE! names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %3VADD-EDGE!
 ;     macro wrapper: 3VADD-EDGE!
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:ADD-EDGE!

```

  adds a new edge to weir. provided the edge is valid.
  otherwise it returns nil.

  returns nil if the edge exists already.
  

 ; WEIR:ADD-EDGE!
 ;   [symbol]
 ; 
 ; ADD-EDGE! names a compiled function:
 ;   Lambda-list: (WER A B &KEY G)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) &KEY
 ;                   (:G T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     
 ;       adds a new edge to weir. provided the edge is valid.
 ;       otherwise it returns nil.
 ;     
 ;       returns nil if the edge exists already.
 ; 
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:ADD-EDGES!

```
adds multiple edges (see above). returns a list of the results.

 ; WEIR:ADD-EDGES!
 ;   [symbol]
 ; 
 ; ADD-EDGES! names a compiled function:
 ;   Lambda-list: (WER EE &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     adds multiple edges (see above). returns a list of the results.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:ADD-GRP!

```

  constructor for grp instances.

  grps contain edge adjacency graphs as well as polygons.

  nil is the default grp. as such, nil is not an allowed grp name (there is
  always a default grp named nil). if name is nil, the name will be a gensym.

  edges can be associated with multiple grps.

  verts are global. that is, they do not belong to any grp on their own.
  however, if a vert is associated with an edge, that vert is also associated
  with whatever grp that edge belongs to.

    - to get verts in a grp: (get-grp-verts wer :g g).
    - to get indices of verts (in a grp): (get-vert-inds wer :g g)
    - ...
  

 ; WEIR:ADD-GRP!
 ;   [symbol]
 ; 
 ; ADD-GRP! names a compiled function:
 ;   Lambda-list: (WER &KEY NAME &AUX
 ;                 (NAME*
 ;                  (IF NAME
 ;                      NAME
 ;                      (GENSYM GRP))))
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:NAME T))
 ;                  (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     
 ;       constructor for grp instances.
 ;     
 ;       grps contain edge adjacency graphs as well as polygons.
 ;     
 ;       nil is the default grp. as such, nil is not an allowed grp name (there is
 ;       always a default grp named nil). if name is nil, the name will be a gensym.
 ;     
 ;       edges can be associated with multiple grps.
 ;     
 ;       verts are global. that is, they do not belong to any grp on their own.
 ;       however, if a vert is associated with an edge, that vert is also associated
 ;       with whatever grp that edge belongs to.
 ;     
 ;         - to get verts in a grp: (get-grp-verts wer :g g).
 ;         - to get indices of verts (in a grp): (get-vert-inds wer :g g)
 ;         - ...
 ; 
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:ADD-PATH-IND!

```
create edges of path

 ; WEIR:ADD-PATH-IND!
 ;   [symbol]
 ; 
 ; ADD-PATH-IND! names a compiled function:
 ;   Lambda-list: (WER PATH &KEY G CLOSED)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR LIST &KEY (:G T) (:CLOSED BOOLEAN))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     create edges of path
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:ADD-POLYGON!

```
:missing:todo:

 ; WEIR:ADD-POLYGON!
 ;   [symbol]
 ; 
 ; ADD-POLYGON! names a compiled function:
 ;   Lambda-list: (WER POLY &KEY G &AUX (POLY (-SORT-POLYGON POLY)))
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:ADD-POLYGONS!

```
:missing:todo:

 ; WEIR:ADD-POLYGONS!
 ;   [symbol]
 ; 
 ; ADD-POLYGONS! names a compiled function:
 ;   Lambda-list: (WER PP &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:AE!

```
:missing:todo:

 ; WEIR:AE!
 ;   [symbol]
 ; 
 ; AE! names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:ALL-GRPS->MAIN!

```
copy all edges in all grps into main grp

 ; WEIR:ALL-GRPS->MAIN!
 ;   [symbol]
 ; 
 ; ALL-GRPS->MAIN! names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (T &KEY (:G T)) (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     copy all edges in all grps into main grp
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:APPEND-EDGE!

```
:missing:todo:

 ; WEIR:APPEND-EDGE!
 ;   [symbol]
```

#### WEIR:BUILD-KDTREE

```
:missing:todo:

 ; WEIR:BUILD-KDTREE
 ;   [symbol]
 ; 
 ; BUILD-KDTREE names a compiled function:
 ;   Lambda-list: (WER)
 ;   Derived type: (FUNCTION (WEIR::WEIR) (VALUES WEIR::KDTREE &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/kdtree.lisp
```

#### WEIR:CENTER!

```
center the verts of wer on xy. returns the previous center

 ; WEIR:CENTER!
 ;   [symbol]
 ; 
 ; CENTER! names a compiled function:
 ;   Lambda-list: (WER &KEY MAX-SIDE NON-EDGE G)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR &KEY (:MAX-SIDE T) (:NON-EDGE T) (:G T))
 ;                  (VALUES SINGLE-FLOAT SINGLE-FLOAT SINGLE-FLOAT
 ;                          SINGLE-FLOAT SINGLE-FLOAT &OPTIONAL))
 ;   Documentation:
 ;     center the verts of wer on xy. returns the previous center
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:CLEAR!

```
clear values of weir instance. unless keep is set for a given property

 ; WEIR:CLEAR!
 ;   [symbol]
 ; 
 ; CLEAR! names a compiled function:
 ;   Lambda-list: (WER &KEY KEEP-PROPS KEEP-VERTS KEEP-GRPS)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR &KEY (:KEEP-PROPS BOOLEAN)
 ;                   (:KEEP-VERTS BOOLEAN) (:KEEP-GRPS BOOLEAN))
 ;                  (VALUES WEIR::WEIR &OPTIONAL))
 ;   Documentation:
 ;     clear values of weir instance. unless keep is set for a given property
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:CLEAR-PROP

```
clear all props from item/key (edge, grp, vert, poly)

 ; WEIR:CLEAR-PROP
 ;   [symbol]
 ; 
 ; CLEAR-PROP names a compiled function:
 ;   Lambda-list: (WER KEY)
 ;   Derived type: (FUNCTION (WEIR::WEIR T) (VALUES BOOLEAN &OPTIONAL))
 ;   Documentation:
 ;     clear all props from item/key (edge, grp, vert, poly)
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:CLEAR-SPECIFIC-PROP

```
remove prop from every item (vert, edge, grp, poly).

 ; WEIR:CLEAR-SPECIFIC-PROP
 ;   [symbol]
 ; 
 ; CLEAR-SPECIFIC-PROP names a compiled function:
 ;   Lambda-list: (WER PROP)
 ;   Derived type: (FUNCTION (WEIR::WEIR SYMBOL) (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     remove prop from every item (vert, edge, grp, poly).
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:CLEAR-SPECIFIC-PROPS

```
:missing:todo:

 ; WEIR:CLEAR-SPECIFIC-PROPS
 ;   [symbol]
 ; 
 ; CLEAR-SPECIFIC-PROPS names a compiled function:
 ;   Lambda-list: (WER PROPS)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST) (VALUES NULL &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:CLONE-GRP!

```
clone grp, g. if target grp does not exist it will be created.

 ; WEIR:CLONE-GRP!
 ;   [symbol]
 ; 
 ; CLONE-GRP! names a compiled function:
 ;   Lambda-list: (WER &KEY FROM TO)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:FROM T) (:TO T))
 ;                  (VALUES WEIR::GRP &OPTIONAL))
 ;   Documentation:
 ;     clone grp, g. if target grp does not exist it will be created.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:COLLAPSE-VERTS!

```
move all incident edges of v to u. returns the moved verts.

 ; WEIR:COLLAPSE-VERTS!
 ;   [symbol]
 ; 
 ; COLLAPSE-VERTS! names a compiled function:
 ;   Lambda-list: (WER U V &KEY G)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) &KEY
 ;                   (:G T))
 ;                  (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     move all incident edges of v to u. returns the moved verts.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:COPY-EDGE-PROPS

```
copy props from to. use clear to clear prosp from to first.

 ; WEIR:COPY-EDGE-PROPS
 ;   [symbol]
 ; 
 ; COPY-EDGE-PROPS names a compiled function:
 ;   Lambda-list: (WER FROM TO &KEY CLEAR)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST LIST &KEY (:CLEAR T))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     copy props from to. use clear to clear prosp from to first.
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:COPY-VERT-PROPS

```
copy props from to. use clear to clear props from to first.

 ; WEIR:COPY-VERT-PROPS
 ;   [symbol]
 ; 
 ; COPY-VERT-PROPS names a compiled function:
 ;   Lambda-list: (WER FROM TO &KEY CLEAR)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) &KEY
 ;                   (:CLEAR T))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     copy props from to. use clear to clear props from to first.
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:DE!

```
:missing:todo:

 ; WEIR:DE!
 ;   [symbol]
 ; 
 ; DE! names a macro:
 ;   Lambda-list: (&REST ARGS)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:DEL-EDGE!

```
:missing:todo:

 ; WEIR:DEL-EDGE!
 ;   [symbol]
 ; 
 ; DEL-EDGE! names a compiled function:
 ;   Lambda-list: (WER A B &KEY G)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) &KEY
 ;                   (:G T))
 ;                  *)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:DEL-GRP!

```
:missing:todo:

 ; WEIR:DEL-GRP!
 ;   [symbol]
 ; 
 ; DEL-GRP! names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (T &KEY (:G SYMBOL))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:DEL-PATH!

```
del all edges in path

 ; WEIR:DEL-PATH!
 ;   [symbol]
 ; 
 ; DEL-PATH! names a compiled function:
 ;   Lambda-list: (WER PATH &KEY G CLOSED)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR LIST &KEY (:G T) (:CLOSED BOOLEAN))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     del all edges in path
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:DEL-POLYGON!

```
:missing:todo:

 ; WEIR:DEL-POLYGON!
 ;   [symbol]
 ; 
 ; DEL-POLYGON! names a compiled function:
 ;   Lambda-list: (WER POLY &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:DEL-POLYGONS!

```
:missing:todo:

 ; WEIR:DEL-POLYGONS!
 ;   [symbol]
 ; 
 ; DEL-POLYGONS! names a compiled function:
 ;   Lambda-list: (WER POLYS &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:EDGE-EXISTS

```
t if edge exists (in g).

 ; WEIR:EDGE-EXISTS
 ;   [symbol]
 ; 
 ; EDGE-EXISTS names a compiled function:
 ;   Lambda-list: (WER EE &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T)) *)
 ;   Documentation:
 ;     t if edge exists (in g).
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:EDGE-HAS-PROP

```
t if edge e has prop (and val)

 ; WEIR:EDGE-HAS-PROP
 ;   [symbol]
 ; 
 ; EDGE-HAS-PROP names a compiled function:
 ;   Lambda-list: (WER E PROP &KEY VAL)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST SYMBOL &KEY (:VAL T))
 ;                  (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     t if edge e has prop (and val)
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:EDGE-PROP->PATH

```
get edges with prop as path. returns (values path cycle

 ; WEIR:EDGE-PROP->PATH
 ;   [symbol]
 ; 
 ; EDGE-PROP->PATH names a compiled function:
 ;   Lambda-list: (WER PROP &KEY VAL G)
 ;   Derived type: (FUNCTION (WEIR::WEIR SYMBOL &KEY (:VAL T) (:G T)) *)
 ;   Documentation:
 ;     get edges with prop as path. returns (values path cycle
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:EDGE-PROP-NXT-VERT

```
get first (encountered) incident vert w from v, with prop (and val).
   ignores w when w == except.
   returns nil if there is no incident vert.

 ; WEIR:EDGE-PROP-NXT-VERT
 ;   [symbol]
 ; 
 ; EDGE-PROP-NXT-VERT names a compiled function:
 ;   Lambda-list: (WER V PROP &KEY VAL (EXCEPT -1) G)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR FIXNUM SYMBOL &KEY (:VAL T)
 ;                   (:EXCEPT FIXNUM) (:G T))
 ;                  (VALUES (OR NULL FIXNUM) &OPTIONAL))
 ;   Documentation:
 ;     get first (encountered) incident vert w from v, with prop (and val).
 ;        ignores w when w == except.
 ;        returns nil if there is no incident vert.
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:EXPORT-VERTS-GRP

```
:missing:todo:

 ; WEIR:EXPORT-VERTS-GRP
 ;   [symbol]
```

#### WEIR:GET-ALL-GRPS

```
returns all grp names. use :main t to include main/nil grp.

 ; WEIR:GET-ALL-GRPS
 ;   [symbol]
 ; 
 ; GET-ALL-GRPS names a compiled function:
 ;   Lambda-list: (WER &KEY MAIN)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:MAIN BOOLEAN))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     returns all grp names. use :main t to include main/nil grp.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-ALL-POLYGONS

```
:missing:todo:

 ; WEIR:GET-ALL-POLYGONS
 ;   [symbol]
 ; 
 ; GET-ALL-POLYGONS names a compiled function:
 ;   Lambda-list: (WER &KEY G EXTRA)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T) (:EXTRA T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:GET-ALT-RES

```
:missing:todo:

 ; WEIR:GET-ALT-RES
 ;   [symbol]
 ; 
 ; GET-ALT-RES names a compiled function:
 ;   Lambda-list: (WER RES)
 ;   Derived type: (FUNCTION (WEIR::WEIR SYMBOL)
 ;                  (VALUES T BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/alteration-utils.lisp
```

#### WEIR:GET-ALTERATION-RESULT-LIST

```
returns alist with tuples of alteration :res and corresponding value.

 ; WEIR:GET-ALTERATION-RESULT-LIST
 ;   [symbol]
 ; 
 ; GET-ALTERATION-RESULT-LIST names a compiled function:
 ;   Lambda-list: (WER &KEY (ALL T))
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:ALL BOOLEAN))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     returns alist with tuples of alteration :res and corresponding value.
 ;   Source file: /data/x/weird/src/weir/alteration-utils.lisp
```

#### WEIR:GET-ALTERATION-RESULT-MAP

```
returns hash-table with results of all alterations by :res.

 ; WEIR:GET-ALTERATION-RESULT-MAP
 ;   [symbol]
 ; 
 ; GET-ALTERATION-RESULT-MAP names a compiled function:
 ;   Lambda-list: (WER)
 ;   Derived type: (FUNCTION (WEIR::WEIR) (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     returns hash-table with results of all alterations by :res.
 ;   Source file: /data/x/weird/src/weir/alteration-utils.lisp
```

#### WEIR:GET-CONNECTED-VERTS

```
get verts in g with at least one connected edge.

 ; WEIR:GET-CONNECTED-VERTS
 ;   [symbol]
 ; 
 ; GET-CONNECTED-VERTS names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T)) *)
 ;   Documentation:
 ;     get verts in g with at least one connected edge.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-EDGE-POLYGONS

```
:missing:todo:

 ; WEIR:GET-EDGE-POLYGONS
 ;   [symbol]
 ; 
 ; GET-EDGE-POLYGONS names a compiled function:
 ;   Lambda-list: (WER EDGE &KEY G &AUX (EDGE (-SORT-LIST EDGE)))
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:GET-EDGE-PROP

```
get prop ov edge e

 ; WEIR:GET-EDGE-PROP
 ;   [symbol]
 ; 
 ; GET-EDGE-PROP names a compiled function:
 ;   Lambda-list: (WER E PROP &KEY DEFAULT)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST SYMBOL &KEY (:DEFAULT T)) *)
 ;   Documentation:
 ;     get prop ov edge e
 ;   Source file: /data/x/weird/src/weir/props.lisp
 ; 
 ; (SETF GET-EDGE-PROP) has setf-expansion: WEIR:SET-EDGE-PROP
```

#### WEIR:GET-EDGE-PROPS

```
:missing:todo:

 ; WEIR:GET-EDGE-PROPS
 ;   [symbol]
 ; 
 ; GET-EDGE-PROPS names a compiled function:
 ;   Lambda-list: (WER E)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST)
 ;                  (VALUES T BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:GET-EDGES

```
:missing:todo:

 ; WEIR:GET-EDGES
 ;   [symbol]
 ; 
 ; GET-EDGES names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-EDGES-WITH-PROP

```
find edges with prop (and val)

 ; WEIR:GET-EDGES-WITH-PROP
 ;   [symbol]
 ; 
 ; GET-EDGES-WITH-PROP names a compiled function:
 ;   Lambda-list: (WER PROP &KEY VAL G &AUX (RES (LIST)))
 ;   Derived type: (FUNCTION (WEIR::WEIR SYMBOL &KEY (:VAL T) (:G T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     find edges with prop (and val)
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:GET-GRP

```
returns the grp g. defaults to the main/nil grp.

 ; WEIR:GET-GRP
 ;   [symbol]
 ; 
 ; GET-GRP names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T))
 ;                  (VALUES T BOOLEAN &OPTIONAL))
 ;   Documentation:
 ;     returns the grp g. defaults to the main/nil grp.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-GRP-AS-PATH

```
returns (values path cycle?)

 ; WEIR:GET-GRP-AS-PATH
 ;   [symbol]
 ; 
 ; GET-GRP-AS-PATH names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T)) *)
 ;   Documentation:
 ;     returns (values path cycle?)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-GRP-NUM-VERTS

```
:missing:todo:

 ; WEIR:GET-GRP-NUM-VERTS
 ;   [symbol]
 ; 
 ; GET-GRP-NUM-VERTS names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-GRP-PROP

```
get prop of grp g

 ; WEIR:GET-GRP-PROP
 ;   [symbol]
 ; 
 ; GET-GRP-PROP names a compiled function:
 ;   Lambda-list: (WER G PROP &KEY DEFAULT)
 ;   Derived type: (FUNCTION (WEIR::WEIR SYMBOL SYMBOL &KEY (:DEFAULT T))
 ;                  *)
 ;   Documentation:
 ;     get prop of grp g
 ;   Source file: /data/x/weird/src/weir/props.lisp
 ; 
 ; (SETF GET-GRP-PROP) has setf-expansion: WEIR:SET-GRP-PROP
```

#### WEIR:GET-GRP-VERTS

```
:missing:todo:

 ; WEIR:GET-GRP-VERTS
 ;   [symbol]
```

#### WEIR:GET-INCIDENT-EDGES

```
get incident edges of v.

 ; WEIR:GET-INCIDENT-EDGES
 ;   [symbol]
 ; 
 ; GET-INCIDENT-EDGES names a compiled function:
 ;   Lambda-list: (WER V &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR (UNSIGNED-BYTE 31) &KEY (:G T)) *)
 ;   Documentation:
 ;     get incident edges of v.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-INCIDENT-ROTATED-VERT

```
:missing:todo:

 ; WEIR:GET-INCIDENT-ROTATED-VERT
 ;   [symbol]
```

#### WEIR:GET-INCIDENT-VERTS

```
get incident verts of v.

 ; WEIR:GET-INCIDENT-VERTS
 ;   [symbol]
 ; 
 ; GET-INCIDENT-VERTS names a compiled function:
 ;   Lambda-list: (WER V &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR (UNSIGNED-BYTE 31) &KEY (:G T)) *)
 ;   Documentation:
 ;     get incident verts of v.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-MIN-SPANNING-TREE

```
:missing:todo:

 ; WEIR:GET-MIN-SPANNING-TREE
 ;   [symbol]
 ; 
 ; GET-MIN-SPANNING-TREE names a compiled function:
 ;   Lambda-list: (WER &KEY G EDGES START)
 ;   Derived type: (FUNCTION (T &KEY (:G T) (:EDGES T) (:START T)) *)
 ;   Source file: /data/x/weird/src/weir/paths.lisp
```

#### WEIR:GET-NUM-EDGES

```
:missing:todo:

 ; WEIR:GET-NUM-EDGES
 ;   [symbol]
 ; 
 ; GET-NUM-EDGES names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-NUM-GRPS

```
number of grps.

 ; WEIR:GET-NUM-GRPS
 ;   [symbol]
 ; 
 ; GET-NUM-GRPS names a compiled function:
 ;   Lambda-list: (WER)
 ;   Derived type: (FUNCTION (WEIR::WEIR)
 ;                  (VALUES (MOD 4611686018427387901) &OPTIONAL))
 ;   Documentation:
 ;     number of grps.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-NUM-POLYGONS

```
:missing:todo:

 ; WEIR:GET-NUM-POLYGONS
 ;   [symbol]
 ; 
 ; GET-NUM-POLYGONS names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T))
 ;                  (VALUES (MOD 4611686018427387901) &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:GET-NUM-VERTS

```
:missing:todo:

 ; WEIR:GET-NUM-VERTS
 ;   [symbol]
 ; 
 ; GET-NUM-VERTS names a compiled function:
 ;   Lambda-list: (WER)
 ;   Derived type: (FUNCTION (WEIR::WEIR)
 ;                  (VALUES (UNSIGNED-BYTE 31) &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-POLY-PROP

```
get prop ov poly e

 ; WEIR:GET-POLY-PROP
 ;   [symbol]
 ; 
 ; GET-POLY-PROP names a compiled function:
 ;   Lambda-list: (WER E PROP &KEY DEFAULT)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST SYMBOL &KEY (:DEFAULT T)) *)
 ;   Documentation:
 ;     get prop ov poly e
 ;   Source file: /data/x/weird/src/weir/props.lisp
 ; 
 ; (SETF GET-POLY-PROP) has setf-expansion: WEIR:SET-POLY-PROP
```

#### WEIR:GET-POLYGON-EDGES

```
:missing:todo:

 ; WEIR:GET-POLYGON-EDGES
 ;   [symbol]
 ; 
 ; GET-POLYGON-EDGES names a compiled function:
 ;   Lambda-list: (WER POLY &KEY G &AUX (POLY (-SORT-POLYGON POLY)))
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:GET-SEGMENTS

```
:missing:todo:

 ; WEIR:GET-SEGMENTS
 ;   [symbol]
 ; 
 ; GET-SEGMENTS names a compiled function:
 ;   Lambda-list: (WER &KEY CYCLE-INFO G)
 ;   Derived type: (FUNCTION (T &KEY (:CYCLE-INFO T) (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/paths.lisp
```

#### WEIR:GET-SPANNING-TREE

```
:missing:todo:

 ; WEIR:GET-SPANNING-TREE
 ;   [symbol]
 ; 
 ; GET-SPANNING-TREE names a compiled function:
 ;   Lambda-list: (WER &KEY G EDGES START)
 ;   Derived type: (FUNCTION (T &KEY (:G T) (:EDGES T) (:START T)) *)
 ;   Source file: /data/x/weird/src/weir/paths.lisp
```

#### WEIR:GET-VERT-INDS

```

  returns all vertex indices that belongs to a grp.
  note: verts only belong to a grp if they are part of an edge in grp.
  

 ; WEIR:GET-VERT-INDS
 ;   [symbol]
 ; 
 ; GET-VERT-INDS names a compiled function:
 ;   Lambda-list: (WER &KEY G ORDER)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T) (:ORDER BOOLEAN)) *)
 ;   Documentation:
 ;     
 ;       returns all vertex indices that belongs to a grp.
 ;       note: verts only belong to a grp if they are part of an edge in grp.
 ; 
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:GET-VERT-PROP

```
get prop of vert v

 ; WEIR:GET-VERT-PROP
 ;   [symbol]
 ; 
 ; GET-VERT-PROP names a compiled function:
 ;   Lambda-list: (WER V PROP &KEY DEFAULT)
 ;   Derived type: (FUNCTION (WEIR::WEIR FIXNUM SYMBOL &KEY (:DEFAULT T))
 ;                  *)
 ;   Documentation:
 ;     get prop of vert v
 ;   Source file: /data/x/weird/src/weir/props.lisp
 ; 
 ; (SETF GET-VERT-PROP) has setf-expansion: WEIR:SET-VERT-PROP
```

#### WEIR:GET-VERT-PROPS

```
:missing:todo:

 ; WEIR:GET-VERT-PROPS
 ;   [symbol]
 ; 
 ; GET-VERT-PROPS names a compiled function:
 ;   Lambda-list: (WER V)
 ;   Derived type: (FUNCTION (WEIR::WEIR (UNSIGNED-BYTE 31))
 ;                  (VALUES T BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:GET-VERTS-WITH-PROP

```
find verts with prop (and val)

 ; WEIR:GET-VERTS-WITH-PROP
 ;   [symbol]
 ; 
 ; GET-VERTS-WITH-PROP names a compiled function:
 ;   Lambda-list: (WER PROP &KEY VAL &AUX (RES (LIST)))
 ;   Derived type: (FUNCTION (WEIR::WEIR SYMBOL &KEY (:VAL T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     find verts with prop (and val)
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:GET-WEST-MOST-VERT

```
:missing:todo:

 ; WEIR:GET-WEST-MOST-VERT
 ;   [symbol]
```

#### WEIR:GRP-EXISTS

```
:missing:todo:

 ; WEIR:GRP-EXISTS
 ;   [symbol]
 ; 
 ; GRP-EXISTS names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T)) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:IMPORT-VERTS-GRP

```
:missing:todo:

 ; WEIR:IMPORT-VERTS-GRP
 ;   [symbol]
```

#### WEIR:IS-VERT-IN-GRP

```
tests whether v is in grp g
   note: verts only belong to a grp if they are part of an edge in grp.

 ; WEIR:IS-VERT-IN-GRP
 ;   [symbol]
 ; 
 ; IS-VERT-IN-GRP names a compiled function:
 ;   Lambda-list: (WER V &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR (UNSIGNED-BYTE 31) &KEY (:G T)) *)
 ;   Documentation:
 ;     tests whether v is in grp g
 ;        note: verts only belong to a grp if they are part of an edge in grp.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:ITR-EDGES

```
iterates over all edges in grp g as ee. if verts is provided it must be a
   list with two symbols. these two symbols will represent the two verts in the
   edge. if g is not provided, the main grp will be used.

 ; WEIR:ITR-EDGES
 ;   [symbol]
 ; 
 ; ITR-EDGES names a macro:
 ;   Lambda-list: ((WER EE &KEY G COLLECT VERTS) &BODY BODY)
 ;   Documentation:
 ;     iterates over all edges in grp g as ee. if verts is provided it must be a
 ;        list with two symbols. these two symbols will represent the two verts in the
 ;        edge. if g is not provided, the main grp will be used.
 ;   Source file: /data/x/weird/src/weir/macros.lisp
```

#### WEIR:ITR-GRP-VERTS

```

  iterates over all verts in grp g as i.

  NOTE: this will only yield vertices that belong to at least one edge that is
  part of g. if you want all vertices in weir you should use itr-verts instead.
  itr-verts is also faster, since it does not rely on the underlying graph
  structure.

  if g is not provided, the main grp wil be used.
  

 ; WEIR:ITR-GRP-VERTS
 ;   [symbol]
 ; 
 ; ITR-GRP-VERTS names a macro:
 ;   Lambda-list: ((WER I &KEY G COLLECT) &BODY BODY)
 ;   Documentation:
 ;     
 ;       iterates over all verts in grp g as i.
 ;     
 ;       NOTE: this will only yield vertices that belong to at least one edge that is
 ;       part of g. if you want all vertices in weir you should use itr-verts instead.
 ;       itr-verts is also faster, since it does not rely on the underlying graph
 ;       structure.
 ;     
 ;       if g is not provided, the main grp wil be used.
 ; 
 ;   Source file: /data/x/weird/src/weir/macros.lisp
```

#### WEIR:ITR-GRPS

```
iterates over all grps of wer as g

 ; WEIR:ITR-GRPS
 ;   [symbol]
 ; 
 ; ITR-GRPS names a macro:
 ;   Lambda-list: ((WER G &KEY COLLECT MAIN) &BODY BODY)
 ;   Documentation:
 ;     iterates over all grps of wer as g
 ;   Source file: /data/x/weird/src/weir/macros.lisp
```

#### WEIR:ITR-VERTS

```
iterates over ALL verts in wer as i

 ; WEIR:ITR-VERTS
 ;   [symbol]
 ; 
 ; ITR-VERTS names a macro:
 ;   Lambda-list: ((WER I &KEY COLLECT) &BODY BODY)
 ;   Documentation:
 ;     iterates over ALL verts in wer as i
 ;   Source file: /data/x/weird/src/weir/macros.lisp
```

#### WEIR:LADD-EDGE!

```
:missing:todo:

 ; WEIR:LADD-EDGE!
 ;   [symbol]
 ; 
 ; LADD-EDGE! names a compiled function:
 ;   Lambda-list: (WER EE &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:LCOLLAPSE-VERTS!

```
move all incident edges of v1, v2, ... to u. assuming uv = (u v1 v2 ...)

 ; WEIR:LCOLLAPSE-VERTS!
 ;   [symbol]
 ; 
 ; LCOLLAPSE-VERTS! names a compiled function:
 ;   Lambda-list: (WER UV &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     move all incident edges of v1, v2, ... to u. assuming uv = (u v1 v2 ...)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:LDEL-EDGE!

```
:missing:todo:

 ; WEIR:LDEL-EDGE!
 ;   [symbol]
 ; 
 ; LDEL-EDGE! names a compiled function:
 ;   Lambda-list: (WER EE &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T)) *)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:LOAD-INTERNAL-MODEL!

```
:missing:todo:

 ; WEIR:LOAD-INTERNAL-MODEL!
 ;   [symbol]
 ; 
 ; LOAD-INTERNAL-MODEL! names a compiled function:
 ;   Lambda-list: (WER NAME)
 ;   Derived type: (FUNCTION (WEIR::WEIR STRING) *)
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:LSPLIT-EDGE!

```
:missing:todo:

 ; WEIR:LSPLIT-EDGE!
 ;   [symbol]
```

#### WEIR:LSPLIT-EDGE-IND!

```
:missing:todo:

 ; WEIR:LSPLIT-EDGE-IND!
 ;   [symbol]
 ; 
 ; LSPLIT-EDGE-IND! names a compiled function:
 ;   Lambda-list: (WER EE &KEY VIA G FORCE)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR LIST &KEY (:VIA (UNSIGNED-BYTE 31)) (:G T)
 ;                   (:FORCE BOOLEAN))
 ;                  *)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:LSWAP-EDGE!

```
move edge from grp from to g

 ; WEIR:LSWAP-EDGE!
 ;   [symbol]
 ; 
 ; LSWAP-EDGE! names a compiled function:
 ;   Lambda-list: (WER EE &KEY G FROM)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST &KEY (:G T) (:FROM T)) *)
 ;   Documentation:
 ;     move edge from grp from to g
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:MAKE

```

  make weir instances

  - max-verts is the maximum number of verts in weir (across all grps).
  - set-size is the initial size of edge adjacency sets.
      ie. the expected number of vertices in the graph
  - adj-size is the initial size of the adjacency map.
      ie. the expected number of incident vertices
  - dim is the vector dimension of vertices
  

 ; WEIR:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (&KEY (MAX-VERTS 5000) (ADJ-SIZE 4) (SET-SIZE 10) NAME
 ;                 (DIM 2))
 ;   Derived type: (FUNCTION
 ;                  (&KEY (:MAX-VERTS (UNSIGNED-BYTE 31))
 ;                   (:ADJ-SIZE (UNSIGNED-BYTE 31))
 ;                   (:SET-SIZE (UNSIGNED-BYTE 31)) (:NAME SYMBOL)
 ;                   (:DIM (UNSIGNED-BYTE 31)))
 ;                  (VALUES WEIR::WEIR &OPTIONAL))
 ;   Documentation:
 ;     
 ;       make weir instances
 ;     
 ;       - max-verts is the maximum number of verts in weir (across all grps).
 ;       - set-size is the initial size of edge adjacency sets.
 ;           ie. the expected number of vertices in the graph
 ;       - adj-size is the initial size of the adjacency map.
 ;           ie. the expected number of incident vertices
 ;       - dim is the vector dimension of vertices
 ; 
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:MCOPY-EDGE-PROPS

```
copy props from, from, into edges, to*

 ; WEIR:MCOPY-EDGE-PROPS
 ;   [symbol]
 ; 
 ; MCOPY-EDGE-PROPS names a compiled function:
 ;   Lambda-list: (WER FROM TO* &KEY CLEAR)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST LIST &KEY (:CLEAR T))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     copy props from, from, into edges, to*
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:MCOPY-VERT-PROPS

```
copy props from, from, into edges, to*

 ; WEIR:MCOPY-VERT-PROPS
 ;   [symbol]
 ; 
 ; MCOPY-VERT-PROPS names a compiled function:
 ;   Lambda-list: (WER FROM TO* &KEY CLEAR)
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST LIST &KEY (:CLEAR T))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     copy props from, from, into edges, to*
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:MESH-BISECT

```
fx: %MESH-BISECT
macro wrapper: MESH-BISECT

defined via veq:fvdef*

 ; WEIR:MESH-BISECT
 ;   [symbol]
 ; 
 ; MESH-BISECT names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %MESH-BISECT
 ;     macro wrapper: MESH-BISECT
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/poly-modify.lisp
```

#### WEIR:MESH-SLICE

```
fx: %MESH-SLICE
macro wrapper: MESH-SLICE

defined via veq:fvdef*

 ; WEIR:MESH-SLICE
 ;   [symbol]
 ; 
 ; MESH-SLICE names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %MESH-SLICE
 ;     macro wrapper: MESH-SLICE
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/poly-modify.lisp
```

#### WEIR:MSET-EDGE-PROP

```
set prop of edges

 ; WEIR:MSET-EDGE-PROP
 ;   [symbol]
 ; 
 ; MSET-EDGE-PROP names a compiled function:
 ;   Lambda-list: (WER EDGES PROP &OPTIONAL (VAL T))
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST SYMBOL &OPTIONAL T)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     set prop of edges
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:MSET-POLY-PROP

```
set prop of polys

 ; WEIR:MSET-POLY-PROP
 ;   [symbol]
 ; 
 ; MSET-POLY-PROP names a compiled function:
 ;   Lambda-list: (WER POLYS PROP &OPTIONAL (VAL T))
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST SYMBOL &OPTIONAL T)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     set prop of polys
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:MSET-VERT-PROP

```
set prop of verts

 ; WEIR:MSET-VERT-PROP
 ;   [symbol]
 ; 
 ; MSET-VERT-PROP names a compiled function:
 ;   Lambda-list: (WER VERTS PROP &OPTIONAL (VAL T))
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST SYMBOL &OPTIONAL T)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     set prop of verts
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:OBJ-EXPORT

```
:missing:todo:

 ; WEIR:OBJ-EXPORT
 ;   [symbol]
 ; 
 ; OBJ-EXPORT names a compiled function:
 ;   Lambda-list: (WER FN &KEY (MESH-NAME mesh) &AUX
 ;                 (VERTS (3GET-ALL-VERTS WER)) (N (GET-NUM-VERTS WER)))
 ;   Derived type: (FUNCTION (WEIR::WEIR T &KEY (:MESH-NAME STRING))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:OBJ-IMPORT!

```
:missing:todo:

 ; WEIR:OBJ-IMPORT!
 ;   [symbol]
 ; 
 ; OBJ-IMPORT! names a compiled function:
 ;   Lambda-list: (WER FN &AUX (RES (LIST)) (N (GET-NUM-VERTS WER)))
 ;   Derived type: (FUNCTION (WEIR::WEIR T) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/poly.lisp
```

#### WEIR:RESET-GRP!

```
reset grp, g. if g does not exist it will be created.

 ; WEIR:RESET-GRP!
 ;   [symbol]
 ; 
 ; RESET-GRP! names a compiled function:
 ;   Lambda-list: (WER &KEY G)
 ;   Derived type: (FUNCTION (WEIR::WEIR &KEY (:G T))
 ;                  (VALUES WEIR::GRP &OPTIONAL))
 ;   Documentation:
 ;     reset grp, g. if g does not exist it will be created.
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:SET-EDGE-PROP

```
set prop of edge e

 ; WEIR:SET-EDGE-PROP
 ;   [symbol]
 ; 
 ; SET-EDGE-PROP names a compiled function:
 ;   Lambda-list: (WER E PROP &OPTIONAL (VAL T))
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST SYMBOL &OPTIONAL T) *)
 ;   Documentation:
 ;     set prop of edge e
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:SET-GRP-PROP

```
set prop of grp g

 ; WEIR:SET-GRP-PROP
 ;   [symbol]
 ; 
 ; SET-GRP-PROP names a compiled function:
 ;   Lambda-list: (WER G PROP &OPTIONAL (VAL T))
 ;   Derived type: (FUNCTION (WEIR::WEIR SYMBOL SYMBOL &OPTIONAL T) *)
 ;   Documentation:
 ;     set prop of grp g
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:SET-POLY-PROP

```
set prop of poly e

 ; WEIR:SET-POLY-PROP
 ;   [symbol]
 ; 
 ; SET-POLY-PROP names a compiled function:
 ;   Lambda-list: (WER E PROP &OPTIONAL (VAL T))
 ;   Derived type: (FUNCTION (WEIR::WEIR LIST SYMBOL &OPTIONAL T) *)
 ;   Documentation:
 ;     set prop of poly e
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:SET-VERT-PROP

```
set prop of vert v

 ; WEIR:SET-VERT-PROP
 ;   [symbol]
 ; 
 ; SET-VERT-PROP names a compiled function:
 ;   Lambda-list: (WER V PROP &OPTIONAL (VAL T))
 ;   Derived type: (FUNCTION (WEIR::WEIR FIXNUM SYMBOL &OPTIONAL T) *)
 ;   Documentation:
 ;     set prop of vert v
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:SPLIT-EDGE-IND!

```
add delete edge (a b) and add edges (a via b)

 ; WEIR:SPLIT-EDGE-IND!
 ;   [symbol]
 ; 
 ; SPLIT-EDGE-IND! names a compiled function:
 ;   Lambda-list: (WER A B &KEY VIA G FORCE)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) &KEY
 ;                   (:VIA (UNSIGNED-BYTE 31)) (:G T) (:FORCE BOOLEAN))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     add delete edge (a b) and add edges (a via b)
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:SWAP-EDGE!

```
move edge from grp from to g

 ; WEIR:SWAP-EDGE!
 ;   [symbol]
 ; 
 ; SWAP-EDGE! names a compiled function:
 ;   Lambda-list: (WER A B &KEY G FROM)
 ;   Derived type: (FUNCTION
 ;                  (WEIR::WEIR (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) &KEY
 ;                   (:G T) (:FROM T))
 ;                  *)
 ;   Documentation:
 ;     move edge from grp from to g
 ;   Source file: /data/x/weird/src/weir/main.lisp
```

#### WEIR:VERT-HAS-PROP

```
t if vert v has prop (and val)

 ; WEIR:VERT-HAS-PROP
 ;   [symbol]
 ; 
 ; VERT-HAS-PROP names a compiled function:
 ;   Lambda-list: (WER V PROP &KEY VAL)
 ;   Derived type: (FUNCTION (WEIR::WEIR FIXNUM SYMBOL &KEY (:VAL T))
 ;                  (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     t if vert v has prop (and val)
 ;   Source file: /data/x/weird/src/weir/props.lisp
```

#### WEIR:VERTS

```
:missing:todo:

 ; WEIR:VERTS
 ;   [symbol]
 ; 
 ; VERTS names a compiled function:
 ;   Lambda-list: (WER)
 ;   Derived type: (FUNCTION (WEIR::WEIR)
 ;                  (VALUES (SIMPLE-ARRAY SINGLE-FLOAT) &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/vert-utils.lisp
```

#### WEIR:WITH

```
:missing:todo:

 ; WEIR:WITH
 ;   [symbol]
 ; 
 ; WITH names a macro:
 ;   Lambda-list: ((WER ACCFX &KEY DB) &BODY BODY)
 ;   Source file: /data/x/weird/src/weir/with-macro.lisp
```

#### WEIR:WITH-GS

```
:missing:todo:

 ; WEIR:WITH-GS
 ;   [symbol]
 ; 
 ; WITH-GS names a macro:
 ;   Lambda-list: ((&REST REST) &BODY BODY)
 ;   Source file: /data/x/weird/src/weir/alteration-utils.lisp
```

#### WEIR:WITH-RND-EDGE

```

  select an arbitrary edge from a weir instance. the edge will be
  available in the context as i.

  if a grp, g, is supplied it will select an edge from g, otherwise it will use
  the main grp.
  

 ; WEIR:WITH-RND-EDGE
 ;   [symbol]
 ; 
 ; WITH-RND-EDGE names a macro:
 ;   Lambda-list: ((WER I &KEY G) &BODY BODY)
 ;   Documentation:
 ;     
 ;       select an arbitrary edge from a weir instance. the edge will be
 ;       available in the context as i.
 ;     
 ;       if a grp, g, is supplied it will select an edge from g, otherwise it will use
 ;       the main grp.
 ; 
 ;   Source file: /data/x/weird/src/weir/macros.lisp
```

#### WEIR:WITH-RND-VERT

```
select an arbitrary vert from a weir instance. the vert will be available in
   the context as i.

 ; WEIR:WITH-RND-VERT
 ;   [symbol]
 ; 
 ; WITH-RND-VERT names a macro:
 ;   Lambda-list: ((WER I) &BODY BODY)
 ;   Documentation:
 ;     select an arbitrary vert from a weir instance. the vert will be available in
 ;        the context as i.
 ;   Source file: /data/x/weird/src/weir/macros.lisp
```

