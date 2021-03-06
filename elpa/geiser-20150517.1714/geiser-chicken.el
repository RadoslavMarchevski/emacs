;; geiser-chicken.el -- chicken's implementation of the geiser protocols

;; Copyright (C) 2014, 2015 Daniel Leslie

;; Based on geiser-guile.el by Jose Antonio Ortego Ruize

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the Modified BSD License. You should
;; have received a copy of the license along with this program. If
;; not, see <http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5>.

;; Start date: Sun Mar 08, 2009 23:03


(require 'geiser-connection)
(require 'geiser-syntax)
(require 'geiser-custom)
(require 'geiser-base)
(require 'geiser-eval)
(require 'geiser-edit)
(require 'geiser-log)
(require 'geiser)

(require 'compile)
(require 'info-look)

(eval-when-compile (require 'cl))


(defconst geiser-chicken-builtin-keywords
  '("and-let*" "assume" "compiler-typecase" "cond-expand" "condition-case"
    "cut" "cute" "declare" "define-constant" "define-inline" "define-interface"
    "define-record" "define-record-type" "define-specialization"
    "define-syntax-rule" "define-type" "define-values" "dotimes" "ecase"
    "fluid-let" "foreign-lambda" "foreign-lambda*" "foreign-primitive"
    "foreign-safe-lambda" "foreign-safe-lambda*" "functor" "handle-exceptions"
    "import" "let*-values" "let-location" "let-optionals" "let-optionals*"
    "let-values" "letrec*" "letrec-values" "match-letrec" "module"
    "parameterize" "regex-case" "require-extension" "select" "set!"
    "unless" "use" "when" "with-input-from-pipe" "match" "match-lambda"
    "match-lambda*" "match-let" "match-let*" "receive"))

;;; Customization:

(defgroup geiser-chicken nil
  "Customization for Geiser's Chicken flavour."
  :group 'geiser)

(geiser-custom--defcustom geiser-chicken-binary
  (cond ((eq system-type 'windows-nt) "csi.exe")
        ((eq system-type 'darwin) "csi")
        (t "csi"))
  "Name to use to call the Chicken executable when starting a REPL."
  :type '(choice string (repeat string))
  :group 'geiser-chicken)

(geiser-custom--defcustom geiser-chicken-load-path nil
  "A list of paths to be added to Chicken's load path when it's
started."
  :type '(repeat file)
  :group 'geiser-chicken)

(geiser-custom--defcustom geiser-chicken-compile-geiser-p t
  "Non-nil means that the Geiser runtime will be compiled on load."
  :type 'boolean
  :group 'geiser-chicken)

(geiser-custom--defcustom geiser-chicken-init-file "~/.chicken-geiser"
  "Initialization file with user code for the Chicken REPL.
If all you want is to load ~/.csirc, set
`geiser-chicken-load-init-file-p' instead."
  :type 'string
  :group 'geiser-chicken)

(geiser-custom--defcustom geiser-chicken-load-init-file-p nil
  "Whether to load ~/.chicken when starting Chicken.
Note that, due to peculiarities in the way Chicken loads its init
file, using `geiser-chicken-init-file' is not equivalent to setting
this variable to t."
  :type 'boolean
  :group 'geiser-chicken)

(geiser-custom--defcustom geiser-chicken-extra-keywords nil
  "Extra keywords highlighted in Chicken scheme buffers."
  :type '(repeat string)
  :group 'geiser-chicken)

(geiser-custom--defcustom geiser-chicken-case-sensitive-p t
  "Non-nil means keyword highlighting is case-sensitive."
  :type 'boolean
  :group 'geiser-chicken)


;;; REPL support:

(defun geiser-chicken--binary ()
  (if (listp geiser-chicken-binary)
      (car geiser-chicken-binary)
    geiser-chicken-binary))

(defun geiser-chicken--parameters ()
  "Return a list with all parameters needed to start Chicken.
This function uses `geiser-chicken-init-file' if it exists."
  (let ((init-file (and (stringp geiser-chicken-init-file)
                        (expand-file-name geiser-chicken-init-file)))
        (n-flags (and (not geiser-chicken-load-init-file-p) '("-n"))))
  `(,@(and (listp geiser-chicken-binary) (cdr geiser-chicken-binary))
    ,@n-flags "-include-path" ,(expand-file-name "chicken/" geiser-scheme-dir)
    ,@(apply 'append (mapcar (lambda (p) (list "-include-path" p))
                             geiser-chicken-load-path))
    ,@(and init-file (file-readable-p init-file) (list init-file)))))

(defconst geiser-chicken--prompt-regexp "#[^;]*;[^:0-9]*:?[0-9]+> ")

;;; Evaluation support:

(defun geiser-chicken--geiser-procedure (proc &rest args)
  (let ((fmt
         (case proc
           ((eval compile)
            (let ((form (mapconcat 'identity (cdr args) " ")))
              (format ",geiser-eval %s %s" (or (car args) "#f") form)))
           ((load-file compile-file)
            (format ",geiser-load-file %s" (car args)))
           ((no-values)
            ",geiser-no-values")
           (t
            (let ((form (mapconcat 'identity args " ")))
              (format "(geiser-%s %s)" proc form))))))
    ;;(message fmt)
    fmt))

(defconst geiser-chicken--module-re
  "( *module +\\(([^)]+)\\|[^ ]+\\)\\|( *define-library +\\(([^)]+)\\|[^ ]+\\)")

(defun geiser-chicken--get-module (&optional module)
  (cond ((null module)
         (save-excursion
           (geiser-syntax--pop-to-top)
           (if (or (re-search-backward geiser-chicken--module-re nil t)
                   (looking-at geiser-chicken--module-re)
                   (re-search-forward geiser-chicken--module-re nil t))
               (geiser-chicken--get-module (match-string-no-properties 1))
             :f)))
        ((listp module) module)
        ((stringp module)
         (condition-case nil
             (car (geiser-syntax--read-from-string module))
           (error :f)))
        (t :f)))

(defun geiser-chicken--module-cmd (module fmt &optional def)
  (when module
    (let* ((module (geiser-chicken--get-module module))
           (module (cond ((or (null module) (eq module :f)) def)
                         (t (format "%s" module)))))
      (and module (format fmt module)))))

(defun geiser-chicken--import-command (module)
  (geiser-chicken--module-cmd module "(use %s)"))

(defun geiser-chicken--enter-command (module)
  (geiser-chicken--module-cmd module ",m %s" module))

(defun geiser-chicken--exit-command () ",q")

(defun geiser-chicken--symbol-begin (module)
  (save-excursion (skip-syntax-backward "^-()>") (point)))

;;; Error display

(defun geiser-chicken--display-error (module key msg)
  (newline)
  (when (stringp msg)
    (save-excursion (insert msg))
    (geiser-edit--buttonize-files))
  (and (not key) msg (not (zerop (length msg)))))

;;; Trying to ascertain whether a buffer is Chicken Scheme:

(defconst geiser-chicken--guess-re
  (regexp-opt (append '("csi" "chicken") geiser-chicken-builtin-keywords)))

(defun geiser-chicken--guess ()
  (save-excursion
    (goto-char (point-min))
    (re-search-forward geiser-chicken--guess-re nil t)))

(defun geiser-chicken--external-help (id module)
  "Loads chicken doc into a buffer"
  (browse-url (format "http://api.call-cc.org/cdoc?q=%s&query-name=Look+up" id)))

;;; Keywords and syntax

(defun geiser-chicken--keywords ()
  `((,(format "[[(]%s\\>" (regexp-opt geiser-chicken-builtin-keywords 1)) . 1)))

(geiser-syntax--scheme-indent
 (receive 2)
 (match 1)
 (match-lambda 0)
 (match-lambda* 0)
 (match-let scheme-let-indent)
 (match-let* 1)
 (match-letrec 1)
 (declare 0)
 (cond-expand 0)
 (let-values scheme-let-indent)
 (let*-values scheme-let-indent)
 (letrec-values 1)
 (letrec* 1)
 (parameterize scheme-let-indent)
 (let-location 1)
 (foreign-lambda 2)
 (foreign-lambda* 2)
 (foreign-primitive 2)
 (foreign-safe-lambda 2)
 (foreign-safe-lambda* 2)
 (set! 1)
 (let-optionals* 2)
 (let-optionals 2)
 (condition-case 1)
 (fluid-let 1)
 (and-let* 1)
 (assume 1)
 (cut 1)
 (cute 1)
 (when 1)
 (unless 1)
 (dotimes 1)
 (compiler-typecase 1)
 (ecase 1)
 (use 0)
 (require-extension 0)
 (import 0)
 (handle-exceptions 2)
 (regex-case 1)
 (define-inline 1)
 (define-constant 1)
 (define-syntax-rule 1)
 (define-record-type 1)
 (define-values 1)
 (define-record 1)
 (define-specialization 1)
 (define-type 1)
 (with-input-from-pipe 1)
 (select 1)
 (functor 3)
 (define-interface 1)
 (module 2))

;;; REPL startup

(defconst geiser-chicken-minimum-version "4.8.0.0")

(defun geiser-chicken--version (binary)
  (shell-command-to-string (format "%s -e \"(display (chicken-version))\""
                                   binary)))

(defun connect-to-chicken ()
  "Start a Chicken REPL connected to a remote process."
  (interactive)
  (geiser-connect 'chicken))

(defun geiser-chicken--startup (remote)
  (compilation-setup t)
  (let ((geiser-log-verbose-p t)
        (geiser-chicken-load-file (expand-file-name "chicken/geiser/emacs.scm" geiser-scheme-dir)))
    (if geiser-chicken-compile-geiser-p
      (geiser-eval--send/wait (format "(use utils)(compile-file \"%s\")(import geiser)"
                                      geiser-chicken-load-file))
      (geiser-eval--send/wait (format "(load \"%s\")"
                                      geiser-chicken-load-file)))))

;;; Implementation definition:

(define-geiser-implementation chicken
  (unsupported-procedures '(callers callees generic-methods))
  (binary geiser-chicken--binary)
  (arglist geiser-chicken--parameters)
  (version-command geiser-chicken--version)
  (minimum-version geiser-chicken-minimum-version)
  (repl-startup geiser-chicken--startup)
  (prompt-regexp geiser-chicken--prompt-regexp)
  (debugger-prompt-regexp nil)
  (enter-debugger nil)
  (marshall-procedure geiser-chicken--geiser-procedure)
  (find-module geiser-chicken--get-module)
  (enter-command geiser-chicken--enter-command)
  (exit-command geiser-chicken--exit-command)
  (import-command geiser-chicken--import-command)
  (find-symbol-begin geiser-chicken--symbol-begin)
  (display-error geiser-chicken--display-error)
  (external-help geiser-chicken--external-help)
  (check-buffer geiser-chicken--guess)
  (keywords geiser-chicken--keywords)
  (case-sensitive geiser-chicken-case-sensitive-p))

(geiser-impl--add-to-alist 'regexp "\\.scm$" 'chicken t)
(geiser-impl--add-to-alist 'regexp "\\.release-info$" 'chicken t)
(geiser-impl--add-to-alist 'regexp "\\.meta$" 'chicken t)
(geiser-impl--add-to-alist 'regexp "\\.setup$" 'chicken t)

(provide 'geiser-chicken)
