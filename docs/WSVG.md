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
draw quadratic bezier from 2d vector array (veq:fvec) or list of lists.
use fill, stroke, sw, so, fo, as described in wsvg:make to override.
if closed is t, the path will join back to the initial coordinate.
must provide at least three points.

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
 ;     draw quadratic bezier from 2d vector array (veq:fvec) or list of lists.
 ;     use fill, stroke, sw, so, fo, as described in wsvg:make to override.
 ;     if closed is t, the path will join back to the initial coordinate.
 ;     must provide at least three points.
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
draw a circle of radius rad at xy. defaults to origin.

 ; WSVG:CIRC
 ;   [symbol]
 ; 
 ; CIRC names a compiled function:
 ;   Lambda-list: (WSVG RAD &KEY (XY *ZERO*) FILL SW STROKE SO FO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG NUMBER &KEY (:XY LIST) (:FILL T) (:SW T)
 ;                   (:STROKE T) (:SO T) (:FO T))
 ;                  (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     draw a circle of radius rad at xy. defaults to origin.
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
draw any svg dpath from string d
ex: M20,230 Q40,205 50,230 T90,230

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
 ;     draw any svg dpath from string d
 ;     ex: M20,230 Q40,205 50,230 T90,230
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
draw jpath from 2d vector array (veq:fvec) or list of lists.
a jpath is a wide line emulation useful for drawing wide lines in plotter drawings.
- ns: sets the number of parallel lines used to fill
- rs: set fill repetiton scale. you must set either rs or ns.
- width: width of emulated path.

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
 ;   Documentation:
 ;     draw jpath from 2d vector array (veq:fvec) or list of lists.
 ;     a jpath is a wide line emulation useful for drawing wide lines in plotter drawings.
 ;     - ns: sets the number of parallel lines used to fill
 ;     - rs: set fill repetiton scale. you must set either rs or ns.
 ;     - width: width of emulated path.
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:MAKE

```
make wsvg instance for drawing svgs.
- layout: :a4-landscape, :a4-portrait or corresponding values for a3 and a2
- stroke sets default stroke color. default is black
- stroke-width (sw) sets default width. default is 1.1
- rep-scale (rs) sets the default repetition density for functions that perform any
  kind of hatching or wide line emulation.
- stroke-opacity (so) sets default opacity. default is 1.0
- fill-opacity (fo) sets default fill opacity. default is 1.0

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
 ;   Documentation:
 ;     make wsvg instance for drawing svgs.
 ;     - layout: :a4-landscape, :a4-portrait or corresponding values for a3 and a2
 ;     - stroke sets default stroke color. default is black
 ;     - stroke-width (sw) sets default width. default is 1.1
 ;     - rep-scale (rs) sets the default repetition density for functions that perform any
 ;       kind of hatching or wide line emulation.
 ;     - stroke-opacity (so) sets default opacity. default is 1.0
 ;     - fill-opacity (fo) sets default fill opacity. default is 1.0
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:MAKE\*

```
make wsvg instance for drawing svgs.
- height: default 1000.0
- width: default 1000.0
remaining arguments are identical to wsvg:make.

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
 ;   Documentation:
 ;     make wsvg instance for drawing svgs.
 ;     - height: default 1000.0
 ;     - width: default 1000.0
 ;     remaining arguments are identical to wsvg:make.
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:PATH

```
draw path from 2d vector array (veq:fvec) or list of lists
such as ((1f0 2f0) (3f0 4f0)).
use fill, stroke, sw, so, fo, as described in wsvg:make
if closed is t, the path will join back to the initial coordinate.

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
 ;   Documentation:
 ;     draw path from 2d vector array (veq:fvec) or list of lists
 ;     such as ((1f0 2f0) (3f0 4f0)).
 ;     use fill, stroke, sw, so, fo, as described in wsvg:make
 ;     if closed is t, the path will join back to the initial coordinate.
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:RECT

```
draw a rectangle of size w,h at xy. defaults to origin.

 ; WSVG:RECT
 ;   [symbol]
 ; 
 ; RECT names a compiled function:
 ;   Lambda-list: (WSVG W H &KEY (XY *ZERO*) FILL SW STROKE SO FO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG NUMBER NUMBER &KEY (:XY LIST) (:FILL T)
 ;                   (:SW T) (:STROKE T) (:SO T) (:FO T))
 ;                  (VALUES T &OPTIONAL))
 ;   Documentation:
 ;     draw a rectangle of size w,h at xy. defaults to origin.
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:SAVE

```
save wsvg as fn

 ; WSVG:SAVE
 ;   [symbol]
 ; 
 ; SAVE names a compiled function:
 ;   Lambda-list: (WSVG FN)
 ;   Derived type: (FUNCTION (WSVG::WSVG T) *)
 ;   Documentation:
 ;     save wsvg as fn
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:SQUARE

```
draw a square of size s at xy. defaults to origin.

 ; WSVG:SQUARE
 ;   [symbol]
 ; 
 ; SQUARE names a compiled function:
 ;   Lambda-list: (WSVG S &KEY (XY *ZERO*) FILL SW STROKE SO FO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG SINGLE-FLOAT &KEY (:XY T) (:FILL T)
 ;                   (:SW T) (:STROKE T) (:SO T) (:FO T))
 ;                  *)
 ;   Documentation:
 ;     draw a square of size s at xy. defaults to origin.
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
draw a circled filled with concentric circles. use rs to set density.

 ; WSVG:WCIRC
 ;   [symbol]
 ; 
 ; WCIRC names a compiled function:
 ;   Lambda-list: (WSVG RAD* &KEY (XY *ZERO*) OUTER-RAD SW RS STROKE SO)
 ;   Derived type: (FUNCTION
 ;                  (WSVG::WSVG NUMBER &KEY (:XY LIST) (:OUTER-RAD T)
 ;                   (:SW T) (:RS T) (:STROKE T) (:SO T))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     draw a circled filled with concentric circles. use rs to set density.
 ;   Source file: /data/x/weird/src/draw/svg.lisp
```

#### WSVG:WPATH

```
:missing:todo:

 ; WSVG:WPATH
 ;   [symbol]
```

