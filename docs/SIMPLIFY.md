#### SIMPLIFY:PATH

```

  simplify path, pts.
  lim is the distance of candidate pt to candidate line
  returns new path
  

 ; SIMPLIFY:PATH
 ;   [symbol]
 ; 
 ; PATH names a compiled function:
 ;   Lambda-list: (PTS &KEY (LIM 1.0))
 ;   Derived type: (FUNCTION
 ;                  ((SIMPLE-ARRAY SINGLE-FLOAT) &KEY (:LIM SINGLE-FLOAT))
 ;                  (VALUES (SIMPLE-ARRAY SINGLE-FLOAT (*))
 ;                          (VECTOR (UNSIGNED-BYTE 31)) &OPTIONAL))
 ;   Documentation:
 ;     
 ;       simplify path, pts.
 ;       lim is the distance of candidate pt to candidate line
 ;       returns new path
 ; 
 ;   Source file: /data/x/weird/src/draw/simplify-path.lisp
```

