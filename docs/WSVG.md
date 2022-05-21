#### WSVG:\*HALF-LONG\*

```
:missing:todo:

 ; WSVG:*HALF-LONG*
 ;   [symbol]
 ; 
 ; *HALF-LONG* names a special variable:
 ;   Declared type: SINGLE-FLOAT
 ;   Value: 707.1425
```

#### WSVG:\*HALF-SHORT\*

```
:missing:todo:

 ; WSVG:*HALF-SHORT*
 ;   [symbol]
 ; 
 ; *HALF-SHORT* names a special variable:
 ;   Declared type: SINGLE-FLOAT
 ;   Value: 500.0
```

#### WSVG:\*LONG\*

```
:missing:todo:

 ; WSVG:*LONG*
 ;   [symbol]
 ; 
 ; *LONG* names a special variable:
 ;   Declared type: SINGLE-FLOAT
 ;   Value: 1414.285
```

#### WSVG:\*SHORT\*

```
:missing:todo:

 ; WSVG:*SHORT*
 ;   [symbol]
 ; 
 ; *SHORT* names a special variable:
 ;   Declared type: SINGLE-FLOAT
 ;   Value: 1000.0
```

#### WSVG:BZSPL

```
quadratic bezier

 ; WSVG:BZSPL
 ;   [symbol]
 ; 
 ; BZSPL names a compiled function:
 ;   Lambda-list: (WSVG PTS* &KEY CLOSED SW STROKE FILL SO FO &AUX
 ;                 (PTS (ENSURE-LIST PTS*)))
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG T &KEY (:CLOSED T) (:SW T) (:STROKE T)
 ;                   (:FILL T) (:SO T) (:FO T))
 ;                  (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     quadratic bezier
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:CARC

```
:missing:todo:

 ; WSVG:CARC
 ;   [symbol]
```

#### WSVG:CIRC

```
:missing:todo:

 ; WSVG:CIRC
 ;   [symbol]
 ; 
 ; CIRC names a compiled function:
 ;   Lambda-list: (WSVG RAD &KEY (XY *ZERO*) FILL SW STROKE SO FO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG NUMBER &KEY (:XY LIST) (:FILL T) (:SW T)
 ;                   (:STROKE T) (:SO T) (:FO T))
 ;                  (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:COMPOUND

```
:missing:todo:

 ; WSVG:COMPOUND
 ;   [symbol]
 ; 
 ; COMPOUND names a compiled function:
 ;   Lambda-list: (WSVG COMPONENTS &KEY SW FILL STROKE FO SO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG SEQUENCE &KEY (:SW T) (:FILL T)
 ;                   (:STROKE T) (:FO T) (:SO T))
 ;                  (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:DRAW

```
draw any svg dpath

 ; WSVG:DRAW
 ;   [symbol]
 ; 
 ; DRAW names a compiled function:
 ;   Lambda-list: (WSVG D &KEY SW STROKE FILL SO FO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG VECTOR &KEY (:SW T) (:STROKE T) (:FILL T)
 ;                   (:SO T) (:FO T))
 ;                  (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     draw any svg dpath
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:HATCH

```
:missing:todo:

 ; WSVG:HATCH
 ;   [symbol]
```

#### WSVG:JPATH

```
:missing:todo:

 ; WSVG:JPATH
 ;   [symbol]
 ; 
 ; JPATH names a compiled function:
 ;   Lambda-list: (WSVG PTS &KEY (WIDTH 1.0) CLOSED STROKE SW SO RS NS
 ;                 (LIMITS *LIMITS*))
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG SEQUENCE &KEY (:WIDTH T) (:CLOSED T)
 ;                   (:STROKE T) (:SW T) (:SO T) (:RS T) (:NS T)
 ;                   (:LIMITS T))
 ;                  *)
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:MAKE

```
:missing:todo:

 ; WSVG:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (&KEY (LAYOUT A4-LANDSCAPE) STROKE STROKE-WIDTH
 ;                 REP-SCALE FILL-OPACITY STROKE-OPACITY SO RS FO SW)
 ;   Derived type: (FUNCTION
 ;                  (&KEY (:LAYOUT T) (:STROKE T) (:STROKE-WIDTH T)
 ;                   (:REP-SCALE T) (:FILL-OPACITY T) (:STROKE-OPACITY T)
 ;                   (:SO T) (:RS T) (:FO T) (:SW T))
 ;                  (VALUES WSVG::WSVG &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:MAKE\*

```
:missing:todo:

 ; WSVG:MAKE*
 ;   [symbol]
 ; 
 ; MAKE* names a compiled function:
 ;   Lambda-list: (&KEY (HEIGHT 1000.0) (WIDTH 1000.0) STROKE STROKE-WIDTH
 ;                 REP-SCALE FILL-OPACITY STROKE-OPACITY SO RS FO SW)
 ;   Derived type: (FUNCTION
 ;                  (&KEY (:HEIGHT T) (:WIDTH T) (:STROKE T)
 ;                   (:STROKE-WIDTH T) (:REP-SCALE T) (:FILL-OPACITY T)
 ;                   (:STROKE-OPACITY T) (:SO T) (:RS T) (:FO T) (:SW T))
 ;                  (VALUES WSVG::WSVG &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:PATH

```
:missing:todo:

 ; WSVG:PATH
 ;   [symbol]
 ; 
 ; PATH names a compiled function:
 ;   Lambda-list: (WSVG PTS* &KEY SW FILL STROKE SO FO CLOSED LJ &AUX
 ;                 (PTS (ENSURE-LIST PTS*)))
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG T &KEY (:SW T) (:FILL T) (:STROKE T)
 ;                   (:SO T) (:FO T) (:CLOSED T) (:LJ T))
 ;                  (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:RECT

```
:missing:todo:

 ; WSVG:RECT
 ;   [symbol]
 ; 
 ; RECT names a compiled function:
 ;   Lambda-list: (WSVG W H &KEY (XY *ZERO*) FILL SW STROKE SO FO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG NUMBER NUMBER &KEY (:XY LIST) (:FILL T)
 ;                   (:SW T) (:STROKE T) (:SO T) (:FO T))
 ;                  (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:SAVE

```
:missing:todo:

 ; WSVG:SAVE
 ;   [symbol]
 ; 
 ; SAVE names a compiled function:
 ;   Lambda-list: (WSVG FN)
 ;   Derived type: (FUNCTION (WSVG::WSVG T) *)
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:SQUARE

```
:missing:todo:

 ; WSVG:SQUARE
 ;   [symbol]
 ; 
 ; SQUARE names a compiled function:
 ;   Lambda-list: (WSVG S &KEY (XY *ZERO*) FILL SW STROKE SO FO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG SINGLE-FLOAT &KEY (:XY T) (:FILL T)
 ;                   (:SW T) (:STROKE T) (:SO T) (:FO T))
 ;                  *)
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:UPDATE

```
:missing:todo:

 ; WSVG:UPDATE
 ;   [symbol]
 ; 
 ; UPDATE names a compiled function:
 ;   Lambda-list: (WSVG &KEY STROKE SW RS FO SO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG &KEY (:STROKE T) (:SW T) (:RS T) (:FO T)
 ;                   (:SO T))
 ;                  (VALUES (OR NULL SINGLE-FLOAT) &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:WCIRC

```
:missing:todo:

 ; WSVG:WCIRC
 ;   [symbol]
 ; 
 ; WCIRC names a compiled function:
 ;   Lambda-list: (WSVG RAD* &KEY (XY *ZERO*) OUTER-RAD SW RS STROKE SO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG NUMBER &KEY (:XY LIST) (:OUTER-RAD T)
 ;                   (:SW T) (:RS T) (:STROKE T) (:SO T))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:WPATH

```
:missing:todo:

 ; WSVG:WPATH
 ;   [symbol]
```

