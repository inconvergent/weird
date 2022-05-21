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
:missing:todo:

 ; CANVAS:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (&KEY (SIZE 1000))
 ;   Derived type: (FUNCTION (&KEY (:SIZE T))
 ;                  (VALUES CANVAS:CANVAS &OPTIONAL))
 ;   Source file: /data/x/weird/src/draw/canvas.lisp
```

#### CANVAS:SAVE

```
:missing:todo:

 ; CANVAS:SAVE
 ;   [symbol]
 ; 
 ; SAVE names a compiled function:
 ;   Lambda-list: (CANV FN &KEY (GAMMA 1.0))
 ;   Derived type: (FUNCTION (CANVAS:CANVAS T &KEY (:GAMMA SINGLE-FLOAT))
 ;                  *)
 ;   Source file: /data/x/weird/src/draw/canvas.lisp
```

#### CANVAS:SET-GRAY-PIX

```
:missing:todo:

 ; CANVAS:SET-GRAY-PIX
 ;   [symbol]
 ; 
 ; SET-GRAY-PIX names a compiled function:
 ;   Lambda-list: (CANV I J C)
 ;   Derived type: (FUNCTION
 ;                  (T (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) SINGLE-FLOAT)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Inline proclamation: INLINE (inline expansion available)
 ;   Source file: /data/x/weird/src/draw/canvas.lisp
```

#### CANVAS:SET-PIX

```
:missing:todo:

 ; CANVAS:SET-PIX
 ;   [symbol]
 ; 
 ; SET-PIX names a compiled function:
 ;   Lambda-list: (CANV I J R G B)
 ;   Derived type: (FUNCTION
 ;                  (T (UNSIGNED-BYTE 31) (UNSIGNED-BYTE 31) SINGLE-FLOAT
 ;                   SINGLE-FLOAT SINGLE-FLOAT)
 ;                  (VALUES NULL &OPTIONAL))
 ;   Inline proclamation: INLINE (inline expansion available)
 ;   Source file: /data/x/weird/src/draw/canvas.lisp
```

