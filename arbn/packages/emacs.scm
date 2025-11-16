(define-module (arbn packages emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix build-system emacs)
  #:use-module (guix download)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages emacs-build))

(define-public emacs-minuet
  (package
    (name "emacs-minuet")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://elpa.gnu.org/packages/minuet-" version
                           ".tar"))
       (sha256
        (base32 "1vpq6jsmw93hssla13dkf2ff13sv11fbjaq7wmrybnc4vnyfkycz"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-plz emacs-dash))
    (home-page "https://github.com/milanglacier/minuet-ai.el")
    (synopsis "Code completion using LLM")
    (description
     "Minuet brings the grace and harmony of a minuet to your coding process. Just as dancers move during a minuet.")
    (license license:gpl3+)))
