#!/bin/bash

set -e
touch ./weird.asd
time sbcl --quit \
         --eval '(load "~/quicklisp/setup.lisp")'\
         --eval '(load "weird.asd")'\
         --eval '(handler-case (ql:quickload :weird :verbose t)
                               (error (c) (print c) (sb-ext:quit :unix-status 2)))'\
  >compile.sh.tmp 2>&1
