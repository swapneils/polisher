(asdf:defsystem :polisher
  :description "Infix to S-expression translator"
  :author "mrcdr"
  :license "MIT"
  :version "0.1"
  :depends-on (:cl-ppcre)
  :serial t
  :components ((:file "package")
               (:module "src"
                :serial t
                :components ((:file "types-svalues")
                             (:file "tokenizer")
                             (:file "transformer")
                             (:file "interface"))))
  :in-order-to ((test-op (test-op polisher.test))))
