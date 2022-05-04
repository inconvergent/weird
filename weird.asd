

(asdf:defsystem #:weird
  :description "A System for Making Generative Systems"
  :version "6.0.3"
  :author "anders hoff/inconvergent"
  :licence "MIT"
  :in-order-to ((asdf:test-op (asdf:test-op #:weird/tests)))
  :pathname "src/"
  :serial nil
  :depends-on (#:alexandria #:cl-json #:cl-svg #:lparallel
               #:veq #:zpng #:split-sequence #:parse-number)
  :components ((:file "packages")
               (:file "config" :depends-on ("packages"))
               (:file "utils" :depends-on ("config"))
               (:file "parallel/main" :depends-on ("utils"))
               (:file "dat" :depends-on ("utils"))
               (:file "state" :depends-on ("utils"))
               (:file "hset" :depends-on ("utils"))
               (:file "math" :depends-on ("utils"))
               (:file "rnd/rnd" :depends-on ("utils"))
               (:file "rnd/2rnd" :depends-on ("rnd/rnd"))
               (:file "rnd/3rnd" :depends-on ("rnd/rnd"))
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
               (:file "weir/main" :depends-on ("graph/paths" "graph/edge-set"))
               (:file "weir/macros" :depends-on ("weir/main"))
               (:file "weir/props" :depends-on ("weir/main"))
               (:file "weir/vert-utils" :depends-on ("weir/main"))
               (:file "weir/planar-cycles"
                :depends-on ("weir/main" "graph/mst-cycle"))
               (:file "weir/paths"
                :depends-on ("weir/props" "draw/simplify-path"))
               (:file "weir/alteration-utils" :depends-on ("weir/vert-utils"))
               (:file "weir/alterations" :depends-on ("weir/alteration-utils"))
               (:file "weir/with-macro" :depends-on ("weir/alteration-utils"))
               (:file "weir/kdtree" :depends-on ("weir/alteration-utils"))
               (:file "weir/relneigh" :depends-on ("weir/kdtree"))
               (:file "weir/poly" :depends-on ("weir/main"))
               (:file "weir/bvh-util"
                :depends-on ("weir/macros" "weir/props" "weir/paths"))
               (:file "weir/3bvh"
                :depends-on ("weir/macros" "weir/props" "weir/paths"))
               (:file "weir/extra"
                :depends-on ("weir/main" "weir/props" "weir/vert-utils"
                             "weir/macros"))
               (:file "voxel/init" :depends-on ("weir/extra"))
               (:file "voxel/voxel" :depends-on ("voxel/init"))))

(asdf:defsystem #:weird/tests
  :depends-on (#:weird #:prove)
  :perform (asdf:test-op (o s) (uiop:symbol-call ':weird-tests '#:run-tests))
  :pathname "test/"
  :serial nil
  :components ((:file "packages") (:file "run" :depends-on ("packages"))))

