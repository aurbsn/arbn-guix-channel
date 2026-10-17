(define-module (arbn packages weiqi)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages opencl))

(define-public katago-opencl
  (package
   (name "katago-opencl")
   (version "1.18.2")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/lightvector/KataGo")
           (commit (string-append "v" version))))
     (file-name (git-file-name "katago" version))
     (sha256
      (base32 "10clm1g5rxczmkq501d3v9ki6mpicdycxihp9ljg8cp7hs3np2v6"))))
   (build-system cmake-build-system)
   (arguments
    (list
     #:build-type "Release"
     #:configure-flags
     #~(list "-DUSE_BACKEND=OPENCL"
             "-DNO_GIT_REVISION=1")
     #:phases
     #~(modify-phases %standard-phases
                      (add-after 'unpack 'chdir
                                 (lambda _
                                   (chdir "cpp")))
                      (replace 'check
                               (lambda* (#:key tests? #:allow-other-keys)
                                 (when tests?
                                   (invoke "./katago" "runtests"))))
                      (replace 'install
                               (lambda _
                                 (let ((share (string-append #$output "/share/katago")))
                                   (install-file "katago" (string-append #$output "/bin"))
                                   (copy-recursively "../cpp/configs"
                                                     (string-append share "/configs"))))))))
   (inputs (list libzip opencl-headers opencl-icd-loader zlib))
   (home-page "https://github.com/lightvector/KataGo")
   (synopsis "Go engine trained by self-play (OpenCL backend)")
   (description
    "KataGo is a strong Go engine trained by AlphaZero-style self-play.  It
speaks GTP and a JSON analysis protocol, estimates score and territory, and
handles many board sizes and rule sets.  This build uses the OpenCL backend,
which tunes itself for the GPU on first run.  A neural network file is needed
to play; see @code{katago-network-b28c512nbt}.  Example configuration files
are installed under @file{share/katago/configs}.")
   (license license:expat)))

(define-public katago-network-b28c512nbt
  (let ((file "kata1-b28c512nbt-s13255194368-d5935380940.bin.gz"))
    (package
     (name "katago-network-b28c512nbt")
     (version "s13255194368-d5935380940")
     (source
      (origin
       (method url-fetch)
       (uri (string-append
             "https://media.katagotraining.org/uploaded/networks/models/kata1/"
             file))
       (sha256
        (base32 "1g3kgca73mwkflzxmqbmv5viws6xshjr6hs6cpgsi3mhsx9s9g65"))))
     (build-system trivial-build-system)
     (arguments
      (list
       #:modules '((guix build utils))
       #:builder
       #~(begin
           (use-modules (guix build utils))
           (let ((dir (string-append #$output "/share/katago/networks")))
             (mkdir-p dir)
             (copy-file #$(package-source this-package)
                        (string-append dir "/" #$file))
             (symlink #$file (string-append dir "/default_model.bin.gz"))))))
     (home-page "https://katagotraining.org/networks/")
     (synopsis "KataGo neural network (28-block convolutional, kata1 run)")
     (description
      "This package provides the strongest 28-block convolutional network from
KataGo's distributed kata1 training run.  Convolutional networks run much
better than the newer transformer networks on KataGo's OpenCL backend.")
     (license (license:non-copyleft
               "https://katagotraining.org/network_license/")))))
