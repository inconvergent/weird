
(in-package :dat)

;; this code is adapted from:
;; https://bitbucket.org/vityok/cl-faster-input/src/default/

;; Copyright (c) 2013-2018 Victor Anyakin <anyakinvictor@yahoo.com>
;; All rights reserved.

;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;     * Redistributions of source code must retain the above copyright
;;       notice, this list of conditions and the following disclaimer.
;;     * Redistributions in binary form must reproduce the above copyright
;;       notice, this list of conditions and the following disclaimer in the
;;       documentation and/or other materials provided with the distribution.
;;     * Neither the name of the organization nor the
;;       names of its contributors may be used to endorse or promote products
;;       derived from this software without specific prior written permission.

;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY
;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
;; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


(declaim (inline %read-char-until %finish-read-line-into-sequence))


(defun %read-char-until (stream recursivep store)
  (declare #.*opt* (function store))
  (loop :for ch := (read-char stream nil nil recursivep)
        :while (and ch (funcall store ch))
        :finally (return ch)))

(defun %finish-read-line-into-sequence (ch buffer stream eof-error-p eof-value start)
  (declare #.*opt*)
  (if (null ch) (if eof-error-p (error 'end-of-file :stream stream)
                                (values eof-value start nil))
                (values buffer start (eql ch #\Newline))))


(defgeneric read-line-into-sequence (sequence input-stream
                                     &key eof-error-p eof-value recursivep
                                          start end)
  (:documentation "

Reads characters from the INPUT-STREAM until a #\\Newline is found, and
store the characters read into the SEQUENCE, from START, up to below
END.  If END is reached before the #\\Newline character is read, then
reading stops there and the third result value is NIL.  The #\Newline
character is not stored.   No other slot of the SEQUENCE is modified
than those between START and POSITION.

RETURN:         VALUE, POSITION, NEWLINE-SEEN-P

VALUE:          Either SEQUENCE or EOF-VALUE depending on whether an
                end-of-file has been seen.

SEQUENCE:       A sequence (OR LIST VECTOR).  If specialized, the vector
                must have an element-type that is a supertype of the
                stream element-type.  If a fill-pointer is present, it
                is ignored.

POSITION:       The index in the SEQUENCE of the first element not
                written. (<= START POSITION (OR END (LENGTH BUFFER)))


NEWLINE-SEEN-P: Whether a #\\Newline has been read.

INPUT-STREAM:   an input stream.  The element-type of the INPUT-STREAM
                must be a subtype of CHARACTER.

EOF-ERROR-P:    a generalized boolean. The default is true.  If true,
                then an END-OF-FILE error is signaled upon end of file.

EOF-VALUE:      an object. The default is NIL.

RECURSIVE-P:    a generalized boolean. The default is NIL.  If
                RECURSIVE-P is true, this call is expected to be
                embedded in a higher-level call to read or a similar
                function used by the Lisp reader.

START, END:     bounding index designators of SEQUENCE.
                The defaults for START and END are 0 and NIL, respectively.

")

  (:method ((buffer vector) (stream stream) &key (eof-error-p t) (eof-value nil)
                                                 (recursivep nil) (start 0)
                                                 (end nil))
    (let ((end (or end (length buffer))))
      (check-type start (and fixnum (integer 0)))
      (check-type end   (or null (and fixnum (integer 0))))
      (cond
        ((and (= end start) (<= start (length buffer)))
         (values buffer start nil))
        ((or (< end start) (< (length buffer) start))
         (error "Bad interval for sequence operation on ~S: start = ~A, end = ~A"
                buffer start end))
        (t
         (%finish-read-line-into-sequence
          (%read-char-until stream recursivep
                            (lambda (ch)
                              (if (char= #\Newline ch)
                                  nil
                                  (progn (setf (aref buffer start) ch)
                                         (incf start)
                                         (< start end)))))
          buffer stream eof-error-p eof-value start)))))

  (:method ((buffer list) (stream stream) &key (eof-error-p t) (eof-value nil)
                                               (recursivep nil) (start 0)
                                               (end nil))
    (check-type start (and fixnum (integer 0)))
    (check-type end   (or null (and fixnum (integer 0))))
    (let ((current buffer))
      (loop
        :repeat start
        :do (if (null current)
                (error "Bad interval for sequence operation on ~S: start = ~A, end = ~A"
                       buffer start end)
                (pop current)))
      #+costly-assert (assert (<= start (length buffer)))
      (cond
        ((if end
             (= start end)
             (null current))
         (values buffer start nil))
        ((or (null current) (and end (< end start)))
         (error "Bad interval for sequence operation on ~S: start = ~A, end = ~A"
                buffer start end))
        (t
         #+costly-assert (assert (and (or (null end) (<= start end))
                                      (< start (length buffer))))
         (%finish-read-line-into-sequence
          (%read-char-until stream recursivep
                            (lambda (ch)
                              (if (char= #\Newline ch)
                                  nil
                                  (progn (setf (car current) ch
                                               current (cdr current))
                                         (incf start)
                                         (if end (< start end)
                                                 current)))))
          buffer stream eof-error-p eof-value start))))))

; adapted from original above code by Victor Anyakin
(defun do-lines-as-buffer (fn fx &key (buffer-width 80))
  (declare #.*opt* (function fx) (fixnum buffer-width))
  "
  fx will receive a stream (named in). use it like this:
    (loop for x = (read in nil nil)
          while x
          do something)
  "
  (let ((*read-default-float-format* 'single-float)
        (buffer (make-array buffer-width
                            :element-type 'character
                            :initial-element #\space)))
    (with-open-file (is fn :direction :input)
      (loop for (val pos newl) =
                  (multiple-value-list (read-line-into-sequence buffer is
                                         :eof-error-p nil))
            while val
            do (when newl
                 (with-input-from-string (in val :start 0 :end pos)
                   (funcall fx in)))))))

;; ----------------------------------------------------------------------

(declaim (inline -maybe-float))
(defun -maybe-float (v)
  (declare #.*opt* (number v))
  (typecase v (single-float v) (t (coerce v 'single-float))))


; suggested by lispm in
;  https://gist.github.com/inconvergent/8b6ccfbde4fca7844c1962082ef07a7e
(declaim (inline floats-string-to-list))
(defun floats-string-to-list (s end)
  (declare #.*opt* (string s))
  (let ((*read-default-float-format* 'single-float))
    (loop with start of-type fixnum = 0
          with v of-type number = 0
          for pos = (loop for i of-type fixnum from start below end
                          for c of-type character across s
                          unless (eql c #\space)
                          do (return i))
          while pos do (multiple-value-setq (v start)
                         (read-from-string s nil nil :start pos))
          while v collect (-maybe-float v) of-type single-float)))


(defun do-lines-as-floats (fn fx &key (buffer-width 80))
  (declare #.*opt* (function fx) (fixnum buffer-width))
  (let ((buffer (make-array buffer-width :element-type 'character
                                         :initial-element #\space)))
    (with-open-file (is fn :direction :input)
      (loop for (val pos newl) =
                  (multiple-value-list (read-line-into-sequence buffer is
                                         :eof-error-p nil))
            while val do (when newl
                           (funcall fx (floats-string-to-list val pos)))))))


(defun do-lines (fn fx &key (buffer-width 80))
  (declare #.*opt* (function fx) (fixnum buffer-width))
  (let ((buffer (make-array buffer-width :element-type 'character
                                         :initial-element #\space)))
    (with-open-file (is fn :direction :input)
      (loop for (val pos newl) =
                  (multiple-value-list (read-line-into-sequence buffer is
                                         :eof-error-p nil))
            while val do (when newl (funcall fx (subseq val 0 pos)))))))


;; ----------------------------------------------------------------------

(defun export-data (o fn &optional (postfix ".dat"))
  (with-open-file (fstream (ensure-filename fn postfix)
                           :direction :output :if-exists :supersede)
    (declare (stream fstream))
    (print o fstream)))


(defun import-data (fn &optional (postfix ".dat"))
  (with-open-file (fstream (ensure-filename fn postfix) :direction :input)
    (declare (stream fstream))
    (read fstream)))

