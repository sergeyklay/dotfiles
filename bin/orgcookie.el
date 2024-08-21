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
;; You can also ignore specific heading levels by passing the option
;; `--ignore-heading=LEVELS` where `LEVELS` is a comma-separated list of
;; levels to ignore. For example, `--ignore-heading=1,2` will skip all
;; first- and second-level headings.
;;
;; Usage:
;;
;;    $ chmod +x ./orgcookie.el
;;    $ find ~/org -type f -name "*.org" -print0 | xargs -0 ./orgcookie.el
;;    $ find ~/org -type f -name "*.org" -print0 | xargs -0 ./orgcookie.el -- --ignore-heading=1,2

;;; Code:

(defun org-heading-missing-cookie-data-p (ignore-levels)
  "Return t if the current heading is missing the COOKIE_DATA property.

IGNORE-LEVELS is a list of heading levels to be ignored. This function assumes
that the cursor is positioned at the start of a heading."
  (let ((case-fold-search t)
        (current-level (org-outline-level)))
    (if (member current-level ignore-levels)
        nil
      (not (re-search-forward
            "^:COOKIE_DATA:"
            (save-excursion (outline-next-heading) (point)) t)))))

(defun find-headings-missing-cookie-data (file ignore-levels)
  "Return list of cons cells (line-num . heading) in FILE missing COOKIE_DATA.

IGNORE-LEVELS is a list of heading levels to be ignored. The function scans
all headings in the Org FILE and checks if each heading contains the
COOKIE_DATA property. If a heading does not contain this property and its
level is not in IGNORE-LEVELS, its line number and heading text are stored
in a list."
  (with-temp-buffer
    (insert-file-contents file)
    (org-mode)  ;; Ensure the buffer is in Org mode
    (goto-char (point-min))
    (let (missing-headings)
      ;; Iterate over all headings in the file
      (while (re-search-forward org-heading-regexp nil t)
        ;; If the heading is missing COOKIE_DATA, add it to the list
        (when (org-heading-missing-cookie-data-p ignore-levels)
          (let ((line-num (line-number-at-pos))
                (heading (org-get-heading t t t t)))
            (push (cons line-num heading) missing-headings))))
      (reverse missing-headings))))  ;; Reverse to maintain original order

(defun process-org-files (files ignore-levels)
  "Process Org FILES and print headings missing the COOKIE_DATA property.

IGNORE-LEVELS is a list of heading levels to be ignored. For each file in
FILES, the function prints the filename in red followed by a list of headings
missing the COOKIE_DATA property, with their line numbers in green."
  (dolist (file files)
    (let ((missing-headings (find-headings-missing-cookie-data file ignore-levels)))
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

(defun parse-ignore-levels (arg)
  "Parse ARG and return a list of heading levels to ignore.

ARG is a string potentially containing comma-separated heading levels.
Returns nil if ARG is empty, not provided, or does not contain valid numbers."
  (if (or (not arg) (string= arg ""))
      nil  ;; If no argument or empty, return nil (no levels to ignore)
    ;; Remove all non-digit and non-comma characters
    (let* ((cleaned-arg (replace-regexp-in-string "[^0-9,]" "" arg))
           ;; Remove multiple commas
           (cleaned-arg (replace-regexp-in-string ",+" "," cleaned-arg))
           ;; Remove leading and trailing spaces
           (cleaned-arg (string-trim cleaned-arg)))
      (if (string= cleaned-arg "")
          nil  ;; If the cleaned string is empty, return nil
        ;; Convert cleaned string to a list of numbers
        (mapcar #'string-to-number (split-string cleaned-arg ","))))))


;; Main entry point: get the list of files and options from
;; command-line arguments and process them
(let* ((ignore-arg (seq-find (lambda (arg)
                               (string-prefix-p "--ignore-heading=" arg))
                             command-line-args-left))
       (ignore-levels (if ignore-arg
                          (parse-ignore-levels (substring ignore-arg 16))
                        nil))
       (files (seq-remove (lambda (arg)
                            (string-prefix-p "--ignore-heading=" arg))
                          (cdr command-line-args-left))))
  (process-org-files files ignore-levels))

;; Local Variables:
;; fill-column: 80
;; eval: (outline-minor-mode)
;; eval: (display-fill-column-indicator-mode)
;; coding: utf-8-unix
;; End:

;;; orgcookie.el ends here
