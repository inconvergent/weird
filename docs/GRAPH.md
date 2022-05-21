#### GRAPH:ADD

```
:missing:todo:

 ; GRAPH:ADD
 ;   [symbol]
 ; 
 ; ADD names a compiled function:
 ;   Lambda-list: (GRPH A B)
 ;   Derived type: (FUNCTION
 ;                  (GRAPH::GRAPH (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:COPY

```
:missing:todo:

 ; GRAPH:COPY
 ;   [symbol]
 ; 
 ; COPY names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH)
 ;                  (VALUES GRAPH::GRAPH &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:CYCLE->EDGE-SET

```
:missing:todo:

 ; GRAPH:CYCLE->EDGE-SET
 ;   [symbol]
 ; 
 ; CYCLE->EDGE-SET names a compiled function:
 ;   Lambda-list: (CYCLE)
 ;   Derived type: (FUNCTION (LIST) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:CYCLE-BASIS->EDGE-SETS

```
:missing:todo:

 ; GRAPH:CYCLE-BASIS->EDGE-SETS
 ;   [symbol]
 ; 
 ; CYCLE-BASIS->EDGE-SETS names a compiled function:
 ;   Lambda-list: (BASIS)
 ;   Derived type: (FUNCTION (LIST) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:DEL

```
:missing:todo:

 ; GRAPH:DEL
 ;   [symbol]
 ; 
 ; DEL names a compiled function:
 ;   Lambda-list: (GRPH A B)
 ;   Derived type: (FUNCTION
 ;                  (GRAPH::GRAPH (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:DEL-SIMPLE-FILAMENTS

```
recursively remove all simple filament edges until there are none left

 ; GRAPH:DEL-SIMPLE-FILAMENTS
 ;   [symbol]
 ; 
 ; DEL-SIMPLE-FILAMENTS names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH)
 ;                  (VALUES GRAPH::GRAPH &OPTIONAL))
 ;   Documentation:
 ;     recursively remove all simple filament edges until there are none left
 ;   Source file: /data/x/weird/src/graph/paths.lisp
```

#### GRAPH:EDGE-SET->GRAPH

```
:missing:todo:

 ; GRAPH:EDGE-SET->GRAPH
 ;   [symbol]
 ; 
 ; EDGE-SET->GRAPH names a compiled function:
 ;   Lambda-list: (ES)
 ;   Derived type: (FUNCTION (LIST) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:EDGE-SET->PATH

```

  convert edge set: ((3 4) (4 5) (5 6) (1 2) (6 1) (2 3))
  into a path: (4 5 6 1 2 3)
  second result is a boolean for whether it is a cycle.
  

 ; GRAPH:EDGE-SET->PATH
 ;   [symbol]
 ; 
 ; EDGE-SET->PATH names a compiled function:
 ;   Lambda-list: (ES)
 ;   Derived type: (FUNCTION (LIST) (VALUES T BOOLEAN &OPTIONAL))
 ;   Documentation:
 ;     
 ;       convert edge set: ((3 4) (4 5) (5 6) (1 2) (6 1) (2 3))
 ;       into a path: (4 5 6 1 2 3)
 ;       second result is a boolean for whether it is a cycle.
 ; 
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:EDGE-SET-SYMDIFF

```
:missing:todo:

 ; GRAPH:EDGE-SET-SYMDIFF
 ;   [symbol]
 ; 
 ; EDGE-SET-SYMDIFF names a compiled function:
 ;   Lambda-list: (ESA ESB)
 ;   Derived type: (FUNCTION (LIST LIST) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:EDGE-SETS->CYCLE-BASIS

```
:missing:todo:

 ; GRAPH:EDGE-SETS->CYCLE-BASIS
 ;   [symbol]
 ; 
 ; EDGE-SETS->CYCLE-BASIS names a compiled function:
 ;   Lambda-list: (ES)
 ;   Derived type: (FUNCTION (LIST) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:GET-CYCLE-BASIS

```
:missing:todo:

 ; GRAPH:GET-CYCLE-BASIS
 ;   [symbol]
```

#### GRAPH:GET-EDGES

```
:missing:todo:

 ; GRAPH:GET-EDGES
 ;   [symbol]
 ; 
 ; GET-EDGES names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-INCIDENT-EDGES

```
:missing:todo:

 ; GRAPH:GET-INCIDENT-EDGES
 ;   [symbol]
 ; 
 ; GET-INCIDENT-EDGES names a compiled function:
 ;   Lambda-list: (GRPH V)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH (UNSIGNED-BYTE 31))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-INCIDENT-VERTS

```
:missing:todo:

 ; GRAPH:GET-INCIDENT-VERTS
 ;   [symbol]
 ; 
 ; GET-INCIDENT-VERTS names a compiled function:
 ;   Lambda-list: (GRPH V)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH (UNSIGNED-BYTE 31)) *)
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-MIN-SPANNING-TREE

```

  return all minimal spanning trees of grph in a new graph.
  if start is provided, it will return a spanning tree starting at start.
  

 ; GRAPH:GET-MIN-SPANNING-TREE
 ;   [symbol]
 ; 
 ; GET-MIN-SPANNING-TREE names a compiled function:
 ;   Lambda-list: (GRPH &KEY
 ;                 (WEIGHTFX (LAMBDA (A B) (DECLARE (IGNORE A B)) 1.0))
 ;                 (START 0))
 ;   Derived type: (FUNCTION
 ;                  (GRAPH::GRAPH &KEY (:WEIGHTFX FUNCTION)
 ;                   (:START FIXNUM))
 ;                  *)
 ;   Documentation:
 ;     
 ;       return all minimal spanning trees of grph in a new graph.
 ;       if start is provided, it will return a spanning tree starting at start.
 ; 
 ;   Source file: /data/x/weird/src/graph/mst-cycle.lisp
```

#### GRAPH:GET-NUM-EDGES

```
:missing:todo:

 ; GRAPH:GET-NUM-EDGES
 ;   [symbol]
 ; 
 ; GET-NUM-EDGES names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH)
 ;                  (VALUES (RATIONAL 0 2147483647/2) &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-NUM-VERTS

```
:missing:todo:

 ; GRAPH:GET-NUM-VERTS
 ;   [symbol]
 ; 
 ; GET-NUM-VERTS names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH)
 ;                  (VALUES (MOD 4611686018427387901) &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-SEGMENTS

```

  greedily finds segments between multi-intersection points.  TODO: rewrite
  this to avoid cheching everything multiple times.  i'm sorry.

  note: by definition this will not return parts of the graph that have no
  multi-intersections. consider walk-graph instead.
  

 ; GRAPH:GET-SEGMENTS
 ;   [symbol]
 ; 
 ; GET-SEGMENTS names a compiled function:
 ;   Lambda-list: (GRPH &KEY CYCLE-INFO)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH &KEY (:CYCLE-INFO T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     
 ;       greedily finds segments between multi-intersection points.  TODO: rewrite
 ;       this to avoid cheching everything multiple times.  i'm sorry.
 ;     
 ;       note: by definition this will not return parts of the graph that have no
 ;       multi-intersections. consider walk-graph instead.
 ; 
 ;   Source file: /data/x/weird/src/graph/paths.lisp
```

#### GRAPH:GET-SPANNING-TREE

```

  return all spanning trees (if the graph is disjoint) of grph in a new graph.
  if start is provided, it will return a spanning tree starting at start.
  

 ; GRAPH:GET-SPANNING-TREE
 ;   [symbol]
 ; 
 ; GET-SPANNING-TREE names a compiled function:
 ;   Lambda-list: (GRPH &KEY START)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH &KEY (:START T))
 ;                  (VALUES GRAPH::GRAPH
 ;                          (INTEGER -4611686018427387897
 ;                           4611686018427387903)
 ;                          &OPTIONAL))
 ;   Documentation:
 ;     
 ;       return all spanning trees (if the graph is disjoint) of grph in a new graph.
 ;       if start is provided, it will return a spanning tree starting at start.
 ; 
 ;   Source file: /data/x/weird/src/graph/mst-cycle.lisp
```

#### GRAPH:GET-VERTS

```
:missing:todo:

 ; GRAPH:GET-VERTS
 ;   [symbol]
 ; 
 ; GET-VERTS names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:MAKE

```
:missing:todo:

 ; GRAPH:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (&KEY (ADJ-SIZE 4) (ADJ-INC 2.0) (SET-SIZE 10)
 ;                 (SET-INC 2.0))
 ;   Derived type: (FUNCTION
 ;                  (&KEY (:ADJ-SIZE T) (:ADJ-INC T) (:SET-SIZE T)
 ;                   (:SET-INC T))
 ;                  (VALUES GRAPH::GRAPH &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:MEM

```
:missing:todo:

 ; GRAPH:MEM
 ;   [symbol]
 ; 
 ; MEM names a compiled function:
 ;   Lambda-list: (GRPH A B)
 ;   Derived type: (FUNCTION
 ;                  (GRAPH::GRAPH (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:PATH->EDGE-SET

```
:missing:todo:

 ; GRAPH:PATH->EDGE-SET
 ;   [symbol]
 ; 
 ; PATH->EDGE-SET names a compiled function:
 ;   Lambda-list: (PATH &KEY CLOSED)
 ;   Derived type: (FUNCTION (LIST &KEY (:CLOSED BOOLEAN))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:VMEM

```
:missing:todo:

 ; GRAPH:VMEM
 ;   [symbol]
 ; 
 ; VMEM names a compiled function:
 ;   Lambda-list: (GRPH V)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:WALK-GRAPH

```
:missing:todo:

 ; GRAPH:WALK-GRAPH
 ;   [symbol]
 ; 
 ; WALK-GRAPH names a compiled function:
 ;   Lambda-list: (GRPH &KEY (ANGLE (FUNCTION -ANGLE-FX)))
 ;   Derived type: (FUNCTION (GRAPH::GRAPH &KEY (:ANGLE T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/graph/paths.lisp
```

#### GRAPH:WITH-GRAPH-EDGES

```
:missing:todo:

 ; GRAPH:WITH-GRAPH-EDGES
 ;   [symbol]
 ; 
 ; WITH-GRAPH-EDGES names a macro:
 ;   Lambda-list: ((GRPH E) &BODY BODY)
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

