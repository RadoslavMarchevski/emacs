;;;Code
(defun rado/addhistof (hname)
  "Defines the histogram with the given name in all the header files "
  (interactive "s")
  (find-file "~/git/Analysis/userinc/Hist_dir.h")
  (goto-line 50)(end-of-defun)(prelude-smart-open-line-above)
  (insert "TH1F* " hname ";")
  ;;;Moving the whole line where the point is n lines above
  (beginning-of-line)(set-mark (beginning-of-line))(end-of-line)(move-text-up 6)

  (find-file "~/git/Analysis/usersrc/Hist_dir.c")
  (end-of-buffer)(previous-line)(prelude-smart-open-line-above)
  (insert "delete " hname ";")
  (beginning-of-line)(set-mark (beginning-of-line))(end-of-line)(move-text-up 1)

  (beginning-of-defun)(beginning-of-defun)(end-of-defun)(previous-line)(prelude-smart-open-line-above)
  (insert hname "->Write();")
  (beginning-of-line)(set-mark (beginning-of-line))(end-of-line)(move-text-up 1)

  (beginning-of-buffer)(end-of-defun)
  (previous-line)(prelude-smart-open-line-above)
  (insert hname  " = new TH1F();")
  (beginning-of-line)(set-mark (beginning-of-line))(end-of-line)(move-text-up 2)(previous-line '1)
  )
(global-set-key (kbd "M-p") 'rado/window_config)
(defun rado/open_project_files ()
  "Loading all the necessary files for my analysis"
  (interactive)
  (message "Loading project files ...")
  (find-file "~/git/Analysis/usersrc/Hist_dir.c")
  (find-file "~/git/Analysis/usersrc/Charged_Particle.c")
  (find-file "~/git/Analysis/usersrc/user_superCmpEvent_NEW.c")
  (find-file "~/git/Analysis/usersrc/user_init.c")
  (find-file "~/git/Analysis/usersrc/Vertex_computation.c")
  (find-file "~/git/Analysis/userinc/Hist_dir.h")
  (find-file "~/git/Analysis/userinc/Charged_Particle.h")
  (find-file "~/git/Analysis/userinc/Vertex_computation.h")
  (find-file "~/git/Analysis/userinc/user_NEW.h")
  (find-file "~/git/Analysis/usersrc/user_exit.c")
  (find-file "~/.emacs.d/personal/postload/rado_function.el")
  )
;;;New function
(defun rado/window_config ()
  "Make window configuration with necessary file for my analysis"
  (interactive)
  (find-file "~/git/Analysis/usersrc/Hist_dir.c")
  (split-window-right)(windmove-right)(find-file "~/git/Analysis/usersrc/Charged_Particle.c")
  (split-window-below)(windmove-down)(find-file "~/git/Analysis/userinc/Charged_Particle.h")
  (windmove-left)(split-window-below)(windmove-down)(find-file "~/git/Analysis/userinc/Hist_dir.h")
  (message "Your wish is completed Master :)")
  )

(provide 'rado_functions)
;;;rado_functions.el  ends here
