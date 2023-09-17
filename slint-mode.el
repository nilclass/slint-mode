;;; slint-mode.el --- Major-mode for the Slint UI language

;; Copyright (C) 2023   Niklas Cathor

;; Author: Niklas Cathor <niklas.cathor@gmx.de>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

(defgroup slint nil
  "Major mode for Slint UI files"
  :tag "Slint"
  :group 'languages)

(defcustom slint-indent-level 4
  "Number of spaces for indentation of blocks"
  :tag "Slint"
  :type 'integer
  :safe 'integerp
  :group 'slint)

(defvar slint-mode-hook nil)
(defvar slint-mode-map
  (let ((map (make-keymap)))
    map)
  "Key bindings for Slint mode.")

(defvar slint-mode-syntax-table
  (let ((st (make-syntax-table)))
    ; Treat underscore ('_') as part of word
    (modify-syntax-entry ?_ "w" st)
    ; Treat dash ('-') as part of word
    (modify-syntax-entry ?- "w" st)
    ; Comments
    (modify-syntax-entry ?/ ". 124b" st)
    (modify-syntax-entry ?* ". 23" st)
    (modify-syntax-entry ?\n "> b" st)
    st)
  "Syntax table for Slint mode.")

(defconst slint-keywords
  '("import" "export" "from" "component" "inherits"
    "in-out" "property" "callback" "as" "in" "out"
    "animate"))

(defconst slint-builtin-types
  '("angle" "bool" "brush" "color" "duration" "easing"
    "float" "image" "int" "length" "percent" "physical-length"
    "relative-font-size" "string"))

(defconst slint-font-lock-keywords
  (list
   ;; Property key
   '("\\(\\w+\\)\\s-*:" . (1 font-lock-variable-name-face))
   ;; Component names (starting with capital letter)
   '("\\([A-Z]\\w*\\)" . font-lock-type-face)
   ;; Function call, function signature, @image-url syntax
   '("\\(@?\\w+\\)(" (1 font-lock-function-name-face))
   ;; Colors
   '("\\(#[0-9a-zA-Z]+\\)" . font-lock-preprocessor-face)
   ;; Numbers, with or without unit
   '("\\([0-9]+\\(?:ph?x\\|rem\\|[mu]?s\\)?\\)" . font-lock-preprocessor-face)
   ;; Builtin types
   `(,(regexp-opt slint-builtin-types t) . font-lock-type-face)
   ;; Keywords
   `(,(regexp-opt slint-keywords t) . font-lock-keyword-face)))

(defun slint-indent-line ()
  "Indent Slint UI file line."
  (let ((position (point))
        (indent-pos))
    (save-excursion
      (back-to-indentation)
      (let ((level (car (syntax-ppss))))
        (when (looking-at "\\s-*}") ; this line starts with the closing brace
          (setq level (1- level)))
        (indent-line-to (* slint-indent-level level))
        (setq indent-pos (point))))
    (when (< position indent-pos)
      (goto-char indent-pos))))

(define-derived-mode slint-mode prog-mode "Slint"
  "A major mode for editing Slint UI files."
  (setq-local comment-start "// ")
  (setq-local indent-line-function 'slint-indent-line)
  (set-syntax-table slint-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults) '(slint-font-lock-keywords)))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
               '(slint-mode . "slint"))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "slint-lsp")
                    :activation-fn (lsp-activate-on "slint")
                    :server-id 'slint)))

(add-to-list 'auto-mode-alist '("\\.slint\\'" . slint-mode))

(provide 'slint-mode)
