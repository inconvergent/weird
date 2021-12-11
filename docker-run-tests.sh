#!/bin/bash

set -e
sbcl --quit \
     --eval '(load "~/quicklisp/setup.lisp")'\
     --eval '(push "~/veq" ql:*local-project-directories*)'\
     --eval '(push "~/weird" ql:*local-project-directories*)'\
     --eval '(handler-case (ql:quickload :weird :verbose t)
                           (error (c) (print c) (sb-ext:quit :unix-status 2)))'\
     --eval '(progn (ql:quickload :prove)
                                  (asdf:test-system :weird))'
     # --eval '(handler-case (progn (ql:quickload :prove)
     #                              (asdf:test-system :weird))
     #                       (error (c) (print c) (sb-ext:quit :unix-status 3)))'

     # --eval '(load "weird/weird.asd")'\
     # --eval '(load "veq/veq.asd")'\
