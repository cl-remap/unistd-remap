;;
;;  unistd-remap  -  UNISTD interface for REMAP.
;;  Thomas de Grivel  <thoxdg@gmail.com>  +33614550127
;;

(in-package :common-lisp-user)

;;  All reusable URIs and paths should go here

(defpackage :remap.uri)

;;  Here we control data remapping

(defpackage :remap
  (:use :babel-stream
        :cl
        :cl-stream
        :local-time
        :remap.uri
        :rollback
        :split-sequence
        :unistd-stream)
  #.(cl-stream:shadowing-import-from)
  (:export #:*hooks*
           #:*remap*
           #:absolute
           #:absolute!
           #:absolute-or-wild!
           #:absolute-p
           #:cd
           #:cwd
           #:from
           #:ftp
           #:http
           #:html
           #:ls
           #:pwd
           #:remap
           #:shell
           #:sync
           #:to))
