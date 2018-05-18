;;
;;  unistd-remap  -  UNISTD interface for REMAP.
;;  Thomas de Grivel  <thoxdg@gmail.com>  +33614550127
;;

(in-package :common-lisp-user)

(defpackage :unistd-remap
  (:use :babel-stream
        :cl
        :cl-stream
        :remap
        :str
        :unistd-stream)
  #.(cl-stream:shadowing-import-from)
  (:export #:*unistd-remap*
           #:unistd-remap))
