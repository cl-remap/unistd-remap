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
  (str (unistd:getcwd) "/"))

(defmethod remap-dir ((remap unistd-remap) (path string) (sort null)
                      (order null))
  (let ((dir ()))
    (dirent:do-dir (ent path)
      (push ent dir))
    dir))

(defmethod remap-dir ((remap unistd-remap) (path string) (sort (eql 'name))
                      (order (eql '<)))
  (let ((dir (remap-dir remap path nil nil)))
    (sort dir #'string<)))

(defmethod remap-home ((remap unistd-remap) (user null))
  (unistd:getenv "HOME"))

(defmethod remap-cd ((remap unistd-remap) (directory string))
  (unistd:chdir directory)
  (values))

(defmethod remap-cut ((remap unistd-remap) (path string)
                      (start integer) (end null))
  (with-stream (in (babel-input-stream
                    (unistd-stream-open path :read t :create nil)))
    (unistd:lseek (stream-fd (stream-underlying-stream in))
                  start unistd:+seek-set+)
    (stream-copy in *stdout*)))

(defmethod remap-cut ((remap unistd-remap) (path string)
                      (start integer) (end integer))
  (when (< start end)
    (with-stream (in (babel-input-stream
                      (unistd-stream-open path :read t :create nil)))
      (unistd:lseek (stream-fd (stream-underlying-stream in))
                    start unistd:+seek-set+)
      (stream-copy-n in *stdout* (- end start)))))

(defmethod remap-dir ((remap unistd-remap) (path string)
                      (sort null) (order null))
  (let ((list ()))
    (dirent:do-dir (dirent path)
      (push (dirent:dirent-name dirent) list))
    list))

(defmethod remap-dir ((remap unistd-remap) (path string)
                      (sort (eql 'name)) (order (eql '<)))
  (sort (remap-dir remap path nil nil) #'string<))

(defmethod remap-dir ((remap unistd-remap) (path string)
                      (sort (eql 'name)) (order (eql '>)))
  (sort (remap-dir remap path nil nil) #'string>))

(defmethod remap-link ((remap unistd-remap) (source string)
                       (destination string))
  (let ((dest (if (path-directory-p destination)
                  (str destination (path-filename source))
                  destination)))
    (ignore-errors
      (unistd:link source dest)
      t)))

(defmethod remap-mv ((remap unistd-remap) (source string)
                     (destination string))
  (let ((dest (if (path-directory-p destination)
                  (str destination (path-filename source))
                  destination)))
    (and (or (remap-link remap source dest)
             (remap-cp remap source dest))
         (remap-unlink remap source))))

(defmethod remap-open ((remap unistd-remap) (path string)
                       &key read write append (create #o666)
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

(defmethod remap-unlink ((remap unistd-remap) (path string))
  (unistd:unlink path))
