(asdf:defsystem :aw-openal
  :description "Bindings to OpenAL Soft cross-platform 3D audio API implementation"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:aw-openal-bindings
               :aw-openal-context-bindings
               :aw-openal-ext-bindings))


(asdf:defsystem :aw-openal/wrapper
  :description "Thin wrapper over OpenAL Soft cross-platform 3D audio API implementation"
  :version "1.0.0"
  :author "Pavel Korolev"
  :mailto "dev@borodust.org"
  :license "MIT"
  :depends-on (:alexandria :claw-utils :claw)
  :serial t
  :components ((:file "src/claw")
               (:module :openal-includes :pathname "src/lib/openal/include/")))
