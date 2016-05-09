;;; package --- Summary;
;;; Commentary:
;;; Creating personalized yasnippets settings put
;;; in a personal directory on Dropbox

;;; Code:
(require 'yasnippet)
(yas-global-mode 1)
;; Use custom snippets.
(add-to-list 'yas-snippet-dirs "~/Dropbox/Emacs/snippets/")
(yas-reload-all)
;;Yasnippet bindings
(global-set-key (kbd "C-x y n") 'yas/new-snippet)


(provide 'prelude-yas)
;;; prelude-yas.el ends here
