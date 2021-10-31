;; Generated by :claw at 2021-10-31T22:14:31.069315Z
(asdf:defsystem #:aw-openal-bindings
  :description "Bindings generated by aw-openal"
  :author "CLAW"
  :license "Public domain"
  :defsystem-depends-on (:trivial-features)
  :depends-on (:uiop :cffi :claw-utils)
  :components
  ((:file "bindings/x86_64-pc-linux-gnu" :if-feature
    (:and :x86-64 :linux))
   (:file "bindings/x86_64-w64-mingw32" :if-feature
    (:and :x86-64 :windows))
   (:file "bindings/x86_64-apple-darwin-gnu" :if-feature
    (:and :x86-64 :darwin))
   (:file "bindings/aarch64-linux-android" :if-feature
    (:and :aarch64 :android))))
#-(:or (:and :aarch64 :android)(:and :x86-64 :darwin)(:and :x86-64 :windows)(:and :x86-64 :linux))
(warn "Current platform unrecognized or unsupported by aw-openal-bindings system")