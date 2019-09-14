(asdf:defsystem :polisher
  :description "Infix to S-expression translator"
  :author "mrcdr"
  :version "0.1"
  :depends-on (:cl-ppcre)
  :serial t
  :components ((:file "package")
               (:module "src"
                :serial t
                :components ((:file "types-svalues")
                             (:file "tokenizer")
                             (:file "transformer")))))
