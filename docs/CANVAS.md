#### CANVAS:CANVAS

```
:missing:todo:

 ; CANVAS:CANVAS
 ;   [symbol]
 ; 
 ; CANVAS names the structure-class #<STRUCTURE-CLASS CANVAS:CANVAS>:
 ;   Class precedence-list: CANVAS:CANVAS, STRUCTURE-OBJECT,
 ;                          SB-PCL::SLOT-OBJECT, T
 ;   Direct superclasses: STRUCTURE-OBJECT
 ;   No subclasses.
 ;   Slots:
 ;     CANVAS::SIZE
 ;       Type: CANVAS::SMALL-INT
 ;       Initform: NIL
 ;     CANVAS::VALS
 ;       Type: (SIMPLE-ARRAY SINGLE-FLOAT)
 ;       Initform: NIL
 ;     CANVAS::INDFX
 ;       Type: FUNCTION
 ;       Initform: NIL
```

#### CANVAS:MAKE

```
make square PNG canvas instance of size to.

 ; CANVAS:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (&KEY (SIZE 1000))
 ;   Derived type: (FUNCTION (&KEY (:SIZE T))
 ;                  (VALUES CANVAS:CANVAS &OPTIONAL))
 ;   Documentation:
 ;     make square PNG canvas instance of size to.
 ;   Source file: /data/x/weird/src/draw/canvas.lisp
```

#### CANVAS:SAVE

```
save as 8 bit PNG file fn with gamma.

 ; CANVAS:SAVE
 ;   [symbol]
 ; 
 ; SAVE names a compiled function:
 ;   Lambda-list: (CANV FN &KEY (GAMMA 1.0))
 ;   Derived type: (FUNCTION (CANVAS:CANVAS T &KEY (:GAMMA SINGLE-FLOAT))
 ;                  *)
 ;   Documentation:
 ;     save as 8 bit PNG file fn with gamma.
 ;   Source file: /data/x/weird/src/draw/canvas.lisp
```

#### CANVAS:SET-GRAY-PIX

```
set (i j) to value c where 0.0 =< c =< 1.0.

 ; CANVAS:SET-GRAY-PIX
 ;   [symbol]
 ; 
 ; SET-GRAY-PIX names a compiled function:
 ;   Lambda-list: (CANV I J C)
 ;   Derived type: (FUNCTION
 ;                  (T (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) SINGLE-FLOAT)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     set (i j) to value c where 0.0 =< c =< 1.0.
 ;   Inline proclamation: INLINE (inline expansion available)
 ;   Source file: /data/x/weird/src/draw/canvas.lisp
```

#### CANVAS:SET-PIX

```
set (i j) to value (r g b) where 0.0 =< r,g,b =< 1.0.

 ; CANVAS:SET-PIX
 ;   [symbol]
 ; 
 ; SET-PIX names a compiled function:
 ;   Lambda-list: (CANV I J R G B)
 ;   Derived type: (FUNCTION
 ;                  (T (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) SINGLE-FLOAT
 ;                   SINGLE-FLOAT SINGLE-FLOAT)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     set (i j) to value (r g b) where 0.0 =< r,g,b =< 1.0.
 ;   Inline proclamation: INLINE (inline expansion available)
 ;   Source file: /data/x/weird/src/draw/canvas.lisp
```

