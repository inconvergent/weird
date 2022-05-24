#### ORTHO:EXPORT-DATA

```
export the neccessary values to recreate ortho

 ; ORTHO:EXPORT-DATA
 ;   [symbol]
 ; 
 ; EXPORT-DATA names a compiled function:
 ;   Lambda-list: (P)
 ;   Derived type: (FUNCTION (ORTHO::ORTHO) (VALUES CONS &OPTIONAL))
 ;   Documentation:
 ;     export the neccessary values to recreate ortho
 ;   Source file: /data/x/weird/src/draw/ortho.lisp
```

#### ORTHO:IMPORT-DATA

```
recreate proj from an a list exported by ortho:export-data

 ; ORTHO:IMPORT-DATA
 ;   [symbol]
 ; 
 ; IMPORT-DATA names a compiled function:
 ;   Lambda-list: (P)
 ;   Derived type: (FUNCTION (LIST) *)
 ;   Documentation:
 ;     recreate proj from an a list exported by ortho:export-data
 ;   Source file: /data/x/weird/src/draw/ortho.lisp
```

#### ORTHO:MAKE

```

  make projection.

  default up is (0 0 1)
  default cam is (1000 1000 1000)
  if look and vpn are unset, the camera will look at the origin.

  default scale is 1
  default xy is (0 0)
  

 ; ORTHO:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (&KEY (UP (F3$POINT 0.0 0.0 1.0))
 ;                 (CAM (F3$POINT 1000.0 1000.0 1000.0))
 ;                 (XY (F2$POINT 500.0 500.0)) (S 1.0) VPN LOOK
 ;                 (RAYLEN 5000.0))
 ;   Derived type: (FUNCTION
 ;                  (&KEY (:UP (SIMPLE-ARRAY SINGLE-FLOAT))
 ;                   (:CAM (SIMPLE-ARRAY SINGLE-FLOAT))
 ;                   (:XY (SIMPLE-ARRAY SINGLE-FLOAT)) (:S SINGLE-FLOAT)
 ;                   (:VPN T) (:LOOK T) (:RAYLEN SINGLE-FLOAT))
 ;                  (VALUES ORTHO::ORTHO &OPTIONAL))
 ;   Documentation:
 ;     
 ;       make projection.
 ;     
 ;       default up is (0 0 1)
 ;       default cam is (1000 1000 1000)
 ;       if look and vpn are unset, the camera will look at the origin.
 ;     
 ;       default scale is 1
 ;       default xy is (0 0)
 ; 
 ;   Source file: /data/x/weird/src/draw/ortho.lisp
```

#### ORTHO:MAKE-RAYFX

```
cast a ray in direction -vpn from pt

 ; ORTHO:MAKE-RAYFX
 ;   [symbol]
 ; 
 ; MAKE-RAYFX names a compiled function:
 ;   Lambda-list: (PROJ)
 ;   Derived type: (FUNCTION (ORTHO::ORTHO) (VALUES FUNCTION &OPTIONAL))
 ;   Documentation:
 ;     cast a ray in direction -vpn from pt
 ;   Source file: /data/x/weird/src/draw/ortho.lisp
```

#### ORTHO:PAN-CAM

```
:missing:todo:

 ; ORTHO:PAN-CAM
 ;   [symbol]
```

#### ORTHO:PAN-XY

```
:missing:todo:

 ; ORTHO:PAN-XY
 ;   [symbol]
```

#### ORTHO:PROJECT

```
docstring for %PROJECT
project single point. returns (values x y d)

 ; ORTHO:PROJECT
 ;   [symbol]
 ; 
 ; PROJECT names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     docstring for %PROJECT
 ;     project single point. returns (values x y d)
 ;   Source file: /data/x/weird/src/draw/ortho.lisp
```

#### ORTHO:PROJECT\*

```
project a path #(x1 y1 z1 x2 y2 z2 ...).
   returns projected path and distances: (values #(px1 py1 px2 py2 ...)
                                                 #(d1 d2 ...)) 

 ; ORTHO:PROJECT*
 ;   [symbol]
 ; 
 ; PROJECT* names a compiled function:
 ;   Lambda-list: (PROJ PATH)
 ;   Derived type: (FUNCTION (ORTHO::ORTHO (SIMPLE-ARRAY SINGLE-FLOAT))
 ;                  (VALUES (SIMPLE-ARRAY SINGLE-FLOAT . #1=((*)))
 ;                          (SIMPLE-ARRAY SINGLE-FLOAT . #1#) &OPTIONAL))
 ;   Documentation:
 ;     project a path #(x1 y1 z1 x2 y2 z2 ...).
 ;        returns projected path and distances: (values #(px1 py1 px2 py2 ...)
 ;                                                      #(d1 d2 ...))
 ;   Source file: /data/x/weird/src/draw/ortho.lisp
```

#### ORTHO:PROJECT-OFFSET

```
:missing:todo:

 ; ORTHO:PROJECT-OFFSET
 ;   [symbol]
```

#### ORTHO:PROJECT-OFFSET\*

```
:missing:todo:

 ; ORTHO:PROJECT-OFFSET*
 ;   [symbol]
```

#### ORTHO:ROTATE

```
:missing:todo:

 ; ORTHO:ROTATE
 ;   [symbol]
```

#### ORTHO:UPDATE

```

  update projection parameters.

  use vpn to set view plane normal directly, or look to set view plane normal
  relative to camera.

  ensures that internal state is updated appropriately.
  

 ; ORTHO:UPDATE
 ;   [symbol]
 ; 
 ; UPDATE names a compiled function:
 ;   Lambda-list: (PROJ &KEY S XY UP CAM VPN LOOK)
 ;   Derived type: (FUNCTION
 ;                  (ORTHO::ORTHO &KEY (:S T) (:XY T) (:UP T) (:CAM T)
 ;                   (:VPN T) (:LOOK T))
 ;                  (VALUES ORTHO::ORTHO &OPTIONAL))
 ;   Documentation:
 ;     
 ;       update projection parameters.
 ;     
 ;       use vpn to set view plane normal directly, or look to set view plane normal
 ;       relative to camera.
 ;     
 ;       ensures that internal state is updated appropriately.
 ; 
 ;   Source file: /data/x/weird/src/draw/ortho.lisp
```

#### ORTHO:ZOOM

```
:missing:todo:

 ; ORTHO:ZOOM
 ;   [symbol]
```

