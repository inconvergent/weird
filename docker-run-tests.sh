#!/bin/bash

set -e
sbcl --quit \
     --eval '(load "/opt/quicklisp/setup.lisp")'\
     --eval '(print ql:*local-project-directories*)'\
     --eval '(handler-case (ql:quickload :weird :verbose t)
                           (error (c) (print c) (sb-ext:quit :unix-status 2)))'\
     --eval '(handler-case (asdf:test-system :weird)
                           (error (c) (print c) (sb-ext:quit :unix-status 3)))'

