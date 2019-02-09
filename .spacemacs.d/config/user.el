;; -*- mode: emacs-lisp -*-

(defun highlight-todos ()
  (font-lock-add-keywords nil '(("\\<\\(NOTE\\|TODO\\|HACK\\|BUG\\):" 1 font-lock-warning-face t))))

(add-hook 'text-mode-hook 'highlight-todos)
(add-hook 'prog-mode-hook 'highlight-todos)
