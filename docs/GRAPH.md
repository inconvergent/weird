#### GRAPH:ADD

```
add edge ab. returns t if edge did not exist.

 ; GRAPH:ADD
 ;   [symbol]
 ; 
 ; ADD names a compiled function:
 ;   Lambda-list: (GRPH A B)
 ;   Derived type: (FUNCTION
 ;                  (GRAPH::GRAPH (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Documentation:
 ;     add edge ab. returns t if edge did not exist.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:COPY

```
return copy of graph instance.

 ; GRAPH:COPY
 ;   [symbol]
 ; 
 ; COPY names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH)
 ;                  (VALUES GRAPH::GRAPH &OPTIONAL))
 ;   Documentation:
 ;     return copy of graph instance.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:CYCLE->EDGE-SET

```
return edge set from cycle.
ex: (1 2 3 4 5 1) -> ((1 2) (2 3) (3 4) (4 5) (1 5))

 ; GRAPH:CYCLE->EDGE-SET
 ;   [symbol]
 ; 
 ; CYCLE->EDGE-SET names a compiled function:
 ;   Lambda-list: (CYCLE)
 ;   Derived type: (FUNCTION (LIST) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     return edge set from cycle.
 ;     ex: (1 2 3 4 5 1) -> ((1 2) (2 3) (3 4) (4 5) (1 5))
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:CYCLE-BASIS->EDGE-SETS

```
return an edge set for every cycle in a cycle basis.
it does not check if the cycle basis is correct. cycles must be closed.
that is, they must begin and end on the same vertex.

 ; GRAPH:CYCLE-BASIS->EDGE-SETS
 ;   [symbol]
 ; 
 ; CYCLE-BASIS->EDGE-SETS names a compiled function:
 ;   Lambda-list: (BASIS)
 ;   Derived type: (FUNCTION (LIST) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     return an edge set for every cycle in a cycle basis.
 ;     it does not check if the cycle basis is correct. cycles must be closed.
 ;     that is, they must begin and end on the same vertex.
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:DEL

```
del edge ab. returns t if edge existed.

 ; GRAPH:DEL
 ;   [symbol]
 ; 
 ; DEL names a compiled function:
 ;   Lambda-list: (GRPH A B)
 ;   Derived type: (FUNCTION
 ;                  (GRAPH::GRAPH (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Documentation:
 ;     del edge ab. returns t if edge existed.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:DEL-SIMPLE-FILAMENTS

```
recursively remove all simple filament edges until there are none left.



 ; GRAPH:DEL-SIMPLE-FILAMENTS
 ;   [symbol]
 ; 
 ; DEL-SIMPLE-FILAMENTS names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH)
 ;                  (VALUES GRAPH::GRAPH &OPTIONAL))
 ;   Documentation:
 ;     recursively remove all simple filament edges until there are none left.
 ;     
 ; 
 ;   Source file: /data/x/weird/src/graph/paths.lisp
```

#### GRAPH:EDGE-SET->GRAPH

```
create a graph from edges in edge set.

 ; GRAPH:EDGE-SET->GRAPH
 ;   [symbol]
 ; 
 ; EDGE-SET->GRAPH names a compiled function:
 ;   Lambda-list: (ES)
 ;   Derived type: (FUNCTION (LIST) (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     create a graph from edges in edge set.
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
 ;     convert edge set: ((3 4) (4 5) (5 6) (1 2) (6 1) (2 3))
 ;     into a path: (4 5 6 1 2 3)
 ;     second result is a boolean for whether it is a cycle.
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:EDGE-SET-SYMDIFF

```
symmetric difference of edge set a and b. not very efficient.

 ; GRAPH:EDGE-SET-SYMDIFF
 ;   [symbol]
 ; 
 ; EDGE-SET-SYMDIFF names a compiled function:
 ;   Lambda-list: (A B)
 ;   Derived type: (FUNCTION (LIST LIST) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     symmetric difference of edge set a and b. not very efficient.
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:EDGE-SETS->CYCLE-BASIS

```
the opposite of cycle-basis->edge-sets.

 ; GRAPH:EDGE-SETS->CYCLE-BASIS
 ;   [symbol]
 ; 
 ; EDGE-SETS->CYCLE-BASIS names a compiled function:
 ;   Lambda-list: (ES)
 ;   Derived type: (FUNCTION (LIST) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     the opposite of cycle-basis->edge-sets.
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
get list of lists of all edges.

 ; GRAPH:GET-EDGES
 ;   [symbol]
 ; 
 ; GET-EDGES names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     get list of lists of all edges.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-INCIDENT-EDGES

```
get all incident edges of v.

 ; GRAPH:GET-INCIDENT-EDGES
 ;   [symbol]
 ; 
 ; GET-INCIDENT-EDGES names a compiled function:
 ;   Lambda-list: (GRPH V)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH (UNSIGNED-BYTE 31))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     get all incident edges of v.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-INCIDENT-VERTS

```
get all incident vertices of v.

 ; GRAPH:GET-INCIDENT-VERTS
 ;   [symbol]
 ; 
 ; GET-INCIDENT-VERTS names a compiled function:
 ;   Lambda-list: (GRPH V)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH (UNSIGNED-BYTE 31)) *)
 ;   Documentation:
 ;     get all incident vertices of v.
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
 ;     return all minimal spanning trees of grph in a new graph.
 ;     if start is provided, it will return a spanning tree starting at start.
 ;   Source file: /data/x/weird/src/graph/mst-cycle.lisp
```

#### GRAPH:GET-NUM-EDGES

```
return total number of edges in graph.

 ; GRAPH:GET-NUM-EDGES
 ;   [symbol]
 ; 
 ; GET-NUM-EDGES names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH)
 ;                  (VALUES (RATIONAL 0 2147483647/2) &OPTIONAL))
 ;   Documentation:
 ;     return total number of edges in graph.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-NUM-VERTS

```
return total number of verts in graph. only counts vertices with connected
edges.

 ; GRAPH:GET-NUM-VERTS
 ;   [symbol]
 ; 
 ; GET-NUM-VERTS names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH)
 ;                  (VALUES (MOD 4611686018427387901) &OPTIONAL))
 ;   Documentation:
 ;     return total number of verts in graph. only counts vertices with connected
 ;     edges.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:GET-SEGMENTS

```
greedily finds segments :between: multi-intersection points.

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
 ;     greedily finds segments :between: multi-intersection points.
 ;     
 ;     note: by definition this will not return parts of the graph that have no
 ;     multi-intersections. consider walk-graph instead.
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
 ;     return all spanning trees (if the graph is disjoint) of grph in a new graph.
 ;     if start is provided, it will return a spanning tree starting at start.
 ;   Source file: /data/x/weird/src/graph/mst-cycle.lisp
```

#### GRAPH:GET-VERTS

```
return all vertices with at least one connected edge.

 ; GRAPH:GET-VERTS
 ;   [symbol]
 ; 
 ; GET-VERTS names a compiled function:
 ;   Lambda-list: (GRPH)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     return all vertices with at least one connected edge.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:MAKE

```
create undirected graph instance with no spatial awareness.

since the graph is undirected. all edges are normalized such that the smallest
vertex is first. any checks that compare edges in any sense will return the
same value for (a b) and (b a).

assuming the following graph:

  x-y-u
  |   |
a-b-c-d-o
  |
  y

this terminology is used:
  - ab, by and do are (simple) filaments.
  - bcd and bxyud are segments.
  - (simple) filaments are segments.
  - bcduyx(b) is a cycle.
  - b and d are multi intersection points/vertices
  - a, y, o are dead-ends.

arguments:
  - adj-size: initial size of adjacency hash-table
    (total number of verts)
  - adj-inc: size multiplier for hash-table
  - set-size: initial size of vert adjecency list
    (typical number of edges per vert)
  - set-inc: size multiplier vert adjecency list
default values should usually work fine.

 ; GRAPH:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (&KEY (NAME (GENSYM GRAPH)) (ADJ-SIZE 4) (ADJ-INC 2.0)
 ;                 (SET-SIZE 10) (SET-INC 2.0))
 ;   Derived type: (FUNCTION
 ;                  (&KEY (:NAME T) (:ADJ-SIZE T) (:ADJ-INC T)
 ;                   (:SET-SIZE T) (:SET-INC T))
 ;                  (VALUES GRAPH::GRAPH &OPTIONAL))
 ;   Documentation:
 ;     create undirected graph instance with no spatial awareness.
 ;     
 ;     since the graph is undirected. all edges are normalized such that the smallest
 ;     vertex is first. any checks that compare edges in any sense will return the
 ;     same value for (a b) and (b a).
 ;     
 ;     assuming the following graph:
 ;     
 ;       x-y-u
 ;       |   |
 ;     a-b-c-d-o
 ;       |
 ;       y
 ;     
 ;     this terminology is used:
 ;       - ab, by and do are (simple) filaments.
 ;       - bcd and bxyud are segments.
 ;       - (simple) filaments are segments.
 ;       - bcduyx(b) is a cycle.
 ;       - b and d are multi intersection points/vertices
 ;       - a, y, o are dead-ends.
 ;     
 ;     arguments:
 ;       - adj-size: initial size of adjacency hash-table
 ;         (total number of verts)
 ;       - adj-inc: size multiplier for hash-table
 ;       - set-size: initial size of vert adjecency list
 ;         (typical number of edges per vert)
 ;       - set-inc: size multiplier vert adjecency list
 ;     default values should usually work fine.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:MEM

```
check if edge ab exists.

 ; GRAPH:MEM
 ;   [symbol]
 ; 
 ; MEM names a compiled function:
 ;   Lambda-list: (GRPH A B)
 ;   Derived type: (FUNCTION
 ;                  (GRAPH::GRAPH (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Documentation:
 ;     check if edge ab exists.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:PATH->EDGE-SET

```
return edge set from cycle.
ex: (1 2 3 4 5) -> ((1 2) (2 3) (3 4) (4 5))
if closed is t, (1 5) will be included in the above output.

 ; GRAPH:PATH->EDGE-SET
 ;   [symbol]
 ; 
 ; PATH->EDGE-SET names a compiled function:
 ;   Lambda-list: (PATH &KEY CLOSED)
 ;   Derived type: (FUNCTION (LIST &KEY (:CLOSED BOOLEAN))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     return edge set from cycle.
 ;     ex: (1 2 3 4 5) -> ((1 2) (2 3) (3 4) (4 5))
 ;     if closed is t, (1 5) will be included in the above output.
 ;   Source file: /data/x/weird/src/graph/edge-set.lisp
```

#### GRAPH:VMEM

```
check if v has at least one connected edge.

 ; GRAPH:VMEM
 ;   [symbol]
 ; 
 ; VMEM names a compiled function:
 ;   Lambda-list: (GRPH V)
 ;   Derived type: (FUNCTION (GRAPH::GRAPH (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Documentation:
 ;     check if v has at least one connected edge.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:WALK-GRAPH

```
greedily walks the graph so that every edge is returned exactly once.
in multi-intersectinons the walker selects the smallest available angle.
this is useful for exporting a graph as a plotter drawing.

 ; GRAPH:WALK-GRAPH
 ;   [symbol]
 ; 
 ; WALK-GRAPH names a compiled function:
 ;   Lambda-list: (GRPH &KEY (ANGLE (FUNCTION -ANGLE-FX)))
 ;   Derived type: (FUNCTION (GRAPH::GRAPH &KEY (:ANGLE T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     greedily walks the graph so that every edge is returned exactly once.
 ;     in multi-intersectinons the walker selects the smallest available angle.
 ;     this is useful for exporting a graph as a plotter drawing.
 ;   Source file: /data/x/weird/src/graph/paths.lisp
```

#### GRAPH:WITH-GRAPH-EDGES

```
iterate over all edges as e. more efficient than get-edges because it does
not build the entire structure.
ex (with-graph-edges (grph e) (print e))

 ; GRAPH:WITH-GRAPH-EDGES
 ;   [symbol]
 ; 
 ; WITH-GRAPH-EDGES names a macro:
 ;   Lambda-list: ((GRPH E) &BODY BODY)
 ;   Documentation:
 ;     iterate over all edges as e. more efficient than get-edges because it does
 ;     not build the entire structure.
 ;     ex (with-graph-edges (grph e) (print e))
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

#### GRAPH:WITH-GRAPH-VERTS

```
iterate over all verts as v.

 ; GRAPH:WITH-GRAPH-VERTS
 ;   [symbol]
 ; 
 ; WITH-GRAPH-VERTS names a macro:
 ;   Lambda-list: ((GRPH V) &BODY BODY)
 ;   Documentation:
 ;     iterate over all verts as v.
 ;   Source file: /data/x/weird/src/graph/main.lisp
```

