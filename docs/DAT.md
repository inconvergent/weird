#### DAT:DO-LINES-AS-BUFFER

```

  fx will receive a stream (named in). use it like this:
    (loop for x = (read in nil nil)
          while x
          do something)
  

 ; DAT:DO-LINES-AS-BUFFER
 ;   [symbol]
 ; 
 ; DO-LINES-AS-BUFFER names a compiled function:
 ;   Lambda-list: (FN FX &KEY (BUFFER-WIDTH 80))
 ;   Derived type: (FUNCTION (T FUNCTION &KEY (:BUFFER-WIDTH FIXNUM))
 ;                  (VALUES NULL &OPTIONAL))
 ;   Documentation:
 ;     
 ;       fx will receive a stream (named in). use it like this:
 ;         (loop for x = (read in nil nil)
 ;               while x
 ;               do something)
 ; 
 ;   Source file: /data/x/weird/src/dat.lisp
```

#### DAT:EXPORT-DATA

```
:missing:todo:

 ; DAT:EXPORT-DATA
 ;   [symbol]
 ; 
 ; EXPORT-DATA names a compiled function:
 ;   Lambda-list: (O FN &OPTIONAL (POSTFIX .dat))
 ;   Derived type: (FUNCTION (T T &OPTIONAL T) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/dat.lisp
```

#### DAT:IMPORT-ALL-DATA

```
:missing:todo:

 ; DAT:IMPORT-ALL-DATA
 ;   [symbol]
 ; 
 ; IMPORT-ALL-DATA names a compiled function:
 ;   Lambda-list: (FN &OPTIONAL (POSTFIX .dat))
 ;   Derived type: (FUNCTION (T &OPTIONAL T) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/dat.lisp
```

#### DAT:IMPORT-DATA

```
:missing:todo:

 ; DAT:IMPORT-DATA
 ;   [symbol]
 ; 
 ; IMPORT-DATA names a compiled function:
 ;   Lambda-list: (FN &OPTIONAL (POSTFIX .dat))
 ;   Derived type: (FUNCTION (T &OPTIONAL T) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/dat.lisp
```

