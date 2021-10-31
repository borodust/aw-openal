(claw:defwrapper (:aw-openal
                  (:system :aw-openal/wrapper)
                  (:headers "AL/al.h")
                  (:includes :openal-includes)
                  (:include-definitions "^al[^c]\\w+" "^AL[^C]\\w+")
                  (:targets ((:and :x86-64 :linux) "x86_64-pc-linux-gnu")
                            ((:and :x86-64 :windows) "x86_64-w64-mingw32")
                            ((:and :x86-64 :darwin) "x86_64-apple-darwin-gnu")
                            ((:and :aarch64 :android) "aarch64-linux-android"))
                  (:persistent t :depends-on (:claw-utils)))
  :in-package :%al
  :trim-enum-prefix t
  :recognize-bitfields t
  :recognize-strings t
  :override-types ((:string claw-utils:claw-string)
                   (:pointer claw-utils:claw-pointer))
  :symbolicate-names (:in-pipeline
                      (:by-removing-prefixes "al" "AL" "AL_")
                      (:by-removing-postfixes "EXT" "_EXT" "SOFT" "_SOFT")))



(claw:defwrapper (:aw-openal-context
                  (:system :aw-openal/wrapper)
                  (:headers "AL/alc.h")
                  (:includes :openal-includes)
                  (:include-definitions "^alc\\w+" "^ALC\\w+")
                  (:targets ((:and :x86-64 :linux) "x86_64-pc-linux-gnu")
                            ((:and :x86-64 :windows) "x86_64-w64-mingw32")
                            ((:and :x86-64 :darwin) "x86_64-apple-darwin-gnu")
                            ((:and :aarch64 :android) "aarch64-linux-android"))
                  (:persistent t
                   :bindings-path "bindings/context/"
                   :depends-on (:claw-utils)))
  :in-package :%alc
  :trim-enum-prefix t
  :recognize-bitfields t
  :recognize-strings t
  :override-types ((:string claw-utils:claw-string)
                   (:pointer claw-utils:claw-pointer))
  :symbolicate-names (:in-pipeline
                      (:by-removing-prefixes "alc" "ALC" "ALC_")
                      (:by-removing-postfixes "EXT" "_EXT" "SOFT" "_SOFT")))


(claw:defwrapper (:aw-openal-ext
                  (:system :aw-openal/wrapper)
                  (:defines "AL_ALEXT_PROTOTYPES" 1)
                  (:headers "AL/alext.h"
                            "AL/efx.h"
                            "AL/efx-presets.h")
                  (:includes :openal-includes)
                  (:include-definitions "^al\\w+" "^AL\\w+"
                                        "^efx\\w+" "^EFX\\w+")
                  (:exclude-sources "AL/al\\.h$" "AL/alc\\.h$")
                  (:targets ((:and :x86-64 :linux) "x86_64-pc-linux-gnu")
                            ((:and :x86-64 :windows) "x86_64-w64-mingw32")
                            ((:and :x86-64 :darwin) "x86_64-apple-darwin-gnu")
                            ((:and :aarch64 :android) "aarch64-linux-android"))
                  (:persistent t
                   :bindings-path "bindings/ext/"
                   :depends-on (:claw-utils)))
  :in-package :%al.ext
  :trim-enum-prefix t
  :recognize-bitfields t
  :recognize-strings t
  :override-types ((:string claw-utils:claw-string)
                   (:pointer claw-utils:claw-pointer))
  :symbolicate-names (:in-pipeline
                      (:by-removing-prefixes "al" "AL" "AL_"
                                             "alc" "ALC" "ALC_"
                                             "efx" "EFX" "EFX_")
                      (:by-removing-postfixes "EXT" "_EXT" "SOFT" "_SOFT")))
