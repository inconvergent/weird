

(asdf:defsystem #:weird
  :description "A System for Making Generative Systems"
  :version "7.1.0"
  :author "anders hoff/inconvergent"
  :licence "MIT"
  :in-order-to ((asdf:test-op (asdf:test-op #:weird/tests)))
  :pathname "src/"
  :serial nil
  :depends-on (#:veq #:lparallel #:alexandria
               #:cl-json #:cl-svg #:zpng)
  :components ((:file "packages")
               (:file "init" :depends-on ("packages"))
               (:file "config" :depends-on ("init"))
               (:file "utils" :depends-on ("config"))
               (:file "parallel/main" :depends-on ("utils"))
               (:file "dat" :depends-on ("utils"))
               (:file "docs" :depends-on ("dat"))
               (:file "state" :depends-on ("utils"))
               (:file "hset" :depends-on ("utils"))
               (:file "math" :depends-on ("utils"))
               (:file "rnd/macros" :depends-on ("utils"))
               (:file "rnd/rnd" :depends-on ("rnd/macros"))
               (:file "rnd/2rnd" :depends-on ("rnd/rnd"))
               (:file "rnd/3rnd" :depends-on ("rnd/rnd"))
               (:file "rnd/walkers" :depends-on ("rnd/2rnd" "rnd/3rnd"))
               (:file "fn" :depends-on ("rnd/rnd"))
               (:file "gridfont/main" :depends-on ("utils"))
               (:file "draw/bzspl" :depends-on ("rnd/rnd"))
               (:file "draw/pigment" :depends-on ("utils"))
               (:file "draw/ortho" :depends-on ("utils"))
               (:file "draw/simplify-path" :depends-on ("utils"))
               (:file "draw/jpath" :depends-on ("utils"))
               (:file "draw/svg" :depends-on ("draw/simplify-path" "draw/jpath"))
               (:file "graph/main" :depends-on ("hset"))
               (:file "graph/paths" :depends-on ("graph/main"))
               (:file "graph/edge-set" :depends-on ("graph/main"))
               (:file "graph/mst-cycle" :depends-on ("graph/main"))
               (:file "weir/macros" :depends-on ("utils"))
               (:file "weir/main"
                :depends-on ("graph/paths" "weir/macros" "graph/edge-set"))
               (:file "weir/props" :depends-on ("weir/main"))
               (:file "weir/vert-utils-init" :depends-on ("weir/main"))
               (:file "weir/vert-utils" :depends-on ("weir/vert-utils-init"))
               (:file "weir/planar-cycles"
                :depends-on ("weir/main" "graph/mst-cycle"))
               (:file "weir/paths"
                :depends-on ("weir/props" "draw/simplify-path"))
               (:file "weir/alteration-utils" :depends-on ("weir/vert-utils"))
               (:file "weir/alteration-defalt-macro"
                :depends-on ("weir/alteration-utils"))
               (:file "weir/alterations"
                :depends-on ("weir/alteration-defalt-macro"))
               (:file "weir/with-macro"
                :depends-on ("weir/alteration-utils"))
               (:file "weir/kdtree" :depends-on ("weir/vert-utils"))
               (:file "weir/relneigh" :depends-on ("weir/kdtree"))
               (:file "weir/poly" :depends-on ("weir/main"))
               (:file "weir/poly-isect" :depends-on ("weir/poly"))
               (:file "weir/poly-modify"
                :depends-on ("weir/poly-isect" "draw/ortho"))
               (:file "weir/bvh-util" :depends-on ("weir/macros" "weir/paths"))
               (:file "weir/3bvh" :depends-on ("weir/bvh-util"))
               (:file "weir/extra"
                :depends-on ("weir/props" "weir/vert-utils" "weir/macros"))
               (:file "voxel/init" :depends-on ("weir/extra"))
               (:file "voxel/voxel" :depends-on ("voxel/init"))
               (:file "draw/canvas" :depends-on ("utils"))))


(asdf:defsystem #:weird/tests
  :depends-on (#:weird #:prove)
  :perform (asdf:test-op (o s) (uiop:symbol-call ':weird-tests '#:run-tests))
  :pathname "test/"
  :serial t
  :components ((:file "run")))

