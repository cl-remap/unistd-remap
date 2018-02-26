;;
;;  remap - modular transactional file system in Common Lisp
;;  Thomas de Grivel <thoxdg@gmail.com> +33614550127
;;

(in-package :remap)

(defparameter *shell-commands*
  '(cat cd cp ls mv pwd rm))

(defgeneric shell-command (name &rest args))

(defmethod shell-command ((name string) &rest args)
  (let ((cmd (find (string-upcase name) *shell-commands*
                   :test #'string=)))
    (when cmd
      (apply cmd args))))
  
(defun shell-line (line)
  (let ((list (split-sequence #\Space line
                         :remove-empty-subseqs t
                         :test #'char=)))
    (when list
      (apply #'shell-command list))))

(defun shell ()
  (loop
     (let ((line (read-line)))
       (unless line
         (return))
       (with-simple-restart (continue "continue")
         (shell-line line)))))
