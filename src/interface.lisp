(in-package :polisher)


;;; Interface function
(defun infix-to-sexp (formula-str)
  (transform-into-sexp (tokenize formula-str)))


;;; Macro
(defmacro polish (formula-str)
  "Convert given infix-style formula into S-expression, which will be
evaluated as usual lisp form."
  (infix-to-sexp formula-str))


;;; Reader macro
(defun read-formula (stream boundary-chars)
  (let ((end-char (cdr boundary-chars))
        (start-char (car boundary-chars))
        (level 1))
    (coerce (loop for c = (read-char stream)
                  if (char= c start-char)
                    do (incf level)
                  if (char= c end-char)
                    do (decf level)
                  if (and (char= c end-char)
                          (<= level 0))
                    do (loop-finish)
                  collect c)
            'string)))


(defparameter *infix-macro-boundary-chars* (cons #\{ #\})
  "The start and end chars for the contents of an infix macro usage")


(defun activate-infix-syntax (&optional (activate t) (dispatch-char #\i))
  "Activate infix reader-macro #i{...} by default. If the argument \"activate\" is nil,
deactivate (unregister) #i macro (regardless of whether or not it has been registered by this function).
The macro character \"i\" can be changed by the argument \"dispatch-char\"."
  (if activate
      (progn
        (when (get-dispatch-macro-character #\# dispatch-char)
          (warn (format nil "Reader macro #~a has been overwritten" dispatch-char)))
        (set-dispatch-macro-character #\# dispatch-char
                                      #'(lambda (stream disp-char sub-char)
                                          (declare (ignore disp-char sub-char))
                                          (let ((first-char (peek-char nil stream))
                                                (start-char (car *infix-macro-boundary-chars*)))
                                            (cond ((char= first-char start-char) (read-char stream))
                                                  ((char= dispatch-char start-char) nil)
                                                  (t (error "Infix syntax must be like #~A{...}" dispatch-char)))
                                            (infix-to-sexp (read-formula stream
                                                                         *infix-macro-boundary-chars*))))))
      (set-dispatch-macro-character #\# dispatch-char nil)))


(defun list-operators ()
  "Return information of registered operators as string."
  (format nil "~%~{~a~%~}"
          (loop for op in (sort (copy-list *operator-list*)
                                #'(lambda (x y)
                                    (>= (slot-value x 'priority)
                                        (slot-value y 'priority))))
                collect (readable-string op))))
