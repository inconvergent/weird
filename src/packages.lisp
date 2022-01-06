(defpackage #:weird
  (:use #:common-lisp)
  (:export
   #:*opt*
   #:abbrev
   #:aif
   #:animate
   #:append-number
   #:append-postfix
   #:awf
   #:awg
   #:cmd-args
   #:define-struct-load-form
   #:dsb
   #:ensure-filename
   #:ensure-vector
   #:f?
   #:filter-by-predicate
   #:group
   #:i?
   #:internal-path-string
   #:it
   #:last*
   #:lst>n
   #:lvextend
   #:mac
   #:make-adjustable-vector
   #:make-animation
   #:mkstr
   #:mvb
   #:mvc
   #:numshow
   #:pos-int
   #:print-every
   #:psymb
   #:reread
   #:string-list-concat
   #:symb
   #:template
   #:terminate
   #:to-adjustable-vector
   #:to-list
   #:to-vector
   #:tree-find
   #:tree-find-all
   #:undup
   #:v?
   #:vector-first
   #:vector-last
   #:vextend
   #:with-struct))

(defpackage #:fn (:use #:common-lisp) (:export #:fn))

(defpackage #:parallel (:use #:common-lisp)
  (:export #:create-channel #:end #:info #:init))

(defpackage #:ortho
  (:use #:common-lisp)
  (:export #:export-data #:import-data #:make #:make-rayfx #:pan-cam #:pan-xy
           #:project #:project* #:project-offset #:project-offset* #:rotate
           #:update #:zoom)
  (:import-from #:weird #:*opt* #:with-struct))

(defpackage #:math
  (:use #:common-lisp)
  (:export #:add #:argmax #:argmin #:clamp #:close-path #:close-path*
           #:copy-sort #:imod #:integer-search #:last* #:lerp #:lget #:linspace
           #:list>than #:ll-transpose #:lpos #:mod2 #:mult #:nrep #:range
           #:range-search #:sub)
  (:import-from #:weird #:*opt* #:ensure-vector #:pos-int))

(defpackage #:rnd
  (:use #:common-lisp)
  (:export
    #:3in-box
    #:3in-cube
    #:3in-sphere
    #:3nin-box
    #:3nin-cube
    #:3nin-sphere
    #:3non-line
    #:3non-line*
    #:3non-sphere
    #:3on-line
    #:3on-line*
    #:3on-sphere
    #:2in-circ
    #:2in-rect
    #:2in-square
    #:2nin-circ
    #:2nin-rect
    #:2nin-square
    #:2non-circ
    #:2non-line
    #:2non-line*
    #:2on-circ
    #:2on-line
    #:2on-line*
    #:array-split
    #:bernoulli
    #:either
    #:make-rnd-state
    #:max-distance-sample
    #:norm
    #:nrnd
    #:nrnd*
    #:nrnd-from
    #:nrnd-from*
    #:nrndi
    #:nrndrng
    #:nrndrngi
    #:prob
    #:rcond
    #:rep
    #:rnd
    #:rnd*
    #:rndget
    #:rndi
    #:rndrng
    #:rndrngi
    #:rndspace
    #:rndspacei
    #:set-rnd-state
    #:shuffle)
  (:import-from #:weird
    #:*opt*
    #:mvb
    #:ensure-vector
    #:make-adjustable-vector
    #:to-vector
    #:vextend))

(defpackage #:state
  (:use #:common-lisp)
  (:export #:awith #:it #:lget #:lset #:make #:sget #:to-list #:with))

(defpackage #:pigment
  (:use #:common-lisp)
  (:export #:as-hsv #:black #:blood #:blue #:cmyk #:copy #:cyan #:dark
           #:from-list #:gray #:green #:hsv #:magenta #:mdark #:orange
           #:red #:rgb #:rgba #:scale #:scale! #:to-hex #:to-list
           #:to-list* #:transparent #:vdark #:white #:with)
  (:import-from #:weird #:*opt* #:pos-int #:ensure-vector))

(defpackage #:hset
  (:use #:common-lisp)
  (:export #:add #:add* #:copy #:del #:del* #:inter #:make #:mem
           #:mem* #:num #:symdiff #:uni #:to-list)
  (:import-from #:weird #:*opt*))

(defpackage #:graph
  (:use #:common-lisp)
  (:export
    #:add
    #:copy
    #:cycle->edge-set
    #:cycle-basis->edge-sets
    #:del
    #:del-simple-filaments
    #:edge-set->graph
    #:edge-set->path
    #:edge-set-symdiff
    #:edge-sets->cycle-basis
    #:get-segments
    #:get-cycle-basis
    #:get-edges
    #:get-incident-edges
    #:get-incident-verts
    #:get-min-spanning-tree
    #:get-num-edges
    #:get-num-verts
    #:get-spanning-tree
    #:get-verts
    #:make
    #:mem
    #:path->edge-set
    #:vmem
    #:walk-graph
    #:with-graph-edges)
  (:import-from #:weird
    #:*opt*
    #:make-adjustable-vector
    #:to-list
    #:to-vector
    #:vector-last
    #:vextend
    #:with-struct))

(defpackage #:bzspl
  (:use #:common-lisp)
  (:export #:adaptive-pos #:len #:make #:pos #:pos* #:rndpos)
  (:import-from #:weird #:*opt* #:pos-int #:make-adjustable-vector #:to-list
                #:with-struct))

(defpackage #:simplify
  (:use #:common-lisp)
  (:export #:path)
  (:import-from #:weird #:*opt* #:make-adjustable-vector #:vextend))

; (defpackage #:hatch
;   (:use #:common-lisp)
;   (:export #:hatch #:stitch)
;   (:import-from #:weird #:*opt* #:ensure-vector #:vector-last
;                 #:make-adjustable-vector #:to-list #:vextend))

(defpackage #:jpath
  (:use #:common-lisp)
  (:export #:jpath #:path->joints #:path->diagonals)
  (:import-from #:weird #:*opt* #:ensure-vector #:make-adjustable-vector
                #:to-adjustable-vector #:to-list #:to-vector #:vextend))

(defpackage #:dat
  (:use #:common-lisp)
  (:export #:do-lines-as-buffer #:export-data #:import-data)
  (:import-from #:weird #:*opt* #:ensure-filename))

(defpackage #:gridfont
  (:use #:common-lisp)
  (:export #:make #:nl #:update #:wc)
  (:import-from #:weird #:*opt* #:ensure-filename
                #:internal-path-string #:with-struct))

(defpackage #:wsvg
  (:use #:common-lisp)
  (:export #:*half-long* #:*half-short* #:*long* #:*short* #:bzspl #:carc
           #:circ #:compound #:draw #:wcirc #:hatch #:jpath #:make #:make*
           #:path #:rect #:save #:square #:update #:wpath)
  (:import-from #:weird #:dsb #:ensure-filename #:with-struct))

(defpackage #:weir
  (:use #:common-lisp)
  (:export
    #:2add-path!
    #:2av!
    #:2avs!
    #:2cut-to-area!
    #:2get-planar-cycles
    #:2gv
    #:2gvs
    #:2intersect-all!
    #:2nn
    #:2rad
    #:2relneigh!
    #:2simplify-segments!
    #:2walk-graph
    #:3->2
    #:3add-box!
    #:3add-cube!
    #:3av!
    #:3avs!
    #:3gv
    #:3gvs
    #:add-edge!
    #:add-edges!
    #:add-grp!
    #:add-path-ind!
    #:ae!
    #:all-grps->main!
    #:append-edge!
    #:build-kdtree
    #:center!
    #:clear!
    #:clear-prop
    #:clear-specific-prop
    #:clear-specific-props
    #:clone-grp!
    #:collapse-verts!
    #:copy-edge-props
    #:copy-vert-props
    #:de!
    #:del-edge!
    #:del-grp!
    #:del-path!
    #:edge-exists
    #:edge-has-prop
    #:edge-prop->path
    #:edge-prop-nxt-vert
    #:export-verts-grp
    #:get-all-grps
    #:get-alt-res
    #:get-alteration-result-list
    #:get-alteration-result-map
    #:get-edge-prop
    #:get-edge-props
    #:get-edges
    #:get-edges-with-prop
    #:get-grp
    #:get-grp-as-path
    #:get-grp-num-verts
    #:get-grp-prop
    #:get-grp-verts
    #:get-incident-edges
    #:get-incident-rotated-vert
    #:get-incident-verts
    #:get-min-spanning-tree
    #:get-num-edges
    #:get-num-grps
    #:get-num-verts
    #:get-segments
    #:get-spanning-tree
    #:get-vert-inds
    #:get-vert-prop
    #:get-vert-props
    #:get-verts-with-prop
    #:get-west-most-vert
    #:grp-exists
    #:import-verts-grp
    #:is-vert-in-grp
    #:itr-edges
    #:itr-grp-verts
    #:itr-grps
    #:itr-verts
    #:ladd-edge!
    #:lcollapse-verts!
    #:ldel-edge!
    #:lsplit-edge!
    #:lsplit-edge-ind!
    #:lswap-edge!
    #:make
    #:mcopy-edge-props
    #:mcopy-vert-props
    #:mset-edge-prop
    #:mset-vert-prop
    #:reset-grp!
    #:set-edge-prop
    #:set-grp-prop
    #:set-vert-prop
    #:split-edge-ind!
    #:swap-edge!
    #:vert-has-prop
    #:verts
    #:with
    #:with-gs
    #:with-rnd-edge
    #:with-rnd-vert)
  (:import-from #:weird
    #:*opt*
    #:awf
    #:awg
    #:dsb
    #:filter-by-predicate
    #:make-adjustable-vector
    #:mkstr
    #:mvb
    #:mvc
    #:to-list
    #:to-vector
    #:tree-find
    #:vextend
    #:with-struct)
  (:import-from #:math #:last*))
