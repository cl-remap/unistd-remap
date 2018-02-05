
(in-package :remap)

(defclass unistd (remap)
  ())

(defvar *remap-unistd*
  (make-instance 'unistd))

(defparameter *remap*
  *remap-unistd*)

(defmethod remap-cwd ((remap unistd))
  (unistd:getcwd))

(defmethod remap-dir ((remap unistd) (path string) (sort null)
                      (order null))
  (let ((dir ()))
    (dirent:do-dir (ent path)
      (push ent dir))
    dir))

(defmethod remap-dir ((remap unistd) (path string) (sort (eql :name))
                      (order (eql '<)))
  (let* ((dir (remap-dir remap path nil nil))
         (sorted (sort dir #'string< :key #'dirent:dirent-name)))
    (mapcar #'dirent:dirent-name sorted)))

(defmethod remap-home ((remap unistd) (user null))
  (unistd:getenv "HOME"))

(defmethod remap-cd ((remap unistd) (directory string))
  (unistd:chdir directory)
  (values))

(defmethod remap-open ((remap unistd) (path string)
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
