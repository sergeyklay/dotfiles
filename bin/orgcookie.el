#!/usr/bin/env emacs --script

;; Copyright (C) 2024 Serghei Iakovlev <egrep@protonmail.ch>

;; Author: Serghei Iakovlev <egrep@protonmail.ch>
;; URL: https://github.com/sergeyklay/dotfiles/blob/master/bin/orgcookie.el
;; Keywords: tools, misc

;; This file is NOT part of Emacs.

;;;; License

;; This file is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This script scans through specified Org files and identifies headings
;; that are missing the `COOKIE_DATA` property. It outputs the file names,
;; line numbers, and headings with missing properties in a formatted and
;; color-coded manner for better readability in the terminal.
;;
;; Usage:
;;
;;    $ chmod +x ./orgcookie.el
;;    $ find ~/org -type f -name "*.org" -print0 | xargs -0 ./orgcookie.el

;;; Code:

(defun org-heading-missing-cookie-data-p ()
  "Return t if the current heading is missing the COOKIE_DATA property.

This function assumes that the cursor is positioned at the start of a heading."
  (let ((case-fold-search t))
    (not (re-search-forward
          "^:COOKIE_DATA:"
          (save-excursion (outline-next-heading) (point)) t))))

(defun find-headings-missing-cookie-data (file)
  "Return list of cons cells (line-num . heading) in FILE missing COOKIE_DATA.

The function scans all headings in the Org FILE and checks if each heading
contains the COOKIE_DATA property. If a heading does not contain this property,
its line number and heading text are stored in a list."
  (with-temp-buffer
    (insert-file-contents file)
    (org-mode)  ;; Ensure the buffer is in Org mode
    (goto-char (point-min))
    (let (missing-headings)
      ;; Iterate over all headings in the file
      (while (re-search-forward org-heading-regexp nil t)
        ;; If the heading is missing COOKIE_DATA, add it to the list
        (when (org-heading-missing-cookie-data-p)
          (let ((line-num (line-number-at-pos))
                (heading (org-get-heading t t t t)))
            (push (cons line-num heading) missing-headings))))
      (reverse missing-headings))))  ;; Reverse to maintain original order

(defun process-org-files (files)
  "Process Org FILES and print headings missing the COOKIE_DATA property.

For each file in FILES, the function prints the filename in red followed by a
list of headings missing the COOKIE_DATA property, with their line numbers in
green."
  (dolist (file files)
    (let ((missing-headings (find-headings-missing-cookie-data file)))
      (when missing-headings
        ;; Define ANSI color codes for red and green text
        (let ((filename-color "\033[31m")  ;; Red color for filename
              (line-number-color "\033[32m")  ;; Green color for line number
              (reset-color "\033[0m"))  ;; Reset color to default
          ;; Print the filename with a preceding newline
          (message "\n%s%s%s" filename-color file reset-color)
          ;; Print each heading with its line number
          (dolist (heading missing-headings)
            (message "%s%d%s:%s"
                     line-number-color  ;; Start green color
                     (car heading)  ;; Line number
                     reset-color  ;; Reset color
                     (cdr heading))))))))  ;; Heading text

;; Main entry point: get the list of files from
;; command-line arguments and process them
(let ((files (cdr command-line-args-left)))
  (process-org-files files))

;; Local Variables:
;; fill-column: 80
;; eval: (outline-minor-mode)
;; eval: (display-fill-column-indicator-mode)
;; coding: utf-8-unix
;; End:

;;; orgcookie.el ends here
