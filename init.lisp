(in-package :lem-user)

;; Functions
(define-command find-definitions-and-center () ()
  (lem/language-mode:find-definitions)
  (window-recenter (current-window)))

(define-command find-references-and-center () ()
  (lem/language-mode:find-references)
  (window-recenter (current-window)))

(define-command wrap-round-and-insert () ()
  (lem-paredit-mode:paredit-wrap-round)
  (lem-vi-mode/commands:vi-insert))

(defun left-buffer ()
  (window-buffer (left-window (current-window))))

(defun right-buffer ()
  (window-buffer (right-window (current-window))))

(defun up-buffer ()
  (window-buffer (up-window (current-window))))

(defun down-buffer ()
  (window-buffer (down-window (current-window))))

(define-command window-swap-left () ()
  (let ((old-buffer (current-buffer)))
    (switch-to-buffer (left-buffer))
    (window-move-left)
    (switch-to-buffer old-buffer)))

(define-command window-swap-right () ()
  (let ((old-buffer (current-buffer)))
    (switch-to-buffer (right-buffer))
    (window-move-right)
    (switch-to-buffer old-buffer)))

(define-command window-swap-up () ()
  (let ((old-buffer (current-buffer)))
    (switch-to-buffer (up-buffer))
    (window-move-up)
    (switch-to-buffer old-buffer)))

(define-command window-swap-down () ()
  (let ((old-buffer (current-buffer)))
    (switch-to-buffer (down-buffer))
    (window-move-down)
    (switch-to-buffer old-buffer)))

;; Use vi mode for shortcuts
(lem-vi-mode:vi-mode)

;; Visual stuff
(lem/line-numbers:toggle-line-numbers)
(lem-core/commands/window::toggle-line-wrap)

;; When switching to the REPL, start with insert mode
(add-hook lem-lisp-mode:*lisp-repl-mode-hook* 
          'lem-vi-mode/commands:vi-insert)
(add-hook lem-lisp-mode:*lisp-repl-mode-hook* 
          'lem-paredit-mode:paredit-mode)
;; Paredit stuff
(define-key lem-vi-mode:*normal-keymap* ">" 'lem-paredit-mode:paredit-slurp)
(define-key lem-vi-mode:*normal-keymap* "<" 'lem-paredit-mode:paredit-barf)
(define-key lem-vi-mode:*normal-keymap* "(" 'wrap-round-and-insert)
(define-key lem-vi-mode:*insert-keymap* "(" 'lem-paredit-mode:paredit-insert-paren)
(define-key lem-vi-mode:*insert-keymap* ")" 'lem-paredit-mode:paredit-close-parenthesis)

;; SPC b
(defvar *space-b-keymap*
  (make-keymap :name '*space-b-keymap*)
  "buffer menu")
(define-keys *space-b-keymap*
  ("f" 'lem-core/commands/file:format-current-buffer)
  ("b" 'lem-core/commands/window:select-buffer)
  ("d" 'lem-core/commands/window:kill-buffer)
  ("n" 'lem-core/commands/window:next-buffer)
  ("p" 'lem-core/commands/window:previous-buffer)
  ("r" 'lem-core/commands/file:revert-buffer))

;; SPC f
(defvar *space-f-keymap*
  (make-keymap :name '*space-f-keymap*)
  "file menu")
(define-keys *space-f-keymap*
  ("f" 'lem-core/commands/file:find-file)
  ("s" 'lem-core/commands/file:save-current-buffer)
  ("F" 'lem-core/commands/file:find-file-recursively)
  ("t" 'lem/filer::filer))

;; SPC g
(defvar *space-g-keymap*
  (make-keymap :name '*space-g-keymap*)
  "git menu")
(define-keys *space-g-keymap*
  ("s" 'lem/legit::legit-status))

;; SPC h
(defvar *space-h-keymap*
  (make-keymap :name '*space-h-keymap*)
  "help menu")
(define-keys *space-h-keymap*
  ("a" 'lem-lisp-mode/internal:lisp-apropos-all)
  ("b" 'lem-core/commands/help::describe-bindings)
  ("f" 'lem-lisp-mode/internal:lisp-describe-symbol)
  ("k" 'lem-core/commands/help::describe-key)
  ("m" 'lem-core/commands/help::describe-mode))

;; SPC j
(defvar *space-j-keymap*
  (make-keymap :name '*space-j-keymap*)
  "jump menu")
(define-keys *space-j-keymap*
  ("i" 'lem/detective:detective-all))

;; SPC m
(defvar *space-m-keymap*
  (make-keymap :name '*space-m-keymap*)
  "lisp menu")
(define-keys *space-m-keymap*
  ;; Repl
  ("r" 'lem-lisp-mode:start-lisp-repl)

  ;; Help
  ("h" 'lem-lisp-mode/hyperspec:hyperspec-at-point)

  ;; Macros
  ("m" 'lem-lisp-mode:lisp-macroexpand)
  
  ;; Compile
  ("c f" 'lem-lisp-mode:lisp-compile-defun)
  ("c c" 'lem-lisp-mode:lisp-compile-and-load-file)
  ("c r" 'lem-lisp-mode:lisp-compile-region)
  
  ;; Eval
  ("e e" 'lisp-eval-at-point)
  ("e c" 'lisp-eval-clear)
  ("e r" 'lisp-eval-region)
  ("e i" 'lisp-eval-last-expression-and-insert))

;; SPC p
(defvar *space-p-keymap*
  (make-keymap :name '*space-p-keymap*)
  "project menu")
(define-keys *space-p-keymap*
  ("f" 'lem-core/commands/project:project-find-file)
  ("p" 'lem-core/commands/project:project-switch)
  ("g" 'lem/grep::project-grep)
  ("s" 'lem-core/commands/project:project-save)
  ("t" 'lem/filer::filer)
  ("u" 'lem-core/commands/project:project-unsave))

;; SPC s
(defvar *space-t-keymap*
  (make-keymap :name '*space-t-keymap*)
  "search menu")
(define-keys *space-t-keymap*
  ("d" 'lem-language))

;; SPC t
(defvar *space-t-keymap*
  (make-keymap :name '*space-t-keymap*)
  "toggle menu")
(define-keys *space-t-keymap*
  ("f" 'lem-core/commands/frame:toggle-frame-fullscreen)
  ("n" 'lem/line-numbers:toggle-line-numbers)
  ("p" 'lem/show-paren::toggle-show-paren)
  ("s" 'lem-core::list-color-themes)
  ("w" 'lem-core/commands/window::toggle-line-wrap))

;; SPC w
(defvar *space-w-keymap*
  (make-keymap :name '*space-w-keymap*)
  "window menu")
(define-keys *space-w-keymap*
  ;; Deleting
  ("d" 'lem-core/commands/window:delete-active-window)
  ("1" 'lem-core/commands/window:delete-other-windows)
  
  ;; Move between windows
  ("h" 'lem-core/commands/window:window-move-left)
  ("j" 'lem-core/commands/window:window-move-down)
  ("k" 'lem-core/commands/window:window-move-up)
  ("l" 'lem-core/commands/window:window-move-right)
  ("n" 'lem-core/commands/window:next-window)
  ("p" 'lem-core/commands/window:previous-window)
  
  ;; Swap buffers of adjacent windows
  ("H" 'window-swap-left)
  ("J" 'window-swap-down)
  ("K" 'window-swap-up)
  ("L" 'window-swap-right)

  ;; Split windows
  ("s" 'lem-core/commands/window:split-active-window-vertically)
  ("v" 'lem-core/commands/window:split-active-window-horizontally))

;; SPC
(defvar *space-keymap*
  (make-keymap :name '*space-keymap*)
  "The root keymap for the space menu.")
(define-keys *space-keymap*
  ("b" *space-b-keymap*)
  ("f" *space-f-keymap*)
  ("g" *space-g-keymap*)
  ("h" *space-h-keymap*)
  ("j" *space-j-keymap*)
  ("m" *space-m-keymap*)
  ("p" *space-p-keymap*)
  ("t" *space-t-keymap*)
  ("w" *space-w-keymap*)
  ("q q" 'lem-core/commands/other:exit-lem)
  ("'" 'lem-terminal/terminal-mode::terminal)
  ("Space" 'lem-core/commands/other:execute-command))

(define-key lem-vi-mode:*normal-keymap* "g d" 'find-definitions-and-center)
(define-key lem-vi-mode:*normal-keymap* "g r" 'find-references-and-center)
(define-key lem-vi-mode:*normal-keymap* "g h" 'pop-definition-stack)

(define-key lem-vi-mode:*normal-keymap* "Space" *space-keymap*) ; leader
(define-key lem-vi-mode:*insert-keymap* "M-m" *space-keymap*)   ; alternative leader
