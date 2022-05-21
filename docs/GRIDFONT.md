#### GRIDFONT:MAKE

```
:missing:todo:

 ; GRIDFONT:MAKE
 ;   [symbol]
 ; 
 ; MAKE names a compiled function:
 ;   Lambda-list: (&KEY (FN (INTERNAL-PATH-STRING src/gridfont/smooth))
 ;                 (SCALE 2.0) (NL 15.0) (SP 2.0) (XY (LIST 0.0 0.0)))
 ;   Derived type: (FUNCTION
 ;                  (&KEY (:FN T) (:SCALE T) (:NL T) (:SP T) (:XY T))
 ;                  (VALUES GRIDFONT::GRIDFONT &OPTIONAL))
 ;   Source file: /data/x/weird/src/gridfont/main.lisp
```

#### GRIDFONT:NL

```
write a newline

 ; GRIDFONT:NL
 ;   [symbol]
 ; 
 ; NL names a compiled function:
 ;   Lambda-list: (GF &KEY (LEFT (GRIDFONT-LEFT GF)))
 ;   Derived type: (FUNCTION
 ;                  (GRIDFONT::GRIDFONT &KEY (:LEFT SINGLE-FLOAT))
 ;                  (VALUES CONS &OPTIONAL))
 ;   Documentation:
 ;     write a newline
 ;   Source file: /data/x/weird/src/gridfont/main.lisp
```

#### GRIDFONT:UPDATE

```
update gridfont properties

 ; GRIDFONT:UPDATE
 ;   [symbol]
 ; 
 ; UPDATE names a compiled function:
 ;   Lambda-list: (GF &KEY XY SCALE SP NL)
 ;   Derived type: (FUNCTION
 ;                  (GRIDFONT::GRIDFONT &KEY (:XY T) (:SCALE T) (:SP T)
 ;                   (:NL T))
 ;                  (VALUES (OR NULL SINGLE-FLOAT) &OPTIONAL))
 ;   Documentation:
 ;     update gridfont properties
 ;   Source file: /data/x/weird/src/gridfont/main.lisp
```

#### GRIDFONT:WC

```
write single character, c

 ; GRIDFONT:WC
 ;   [symbol]
 ; 
 ; WC names a compiled function:
 ;   Lambda-list: (GF C &KEY XY)
 ;   Derived type: (FUNCTION (GRIDFONT::GRIDFONT T &KEY (:XY T))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     write single character, c
 ;   Source file: /data/x/weird/src/gridfont/main.lisp
```

