;;
;;  remap  -  modular transactional file system in Common Lisp
;;  Thomas de Grivel <thoxdg@gmail.com> +33614550127
;;

(in-package :remap)

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
