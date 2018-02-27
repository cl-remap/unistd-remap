;;
;;  unistd-remap  -  UNISTD interface for REMAP.
;;  Thomas de Grivel  <thoxdg@gmail.com>  +33614550127
;;

(in-package :unistd-remap)

(defclass unistd-remap (remap)
  ())

(defvar *unistd-remap*
  (make-instance 'unistd-remap))

(defvar *remap*
  *unistd-remap*)

(defmethod remap-cwd ((remap unistd-remap))
  (unistd:getcwd))

(defmethod remap-dir ((remap unistd-remap) (path string) (sort null)
                      (order null))
  (let ((dir ()))
    (dirent:do-dir (ent path)
      (push ent dir))
    dir))

(defmethod remap-dir ((remap unistd-remap) (path string) (sort (eql :name))
                      (order (eql '<)))
  (let* ((dir (remap-dir remap path nil nil))
         (sorted (sort dir #'string< :key #'dirent:dirent-name)))
    (mapcar #'dirent:dirent-name sorted)))

(defmethod remap-home ((remap unistd-remap) (user null))
  (unistd:getenv "HOME"))

(defmethod remap-cd ((remap unistd-remap) (directory string))
  (unistd:chdir directory)
  (values))

(defmethod remap-open ((remap unistd-remap) (path string)
                       &key read write append (create #o777)
                         non-blocking
                         (input-buffer-size
                          *stream-default-buffer-size*)
                         (output-buffer-size
                          *stream-default-buffer-size*)
                         &allow-other-keys)
  (unistd-stream-open path :read read :write write :append append
                      :non-blocking non-blocking :create create
                      :input-buffer-size input-buffer-size
                      :output-buffer-size output-buffer-size))
