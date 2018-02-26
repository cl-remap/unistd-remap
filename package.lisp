;;
;;  unistd-remap  -  UNISTD interface for REMAP.
;;  Thomas de Grivel  <thoxdg@gmail.com>  +33614550127
;;

(in-package :common-lisp-user)

(defpackage :unistd-remap
  (:use :cl
        :cl-stream
        :remap
        :unistd-stream)
  #.(cl-stream:shadowing-import-from)
  (:export #:*remap*
           #:unistd))
