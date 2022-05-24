#!/usr/local/bin/sbcl --script

(load "~/quicklisp/setup.lisp")
(ql:quickload :weird)

(in-package :weird)

(defun make-docs ()
  (loop for (o . rest) in (dat:import-all-data
                            (weird:internal-path-string "src/packages") ".lisp")
        if (eq o 'defpackage)
        do (let* ((pkg (weird:mkstr (car rest)))
                 (fn (weird:internal-path-string (weird:mkstr "docs/" pkg ".md")))
                 (s (with-output-to-string (*standard-output*)
                      (ext-symbols? pkg :pretty))))
             (with-open-file (fstream fn :direction :output :if-exists :supersede)
               (format fstream s)))))

(make-docs)

