#!/bin/bash

set -e

sbcl --quit \
     --eval '(load "~/quicklisp/setup.lisp")'\
     --eval '(handler-case (ql:quickload :weird :verbose t)
               (error (c) (format t "STAGE1FAIL: ~a" c)
                          (sb-ext:quit :unix-status 2)))'

sbcl --quit \
     --eval '(load "~/quicklisp/setup.lisp")'\
     --eval '(ql:quickload :prove :verbose nil)'\
     --eval '(handler-case (asdf:test-system :weird)
               (error (c) (format t "STAGE2FAIL: ~a" c)
                          (sb-ext:quit :unix-status 3)))'
