(define-module (arbn packages emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix build-system emacs)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages emacs-build))

(define-public emacs-guru-mode
  (package
   (name "emacs-guru-mode")
   (version "1.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/bbatsov/guru-mode")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1ja98di2iwjp0l4ndh22pwm7s56753kmz255xlv6vni2ai4rf8sm"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/bbatsov/guru-mode")
   (synopsis "Learn idiomatic Emacs keybindings")
   (description
    "Guru mode promotes the use of idiomatic keybindings for essential
editing commands.  It can either warn when an alternative binding such as an
arrow key is used, or disallow those bindings outright.")
   (license license:gpl3+)))

(define-public emacs-sly-repl-ansi-color
  (let ((commit "b9cd52d1cf927bf7e08582d46ab0bcf1d4fb5048")
        (revision "0"))
    (package
      (name "emacs-sly-repl-ansi-color")
      (version (git-version "0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/PuercoPop/sly-repl-ansi-color")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0fgcn6bwgz8yyjza07kfi86siargvpq4kp4j20hs6b67ckxjxx0x"))))
      (build-system emacs-build-system)
      (propagated-inputs (list emacs-sly))
      (home-page "https://github.com/PuercoPop/sly-repl-ansi-color")
      (synopsis "ANSI color support for the SLY REPL")
      (description
       "This SLY contrib interprets ANSI escape sequences in the SLY REPL, so
that output from Common Lisp libraries which colorize their output renders as
colors rather than raw escape codes.")
      (license license:gpl2+))))
