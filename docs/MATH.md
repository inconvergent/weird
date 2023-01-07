#### MATH:ADD

```
element wise + for two lists of FIXNUM

 ; MATH:ADD
 ;   [symbol]
 ; 
 ; ADD names a compiled function:
 ;   Lambda-list: (AA BB)
 ;   Derived type: (FUNCTION (LIST LIST) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     element wise + for two lists of FIXNUM
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:ARGMAX

```
returns (values iv v).
where iv is the index of v and v is the highest value in ll.

 ; MATH:ARGMAX
 ;   [symbol]
 ; 
 ; ARGMAX names a compiled function:
 ;   Lambda-list: (LL &OPTIONAL (KEY (FUNCTION IDENTITY)))
 ;   Derived type: (FUNCTION (LIST &OPTIONAL FUNCTION)
 ;                  (VALUES UNSIGNED-BYTE T &OPTIONAL))
 ;   Documentation:
 ;     returns (values iv v).
 ;     where iv is the index of v and v is the highest value in ll.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:ARGMIN

```
returns (values iv v).
where iv is the index of v and v is the smallest value in ll.

 ; MATH:ARGMIN
 ;   [symbol]
 ; 
 ; ARGMIN names a compiled function:
 ;   Lambda-list: (LL &OPTIONAL (KEY (FUNCTION IDENTITY)))
 ;   Derived type: (FUNCTION (LIST &OPTIONAL FUNCTION)
 ;                  (VALUES UNSIGNED-BYTE T &OPTIONAL))
 ;   Documentation:
 ;     returns (values iv v).
 ;     where iv is the index of v and v is the smallest value in ll.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:CLOSE-PATH

```
append first element of p to end of p.

 ; MATH:CLOSE-PATH
 ;   [symbol]
 ; 
 ; CLOSE-PATH names a compiled function:
 ;   Lambda-list: (P)
 ;   Derived type: (FUNCTION (LIST) (VALUES CONS &OPTIONAL))
 ;   Documentation:
 ;     append first element of p to end of p.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:CLOSE-PATH\*

```
append last element of p to front of p.

 ; MATH:CLOSE-PATH*
 ;   [symbol]
 ; 
 ; CLOSE-PATH* names a compiled function:
 ;   Lambda-list: (P)
 ;   Derived type: (FUNCTION (LIST) (VALUES CONS &OPTIONAL))
 ;   Documentation:
 ;     append last element of p to front of p.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:COPY-SORT

```
sort a without side effects to a. not very efficent.

 ; MATH:COPY-SORT
 ;   [symbol]
 ; 
 ; COPY-SORT names a compiled function:
 ;   Lambda-list: (A FX &KEY (KEY (FUNCTION IDENTITY)))
 ;   Derived type: (FUNCTION (SEQUENCE T &KEY (:KEY T))
 ;                  (VALUES SEQUENCE &OPTIONAL))
 ;   Documentation:
 ;     sort a without side effects to a. not very efficent.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:IMOD

```
(mod (+ i inc) m) for fixnums

 ; MATH:IMOD
 ;   [symbol]
 ; 
 ; IMOD names a compiled function:
 ;   Lambda-list: (I INC M)
 ;   Derived type: (FUNCTION (FIXNUM FIXNUM FIXNUM)
 ;                  (VALUES
 ;                   (INTEGER -4611686018427387903 4611686018427387903)
 ;                   &OPTIONAL))
 ;   Documentation:
 ;     (mod (+ i inc) m) for fixnums
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:INTEGER-SEARCH

```
binary integer search. assumes presorted list of integers

 ; MATH:INTEGER-SEARCH
 ;   [symbol]
 ; 
 ; INTEGER-SEARCH names a compiled function:
 ;   Lambda-list: (AA V &AUX (N (LENGTH AA)))
 ;   Derived type: (FUNCTION (VECTOR FIXNUM)
 ;                  (VALUES (OR NULL (MOD 4611686018427387901)) &OPTIONAL))
 ;   Documentation:
 ;     binary integer search. assumes presorted list of integers
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:LAST\*

```
:missing:todo:

 ; MATH:LAST*
 ;   [symbol]
 ; 
 ; LAST* names a compiled function:
 ;   Lambda-list: (L)
 ;   Derived type: (FUNCTION (LIST) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:LERP

```
:missing:todo:

 ; MATH:LERP
 ;   [symbol]
```

#### MATH:LGET

```
:missing:todo:

 ; MATH:LGET
 ;   [symbol]
```

#### MATH:LINSPACE

```
n veq:ffs from a to b.

 ; MATH:LINSPACE
 ;   [symbol]
 ; 
 ; LINSPACE names a compiled function:
 ;   Lambda-list: (N A B &KEY (END T))
 ;   Derived type: (FUNCTION
 ;                  ((UNSIGNED-BYTE 31) SINGLE-FLOAT SINGLE-FLOAT &KEY
 ;                   (:END BOOLEAN))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     n veq:ffs from a to b.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:LIST>THAN

```
list is longer than n?

 ; MATH:LIST>THAN
 ;   [symbol]
 ; 
 ; LIST>THAN names a compiled function:
 ;   Lambda-list: (L N)
 ;   Derived type: (FUNCTION (LIST (UNSIGNED-BYTE 31))
 ;                  (VALUES BOOLEAN &OPTIONAL))
 ;   Documentation:
 ;     list is longer than n?
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:LL-TRANSPOSE

```
transpose list of lists.
assumes all initial lists in l have the same length.

 ; MATH:LL-TRANSPOSE
 ;   [symbol]
 ; 
 ; LL-TRANSPOSE names a compiled function:
 ;   Lambda-list: (L)
 ;   Derived type: (FUNCTION (LIST) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     transpose list of lists.
 ;     assumes all initial lists in l have the same length.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:LPOS

```
apply fx to every element in ll. 

 ; MATH:LPOS
 ;   [symbol]
 ; 
 ; LPOS names a compiled function:
 ;   Lambda-list: (LL &KEY (FX (FUNCTION FIRST)))
 ;   Derived type: (FUNCTION (LIST &KEY (:FX FUNCTION))
 ;                  (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     apply fx to every element in ll.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:MOD2

```
(mod i 2) for fixnums.

 ; MATH:MOD2
 ;   [symbol]
 ; 
 ; MOD2 names a compiled function:
 ;   Lambda-list: (I)
 ;   Derived type: (FUNCTION (FIXNUM) (VALUES BIT &OPTIONAL))
 ;   Documentation:
 ;     (mod i 2) for fixnums.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:MULT

```
element wise * for two lists of FIXNUM

 ; MATH:MULT
 ;   [symbol]
 ; 
 ; MULT names a compiled function:
 ;   Lambda-list: (AA BB)
 ;   Derived type: (FUNCTION (LIST LIST) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     element wise * for two lists of FIXNUM
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:NREP

```
returns list with body :evaluated: n times.

 ; MATH:NREP
 ;   [symbol]
 ; 
 ; NREP names a macro:
 ;   Lambda-list: (N &BODY BODY)
 ;   Documentation:
 ;     returns list with body :evaluated: n times.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:RANGE

```
fixnums from 0 to a, or a to b.

 ; MATH:RANGE
 ;   [symbol]
 ; 
 ; RANGE names a compiled function:
 ;   Lambda-list: (A &OPTIONAL (B NIL))
 ;   Derived type: (FUNCTION (FIXNUM &OPTIONAL T) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     fixnums from 0 to a, or a to b.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:RANGE-SEARCH

```
binary range search.  range must be sorted in ascending order. f is a value
inside the range you are looking for.

 ; MATH:RANGE-SEARCH
 ;   [symbol]
 ; 
 ; RANGE-SEARCH names a compiled function:
 ;   Lambda-list: (RANGES F &AUX (N (1- (LENGTH RANGES)))
 ;                 (RANGES* (ENSURE-VECTOR RANGES)))
 ;   Derived type: (FUNCTION (T T)
 ;                  (VALUES (MOD 4611686018427387901) &OPTIONAL))
 ;   Documentation:
 ;     binary range search.  range must be sorted in ascending order. f is a value
 ;     inside the range you are looking for.
 ;   Source file: /data/x/weird/src/math.lisp
```

#### MATH:SUB

```
element wise - for two lists of FIXNUM

 ; MATH:SUB
 ;   [symbol]
 ; 
 ; SUB names a compiled function:
 ;   Lambda-list: (AA BB)
 ;   Derived type: (FUNCTION (LIST LIST) (VALUES LIST &OPTIONAL))
 ;   Documentation:
 ;     element wise - for two lists of FIXNUM
 ;   Source file: /data/x/weird/src/math.lisp
```

