;;;Code

(defun rado/addhistof (hname)
  "Defines the histogram with the given name in all the header files "
  (interactive "s")
  (find-file "~/Munuee/compact/reader/userinc/Hist_dir.h")
  (goto-line '20)(prelude-smart-open-line-above)
  (insert "TH1F* " hname ";")
  (find-file "~/Munuee/compact/reader/usersrc/Hist_dir.c")
  (goto-line '33)(prelude-smart-open-line-above)
  (insert hname "->Write();")
  (goto-line '43)(prelude-smart-open-line-above)
  (insert "delete " hname ";")
  (goto-line '11)(end-of-defun)
  (previous-line)(prelude-smart-open-line-above)
  (insert hname  " = new TH1F();")(backward-char '2)
  )


(provide 'rado-functions)
