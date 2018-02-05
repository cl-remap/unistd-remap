
(in-package :remap)

(defclass remap ()
  ())

(defgeneric remap-cat (remap &rest paths)
  (:documentation "Prints concatenated files at PATHS for REMAP."))

(defgeneric remap-cd (remap directory)
  (:documentation "Changes current working directory of REMAP to
 DIRECTORY."))

(defgeneric remap-cwd (remap)
  (:documentation "Return a string describing the current working dir
 of REMAP."))

(defgeneric remap-dir (remap path sort order)
  (:documentation "Return a directory listing of REMAP at PATH, sorted
 according to SORT and ORDER."))

(defgeneric remap-home (remap user)
  (:documentation "Return USER home directory for REMAP or current user
 home dir if USER is NIL."))

(defgeneric remap-open (remap path &key read write append create)
  (:documentation "Returns a cl-stream STREAM opened by REMAP at PATH.
STREAM is an INPUT-STREAM if READ is non-NIL and an OUTPUT-STREAM if
WRITE is non-NIL and an IO-STREAM if both READ and WRITE are non-NIL.
Position is set at end of STREAM if APPEND is non-NIL. CREATE indicates
UNIX permissions to use for creating a new file. CREATE can also be NIL
in which case no file will be created."))

(defmethod remap-dir ((remap remap) (path null) (sort symbol)
                      (order symbol))
  (remap-dir remap (remap-cwd remap) sort order))

(defmethod remap-dir ((remap remap) (path string)
                      (sort (eql :name))
                      (order (eql :<)))
  (sort (remap-dir remap path nil nil) #'string<))

(defmethod remap-dir ((remap remap) (path string)
                      (sort (eql 'name))
                      (order (eql '>)))
  (sort (remap-dir remap path nil nil) #'string>))

(defvar *remap*)

(defun cwd (&optional (remap *remap*))
  (remap-cwd remap))

#+nil(cwd)

(defun pwd (&optional (remap *remap*))
  (write-string (cwd remap))
  (write-char #\Newline)
  (values))

#+nil(pwd)

(defun cd (&optional directory (remap *remap*))
  (remap-cd remap (or directory
                      (remap-home remap nil))))

#+nil(cd)
#+nil(cd "/")
#+nil(dir)

(defun dir (&key (remap *remap*) (path (cwd remap)) (sort 'name)
              (order '<))
  (remap-dir remap path sort order))

#+nil(dir)

(defun absolute-p (path)
  (char= #\/ (char path 0)))

(defun absolute (&optional path)
  (let* ((cwd (cwd))
         (abs (or (when (null path)
                    cwd)
                  (when (absolute-p path)
                    path)
                  (let ((m (concatenate 'string cwd path)))
                    (when (absolute-p m)
                      m))
                  (error "~S" path))))
    abs))

(defun absolute! (&optional path)
  (let ((abs (absolute path)))
    (or (when (probe-file abs)
          abs)
        (error "No such file or directory: ~S" path))))

(defun absolute-or-wild! (&optional path)
  (let ((abs (absolute path)))
    (or (when (or (wild-pathname-p abs)
                  (probe-file abs))
          abs)
        (error "No such file or directory: ~S" path))))

(defun ls (&optional path)
  (let* ((abs (absolute-or-wild! path))
         (count 0)
         (dir (dir :path abs)))
    (dolist (name dir)
      (unless (char= #\. (char name 0))
        (write-string name)
        (write-char #\Newline)
        (incf count)))
    count))

#+nil(ls)

(defun cat (&rest paths)
  (apply #'remap-cat *remap* paths))
