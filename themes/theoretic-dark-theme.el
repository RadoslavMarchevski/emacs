;;; koval-dark-theme.el

;; This file is NOT part of GNU Emacs.

;;; License:

;; This is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.
;;
;; This is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
;; for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
;; MA 02111-1307, USA.

;;; Code:

(require 'color)

(deftheme theoretic-dark
  "Dark, customized theoretic color theme.")

(let (
      (class '((class color) (min-colors 89)))
      ;; default foreground and background colors
      (fg "#eeeeee")
      (bg "#303030")

      ;; special colors
      (tq "turquoise")

      ;; blue colors
      (lblue "#87ceeb")
      (mblue "#125aa0")
      (dblue "#000088")

      ;; grey colors
      (lgrey "#888888")
      (mgrey "#555555")
      (dgrey "#2f2f2f")

      ;; red colors
      (lred  "#dd3300")
      (mred  "#dd1100")
      (dred  "#660d00")

      ;; green colors
      (lgreen "#00ff00")
      (mgreen "#00cc00")
      (dgreen "#009900")

      ;; purple colors
      (lpurple "#ffbbff")
      (mpurple "#ff88ff")
      (dpurple "#770077")

      ;; yellow colors
      (lyellow "#ffffdd")
      (myellow "#ffff00")
      (dyellow "#ffcc00")

      ;; orange collors
      (lorange "#ff7f00")
      (morange "#cd8500")
      (dorange "#8b5a00")

     )

  (custom-theme-set-faces
   'theoretic-dark

   ;; basic faces in emacs
   `(default ((,class (:foreground ,fg :background ,bg))))
   `(cursor  ((,class (:foreground ,bg :background "yellow"))))
   `(region  ((,class (:background ,mblue))))
   `(highlight ((,class (:background ,dpurple))))
   `(trailing-whitespace ((,class (:background "grey"))))
   `(minibuffer-prompt   ((,class (:foreground "turquoise" ))))

   ;; font lock faces
   `(font-lock-builtin-face ((,class (:foreground ,lblue))))
   `(font-lock-function-name-face
     ((,class (:weight bold :foreground ,dyellow))))
   `(font-lock-keyword-face
     ((,class (:weight bold :foreground ,lblue))))
   `(font-lock-string-face
     ((,class (:slant italic :foreground ,mpurple))))

   ;; mode-line customization
   `(mode-line
     ((,class
       (:box (:line-width 1 :color nil :style released-button)
             :foreground ,fg :background "#222222"))))
   `(mode-line-buffer-id
     ((,class
       (:weight bold :foreground "orange"))))
   `(mode-line-inactive
     ((,class
       (:background "#555753" :foreground "#bbbbbc"))))

   `(diary-face ((,class (:bold t :foreground "IndianRed"))))
   `(custom-group-tag ((,class (:bold t :foreground "#edd400" :height 1.3))))
   `(custom-variable-tag ((,class (:bold t :foreground "#edd400" :height 1.1))))
   `(custom-face-tag ((,class (:bold t :foreground "#edd400" :height 1.1))))
   `(custom-state-face ((,class (:foreground "#729fcf"))))
   `(custom-documentation ((,class (:italic t))))

   `(gnus-cite-1 ((,class (:foreground "wheat1"))))
   `(gnus-cite-2 ((,class (:foreground "PaleGreen1"))))
   `(gnus-cite-3 ((,class (:foreground "tan1"))))
   `(gnus-cite-4 ((,class (:foreground "PaleGreen1"))))

   `(gnus-group-mail-1 ((,class (:bold t :foreground "magenta"))))
   `(gnus-group-mail-2 ((,class (:bold t :foreground "magenta"))))
   `(gnus-group-mail-3 ((,class (:bold t :foreground "magenta"))))
   `(gnus-group-mail-low ((,class (:bold t :foreground "magenta"))))

   `(gnus-group-mail-1-empty ((,class (:foreground "green"))))
   `(gnus-group-mail-2-empty ((,class (:foreground "#00ffff"))))
   `(gnus-group-mail-3-empty ((,class (:foreground "cyan"))))
   `(gnus-group-mail-low-empty ((,class (:foreground "dodger blue"))))

   `(gnus-group-news-1 ((,class (:bold t :foreground "yellow"))))
   `(gnus-group-news-2 ((,class (:bold t :foreground "yellow"))))
   `(gnus-group-news-3 ((,class (:bold t :foreground "yellow"))))
   `(gnus-group-news-4 ((,class (:bold t :foreground "yellow"))))
   `(gnus-group-news-5 ((,class (:bold t :foreground "yellow"))))

   `(gnus-group-news-1-empty ((,class (:foreground "green"))))
   `(gnus-group-news-2-empty ((,class (:foreground "#00ffff"))))
   `(gnus-group-news-3-empty ((,class (:foreground "cyan"))))
   `(gnus-group-news-4-empty ((,class (:foreground "#729fcf"))))
   `(gnus-group-news-5-empty ((,class (:foreground "#729fcf"))))

   `(gnus-group-news-low-empty((,class (:foreground "dodger blue"))))
   `(gnus-group-news-low((,class (:bold t :foreground "dodger blue"))))

   `(gnus-header-name ((,class (:bold t :foreground "#729fcf" :height 1.0))))
   `(gnus-header-from ((,class (:bold t :foreground "PaleGreen1" :height 1.2))))
   `(gnus-header-subject ((,class (:foreground "#edd400" :height 1.1))))
   `(gnus-header-content ((,class (:italic t :foreground "#8ae234"))))
   `(gnus-header-newsgroups((,class (:italic t :bold t :foreground "LightSkyBlue3"))))
   `(gnus-signature((,class (:italic t :foreground "grey20"))))

   `(gnus-summary-cancelled((,class (:background "black" :foreground "yellow"))))
   `(gnus-summary-high-ancient((,class (:bold t :foreground "green"))))
   `(gnus-summary-high-read((,class (:bold t :foreground "lime green"))))
   `(gnus-summary-high-ticked((,class (:bold t :foreground "tomato"))))
   `(gnus-summary-high-unread((,class (:bold t :foreground "white"))))
   `(gnus-summary-low-ancient((,class (:italic t :foreground "lime green"))))
   `(gnus-summary-low-read((,class (:italic t :foreground "green"))))
   `(gnus-summary-low-ticked((,class (:italic t :foreground "dark red"))))
   `(gnus-summary-low-unread((,class (:italic t :foreground "white"))))
   `(gnus-summary-normal-ancient((,class (:foreground "green"))))
   `(gnus-summary-normal-read((,class (:foreground "lime green"))))
   `(gnus-summary-normal-ticked((,class (:foreground "indian red"))))
   `(gnus-summary-normal-unread((,class (:foreground "white"))))
   `(gnus-summary-selected ((,class (:background "brown4" :foreground "white"))))

   `(message-cited-text ((,class (:foreground "#edd400"))))
   `(message-header-name((,class (:foreground "tomato"))))
   `(message-header-newsgroups((,class (:italic t :bold t :foreground "LightSkyBlue3"))))
   `(message-header-other((,class (:foreground "LightSkyBlue3"))))
   `(message-header-xheader((,class (:foreground "DodgerBlue3"))))
   `(message-header-subject ((,class (:foreground "white"))))
   `(message-header-to ((,class (:foreground "white"))))
   `(message-header-cc ((,class (:foreground "white"))))

   `(ido-subdir ((,class (:inherit font-lock-function-name-face))))

   `(org-document-title ((,class (:foreground "pale turquoise" :bold t :height 1.8))))
   `(org-hide ((,class (:foreground "#2e3436"))))
   `(org-level-1 ((,class (:bold nil :foreground "tan" :height 1.8))))
   `(org-level-2 ((,class (:bold nil :foreground "turquoise1"   :height 1.4))))
   `(org-level-3 ((,class (:bold nil :foreground "chartreuse1" :height 1.2))))
   `(org-level-4 ((,class (:bold nil :foreground "gold1" :height 1.0))))

   `(org-date ((,class (:underline nil :foreground "dodger blue"))))
   `(org-footnote  ((,class (:bold t :foreground "magenta3"))))
   `(org-link ((,class (:inherit link))))
   `(org-special-keyword ((,class (:foreground "coral3"))))
   `(org-verbatim ((,class (:foreground "#eeeeec" :underline t :slant italic))))

   `(org-code      ((,class (:background "grey27" :foreground "wheat"))))
   `(org-block ((,class (:background "grey27" :foreground "wheat"))))
   `(org-block-begin-line ((,class (:foreground "tomato"))))
   `(org-meta-line ((,class (:foreground "tomato"))) )

   `(org-quote ((,class (:inherit org-block :slant italic))))
   `(org-verse ((,class (:inherit org-block :slant italic))))
   `(org-todo ((,class (:bold nil :foreground "brown1"))))
   `(org-done ((,class (:bold nil :foreground "SpringGreen4"))))
   `(org-agenda-structure ((,class (:weight bold :foreground "tomato"))))
   `(org-agenda-date ((,class (:foreground "#6ac214"))))
   `(org-agenda-date-weekend ((,class (:weight normal :foreground "dodger blue"))))
   `(org-agenda-date-today ((,class (:weight bold :foreground "#edd400"))))

   ;; sunrise commander headings
   `(sr-active-path-face ((,class (:background "#252b2b" :foreground "yellow" :height 120))))
   `(sr-passive-path-face ((,class (:background "#252b2b" :foreground "grey"  :height 120))))
   `(sr-editing-path-face ((,class (:background "#252b2b" :foreground "red"   :height 120))))
   `(sr-directory-face    ((,class (:foreground "yellow"))))
   `(sr-packaged-face     ((,class (:foreground "violet"  nil))))
   `(sr-compressed-face ((,class (:foreground "violet"))))
   `(sr-log-face ((,class (:inherit default))))
   `(sr-xml-face ((,class (:foreground "SpringGreen3"))))

   ;; latex mode customization
   `(font-latex-sectioning-1-face ((,class (:inherit org-level-1))))
   `(font-latex-sectioning-2-face ((,class (:inherit org-level-2))))
   `(font-latex-sectioning-3-face ((,class (:inherit org-level-3))))
   `(font-latex-sectioning-4-face ((,class (:inherit org-level-4))))

   ;; info mode titles
   `(info-title-1 ((,class (:inherit org-level-1))))
   `(info-title-2 ((,class (:inherit org-level-2))))
   `(info-title-3 ((,class (:inherit org-level-3))))
   `(info-title-4 ((,class (:inherit org-level-4))))

   ;; code in Gnus
   `(mm-uu-extract ((,class (:background "#252b2b" :foreground "snow"))))

   ;; helm faces
   `(helm-buffer-directory ((t (:inherit font-lock-function-name-face))))
   `(helm-ff-directory ((t (:inherit dired-directory))))
   `(helm-ff-dotted-directory ((t (:inherit dired-directory))))
   `(helm-ff-file ((t (:inherit default))))
   `(helm-ff-symlink ((t (:inherit font-lock-constant-face))))
   `(helm-selection ((t (:inherit highlight))))
   `(helm-source-header ((t (:inherit org-level-2))))

   ;; shell mode
   `(sh-heredoc ((t (:foreground "LightYellow"))))

   ;; company completion
   `(company-tooltip ((t (:inherit default :background ,(color-lighten-name bg 2)))))
   `(company-scrollbar-bg ((t (:background ,(color-lighten-name bg 10)))))
   `(company-scrollbar-fg ((t (:background ,(color-lighten-name bg 5)))))
   `(company-tooltip-selection ((t (:inherit font-lock-function-name-face :background ,(color-darken-name bg 5)))))
   `(company-tooltip-common ((t (:inherit font-lock-constant-face :background ,(color-darken-name bg 5)))))
   )

  (setq org-todo-keyword-faces
        (quote (("TODO" :inherit org-todo)
                ("NEXT" :inherit org-todo)
                ("DONE" :inherit org-done)
                ("HABIT" :inherit font-lock-builtin-face)
                ("CHECK" :inherit org-done)
                ("WAITING" :inherit font-lock-builtin-face)
                ("HOLD" :inherit org-todo)
                ("CANCELLED" :inherit org-done)
                ("MEETING" :inherit org-done)
                ("PHONE" :inherit org-done)
                )))
  )
(provide-theme 'theoretic-dark)

;;; theoretic-dark-theme.el ends here
