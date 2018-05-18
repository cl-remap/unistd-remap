;;
;;  unistd-remap  -  UNISTD interface for REMAP.
;;  Thomas de Grivel  <thoxdg@gmail.com>  +33614550127
;;

(in-package :common-lisp-user)

(defpackage :unistd-remap.system
  (:use :cl :asdf))

(in-package :unistd-remap.system)

(defsystem :unistd-remap
  :name "unistd-remap"
  :author "Thomas de Grivel  <thoxdg@gmail.com>  +33614550127"
  :version "0.2"
  :description "UNISTD interface for REMAP"
  :depends-on ("babel-stream"
               "cffi-dirent"
               "unistd-stream"
               "remap"
               "str")
  :components
  ((:file "package")
   (:file "unistd-remap" :depends-on ("package"))))
