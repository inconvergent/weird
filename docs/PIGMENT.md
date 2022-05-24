#### PIGMENT:AS-HSV

```
return pigment as (list h s v a)

 ; PIGMENT:AS-HSV
 ;   [symbol]
 ; 
 ; AS-HSV names a compiled function:
 ;   Lambda-list: (C)
 ;   Derived type: (FUNCTION (PIGMENT::RGBA) (VALUES CONS &OPTIONAL))
 ;   Documentation:
 ;     return pigment as (list h s v a)
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:BLACK

```
black with alpha a.

 ; PIGMENT:BLACK
 ;   [symbol]
 ; 
 ; BLACK names a compiled function:
 ;   Lambda-list: (&OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION (&OPTIONAL SINGLE-FLOAT) *)
 ;   Documentation:
 ;     black with alpha a.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:CMYK

```
create pigment from (c m y k a). a is optional.

 ; PIGMENT:CMYK
 ;   [symbol]
 ; 
 ; CMYK names a compiled function:
 ;   Lambda-list: (C M Y K &OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION
 ;                  (SINGLE-FLOAT SINGLE-FLOAT SINGLE-FLOAT SINGLE-FLOAT
 ;                   &OPTIONAL SINGLE-FLOAT)
 ;                  *)
 ;   Documentation:
 ;     create pigment from (c m y k a). a is optional.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:COPY

```
copy a pigment instance.

 ; PIGMENT:COPY
 ;   [symbol]
 ; 
 ; COPY names a compiled function:
 ;   Lambda-list: (C)
 ;   Derived type: (FUNCTION (PIGMENT::RGBA)
 ;                  (VALUES PIGMENT::RGBA &OPTIONAL))
 ;   Documentation:
 ;     copy a pigment instance.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:CYAN

```
cyan with sat, val, alpha.

 ; PIGMENT:CYAN
 ;   [symbol]
 ; 
 ; CYAN names a compiled function:
 ;   Lambda-list: (&KEY (SAT 1.0) (VAL 1.0) (ALPHA 1.0))
 ;   Derived type: (FUNCTION (&KEY (:SAT T) (:VAL T) (:ALPHA T)) *)
 ;   Documentation:
 ;     cyan with sat, val, alpha.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:DARK

```
0.2 gray with alpha a.

 ; PIGMENT:DARK
 ;   [symbol]
 ; 
 ; DARK names a compiled function:
 ;   Lambda-list: (&OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION (&OPTIONAL SINGLE-FLOAT) *)
 ;   Documentation:
 ;     0.2 gray with alpha a.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:GRAY

```
v gray with alpha a.

 ; PIGMENT:GRAY
 ;   [symbol]
 ; 
 ; GRAY names a compiled function:
 ;   Lambda-list: (V &OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION (SINGLE-FLOAT &OPTIONAL SINGLE-FLOAT) *)
 ;   Documentation:
 ;     v gray with alpha a.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:GREEN

```
green with alpha a.

 ; PIGMENT:GREEN
 ;   [symbol]
 ; 
 ; GREEN names a compiled function:
 ;   Lambda-list: (&OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION (&OPTIONAL SINGLE-FLOAT) *)
 ;   Documentation:
 ;     green with alpha a.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:HSV

```
create pigment from (h s v a). a is optional.

 ; PIGMENT:HSV
 ;   [symbol]
 ; 
 ; HSV names a compiled function:
 ;   Lambda-list: (H S V &OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION
 ;                  (SINGLE-FLOAT SINGLE-FLOAT SINGLE-FLOAT &OPTIONAL
 ;                   SINGLE-FLOAT)
 ;                  *)
 ;   Documentation:
 ;     create pigment from (h s v a). a is optional.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:MAGENTA

```
magenta with sat, val, alpha.

 ; PIGMENT:MAGENTA
 ;   [symbol]
 ; 
 ; MAGENTA names a compiled function:
 ;   Lambda-list: (&KEY (SAT 1.0) (VAL 1.0) (ALPHA 1.0))
 ;   Derived type: (FUNCTION (&KEY (:SAT T) (:VAL T) (:ALPHA T)) *)
 ;   Documentation:
 ;     magenta with sat, val, alpha.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:MDARK

```
0.3 gray with alpha a.

 ; PIGMENT:MDARK
 ;   [symbol]
 ; 
 ; MDARK names a compiled function:
 ;   Lambda-list: (&OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION (&OPTIONAL SINGLE-FLOAT) *)
 ;   Documentation:
 ;     0.3 gray with alpha a.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:RED

```
red with alpha a.

 ; PIGMENT:RED
 ;   [symbol]
 ; 
 ; RED names a compiled function:
 ;   Lambda-list: (&OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION (&OPTIONAL SINGLE-FLOAT) *)
 ;   Documentation:
 ;     red with alpha a.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:RGB

```
synonym for make.

 ; PIGMENT:RGB
 ;   [symbol]
 ; 
 ; RGB names a compiled function:
 ;   Lambda-list: (R G B &OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION
 ;                  (SINGLE-FLOAT SINGLE-FLOAT SINGLE-FLOAT &OPTIONAL
 ;                   SINGLE-FLOAT)
 ;                  *)
 ;   Documentation:
 ;     synonym for make.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:SCALE

```
return a new pigment scaled by s.

 ; PIGMENT:SCALE
 ;   [symbol]
 ; 
 ; SCALE names a compiled function:
 ;   Lambda-list: (C S)
 ;   Derived type: (FUNCTION (PIGMENT::RGBA SINGLE-FLOAT)
 ;                  (VALUES PIGMENT::RGBA &OPTIONAL))
 ;   Documentation:
 ;     return a new pigment scaled by s.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:SCALE!

```
scale this pigment by s.

 ; PIGMENT:SCALE!
 ;   [symbol]
 ; 
 ; SCALE! names a compiled function:
 ;   Lambda-list: (C S)
 ;   Derived type: (FUNCTION (PIGMENT::RGBA SINGLE-FLOAT)
 ;                  (VALUES PIGMENT::RGBA &OPTIONAL))
 ;   Documentation:
 ;     scale this pigment by s.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:TO-HEX

```
return pigment colour as hex string.

 ; PIGMENT:TO-HEX
 ;   [symbol]
 ; 
 ; TO-HEX names a compiled function:
 ;   Lambda-list: (C)
 ;   Derived type: (FUNCTION (PIGMENT::RGBA)
 ;                  (VALUES SIMPLE-STRING SINGLE-FLOAT &OPTIONAL))
 ;   Documentation:
 ;     return pigment colour as hex string.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:TO-LIST

```
return (r/a g/a b/a a) for pre-multiplied alpha (r g b).

 ; PIGMENT:TO-LIST
 ;   [symbol]
 ; 
 ; TO-LIST names a compiled function:
 ;   Lambda-list: (C)
 ;   Derived type: (FUNCTION (PIGMENT::RGBA) (VALUES CONS &OPTIONAL))
 ;   Documentation:
 ;     return (r/a g/a b/a a) for pre-multiplied alpha (r g b).
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:TO-LIST\*

```
return (r g b a) where (r g b) are pre-multiplied.

 ; PIGMENT:TO-LIST*
 ;   [symbol]
 ; 
 ; TO-LIST* names a compiled function:
 ;   Lambda-list: (C)
 ;   Derived type: (FUNCTION (PIGMENT::RGBA) (VALUES CONS &OPTIONAL))
 ;   Documentation:
 ;     return (r g b a) where (r g b) are pre-multiplied.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:TRANSPARENT

```
fully transparent. by defninition this has no colour.

 ; PIGMENT:TRANSPARENT
 ;   [symbol]
 ; 
 ; TRANSPARENT names a compiled function:
 ;   Lambda-list: ()
 ;   Derived type: (FUNCTION NIL *)
 ;   Documentation:
 ;     fully transparent. by defninition this has no colour.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:VDARK

```
0.1 gray with alpha a.

 ; PIGMENT:VDARK
 ;   [symbol]
 ; 
 ; VDARK names a compiled function:
 ;   Lambda-list: (&OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION (&OPTIONAL SINGLE-FLOAT) *)
 ;   Documentation:
 ;     0.1 gray with alpha a.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:WHITE

```
white with alpha a.

 ; PIGMENT:WHITE
 ;   [symbol]
 ; 
 ; WHITE names a compiled function:
 ;   Lambda-list: (&OPTIONAL (A 1.0))
 ;   Derived type: (FUNCTION (&OPTIONAL SINGLE-FLOAT) *)
 ;   Documentation:
 ;     white with alpha a.
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

#### PIGMENT:WITH

```
macro: (with (pigment r g b a) (list r g b a)).

 ; PIGMENT:WITH
 ;   [symbol]
 ; 
 ; WITH names a macro:
 ;   Lambda-list: ((C R G B A) &BODY BODY)
 ;   Documentation:
 ;     macro: (with (pigment r g b a) (list r g b a)).
 ;   Source file: /data/x/weird/src/draw/pigment.lisp
```

