#### BVH:BVH

```
:missing:todo:

 ; BVH:BVH
 ;   [symbol]
 ; 
 ; BVH names the structure-class #<STRUCTURE-CLASS BVH:BVH>:
 ;   Class precedence-list: BVH:BVH, STRUCTURE-OBJECT, SB-PCL::SLOT-OBJECT,
 ;                          T
 ;   Direct superclasses: STRUCTURE-OBJECT
 ;   No subclasses.
 ;   Slots:
 ;     BVH::ROOT
 ;       Type: BVH:NODE
 ;       Initform: NIL
 ;     BVH::NORMALS
 ;       Type: T
 ;       Initform: NIL
```

#### BVH:BVH-NORMALS

```
:missing:todo:

 ; BVH:BVH-NORMALS
 ;   [symbol]
 ; 
 ; BVH-NORMALS names a compiled function:
 ;   Lambda-list: (INSTANCE)
 ;   Derived type: (FUNCTION (BVH:BVH) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
 ; 
 ; (SETF BVH-NORMALS) names a compiled function:
 ;   Lambda-list: (VALUE INSTANCE)
 ;   Derived type: (FUNCTION (T BVH:BVH) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
```

#### BVH:BVH-ROOT

```
:missing:todo:

 ; BVH:BVH-ROOT
 ;   [symbol]
 ; 
 ; BVH-ROOT names a compiled function:
 ;   Lambda-list: (INSTANCE)
 ;   Derived type: (FUNCTION (BVH:BVH) (VALUES BVH:NODE &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
```

#### BVH:MAKE-LINE-BBOX-TEST

```
fx: %MAKE-LINE-BBOX-TEST
macro wrapper: MAKE-LINE-BBOX-TEST

defined via veq:fvdef*

 ; BVH:MAKE-LINE-BBOX-TEST
 ;   [symbol]
 ; 
 ; MAKE-LINE-BBOX-TEST names a macro:
 ;   Lambda-list: (&REST REST)
 ;   Documentation:
 ;     fx: %MAKE-LINE-BBOX-TEST
 ;     macro wrapper: MAKE-LINE-BBOX-TEST
 ;     
 ;     defined via veq:fvdef*
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
```

#### BVH:MAKE-RESULT

```
:missing:todo:

 ; BVH:MAKE-RESULT
 ;   [symbol]
```

#### BVH:NODE

```
:missing:todo:

 ; BVH:NODE
 ;   [symbol]
 ; 
 ; NODE names the structure-class #<STRUCTURE-CLASS BVH:NODE>:
 ;   Class precedence-list: BVH:NODE, STRUCTURE-OBJECT,
 ;                          SB-PCL::SLOT-OBJECT, T
 ;   Direct superclasses: STRUCTURE-OBJECT
 ;   No subclasses.
 ;   Slots:
 ;     BVH::L
 ;       Type: T
 ;       Initform: NIL
 ;     BVH::R
 ;       Type: T
 ;       Initform: NIL
 ;     BVH::LEAVES
 ;       Type: LIST
 ;       Initform: NIL
 ;     BVH::MIMA
 ;       Type: VEQ:FVEC
 ;       Initform: (VEQ:F3$LINE 0.0 0.0 0.0 0.0 0.0 0.0)
```

#### BVH:NODE-L

```
:missing:todo:

 ; BVH:NODE-L
 ;   [symbol]
 ; 
 ; NODE-L names a compiled function:
 ;   Lambda-list: (INSTANCE)
 ;   Derived type: (FUNCTION (BVH:NODE) (VALUES T &OPTIONAL))
 ;   Inline proclamation: INLINE (no inline expansion available)
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
 ; 
 ; (SETF NODE-L) names a compiled function:
 ;   Lambda-list: (VALUE INSTANCE)
 ;   Derived type: (FUNCTION (T BVH:NODE) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
```

#### BVH:NODE-LEAVES

```
:missing:todo:

 ; BVH:NODE-LEAVES
 ;   [symbol]
 ; 
 ; NODE-LEAVES names a compiled function:
 ;   Lambda-list: (INSTANCE)
 ;   Derived type: (FUNCTION (BVH:NODE) (VALUES LIST &OPTIONAL))
 ;   Inline proclamation: INLINE (no inline expansion available)
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
 ; 
 ; (SETF NODE-LEAVES) names a compiled function:
 ;   Lambda-list: (VALUE INSTANCE)
 ;   Derived type: (FUNCTION (LIST BVH:NODE) (VALUES LIST &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
```

#### BVH:NODE-MA

```
:missing:todo:

 ; BVH:NODE-MA
 ;   [symbol]
```

#### BVH:NODE-MI

```
:missing:todo:

 ; BVH:NODE-MI
 ;   [symbol]
```

#### BVH:NODE-R

```
:missing:todo:

 ; BVH:NODE-R
 ;   [symbol]
 ; 
 ; NODE-R names a compiled function:
 ;   Lambda-list: (INSTANCE)
 ;   Derived type: (FUNCTION (BVH:NODE) (VALUES T &OPTIONAL))
 ;   Inline proclamation: INLINE (no inline expansion available)
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
 ; 
 ; (SETF NODE-R) names a compiled function:
 ;   Lambda-list: (VALUE INSTANCE)
 ;   Derived type: (FUNCTION (T BVH:NODE) (VALUES T &OPTIONAL))
 ;   Source file: /data/x/weird/src/weir/bvh-util.lisp
```

