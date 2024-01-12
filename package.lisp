(defpackage polisher
  (:use :cl :alexandria)
  (:export :polish
   :operator
           :add-operator :list-operators :*operator-list*
   :activate-infix-syntax))
