(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;(set-fringe-mode 10)
(defvar bootstrap-version)
(let ((bootstrap-file
      (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
n      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
        "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
        'silent 'inhibit-cookies)
      (goto-char (point-max))
n      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(setq gc-cons-threshold 1600000)

(setq custom-safe-themes t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))


;(unless (package-installed-p 'use-package)
;  (package-install 'use-package))

;(require 'use-package)

;(setq use-package-always-ensure t)

(set-face-attribute 'default nil :font "Iosevka SS07" :height 120 :weight 'light)
;(set-face-attribute 'line-number nil :family "JetBrains Mono" :height 40)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)



;(use-package solo-jazz-theme
; :straight t
; :config
; (load-theme 'solo-jazz t)
; )

(use-package completion-preview
  :hook (prog-mode . completion-preview-mode))

;; like reverrie and dream
;(use-package ef-themes
;  :straight t
 ; :config
;  (load-theme 'ef-reverie t)
;  )


(use-package lambda-line
  :straight (:type git :host github :repo "lambda-emacs/lambda-line") 
  :custom
  (lambda-line-icon-time t) ;; requires ClockFace font (see below)
  (lambda-line-clockface-update-fontset "ClockFaceRect") ;; set clock icon
  (lambda-line-position 'top) ;; Set position of status-line 
  (lambda-line-abbrev t) ;; abbreviate major modes
  (lambda-line-hspace "  ")  ;; add some cushion
  (lambda-line-prefix t) ;; use a prefix symbol
  (lambda-line-prefix-padding nil) ;; no extra space for prefix 
  (lambda-line-status-invert nil)  ;; no invert colors
  (lambda-line-gui-ro-symbol  " ⨂") ;; symbols
  (lambda-line-gui-mod-symbol " ⬤") 
  (lambda-line-gui-rw-symbol  " ◯") 
  (lambda-line-space-top +.10)  ;; padding on top and bottom of line
  (lambda-line-space-bottom -.10)
  (lambda-line-symbol-position 0.1) ;; adjust the vertical placement of symbol
  :config
  ;; activate lambda-line 

  (lambda-line-mode)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
  (set-face-attribute 'lambda-line-active-name nil :height 50 :family "JetBrains Mono")
;     (set-face-attribute 'lambda-line-active-name nil :height 50 :family "JetBrains Mono")
  ;; set divider line in footer
  (when (eq lambda-line-position 'top)
    (setq-default mode-line-format (list "%_"))
    (setq mode-line-format (list "%_"))))


(use-package lambda-themes
  :straight (:type git :host github :repo "lambda-emacs/lambda-themes") 
  :custom
  (lambda-themes-set-italic-comments t)
  (lambda-themes-set-italic-keywords t)
  (lambda-themes-set-variable-pitch t) 
  :config
  ;; load preferred theme 
  (load-theme 'lambda-light)

    (with-eval-after-load 'lambda-line
  (mapc (lambda (face)
          (when (string-prefix-p "lambda-line-" (symbol-name face))
            (set-face-attribute face nil :height 120)))
        (face-list)))




;(set-face-attribute 'line-number nil :height 80 :family "Roboto Mono")
;(set-face-attribute 'line-number-current-line nil :height 80 :family "Roboto Mono")


)

(use-package dashboard
  :ensure t
  :config
  (setq
   dashboard-center-content t
   dashboard-startup-banner 'logo
   )
  (dashboard-setup-startup-hook))

(use-package tree-sitter
;  (global-tree-sitter-mode)
;  :hook
					;  (prog-mode . tree-sitter-hl-mode)
;  :config
 ; (global-tree-sitter-mode)
  )

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (typst-ts-mode . lsp))
         ;; if you want which-key integration
         ;(lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq lsp-headerline-breadcrumb-enable nil))

(use-package lsp-ui :commands lsp-ui-mode)

(use-package company
  :hook (lsp-mode . company-mode)
  )

(use-package typst-ts-mode
  :after (lsp-mode)
  :straight (:type git :host sourcehut :repo "meow_king/typst-ts-mode")
  :custom
  (typst-ts-mode-watch-options "--open")
  :config  
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp-language-id-configuration
		 '(typst-ts-mode . "typst"))

    (lsp-register-client
     (make-lsp-client :new-connection (lsp-stdio-connection typst-ts-lsp-download-path)
                      :activation-fn (lsp-activate-on "typst")
                      :server-id 'typst)))


  )
(use-package tree-sitter-langs)


(use-package pdf-tools
  :defer t
  :straight t
  :commands (pdf-loader-install)
  :mode "\\.pdf\\"
  :init (pdf-loader-install)
  :config
					;  (pdf-loader-install)
  (add-hook 'pdf-view-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1)))
  (add-hook 'pdf-view-mode-hook (lambda () (auto-revert-mode 1)))
  )



(use-package vertico
  :straight t
  :bind (:map vertico-map
	      ("C-n" . vertico-next)
	      ("C-p" . vertico-previous))
  ;;:custom
  ;;(vertico-cycle t)

	    
  :init
  (vertico-mode))
(setq completion-styles '(basic substring partial-completion flex))
(use-package emacs
  :custom
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))

(use-package savehist
  :init
  (savehist-mode))


;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

;;(use-package orderless
;  :after (vertico)
;  :ensure t
;  :custom
;  (completion-styles '(orderless))      ; Use orderless
;  (completion-category-defaults nil)    ; I want to be in control!
;  (completion-category-overrides
;   '((file (styles basic-remote ; For `tramp' hostname completion with `vertico'
 ;                  orderless)))))

(setq org-src-fontify-natively t)
(setq org-confirm-babel-evaluate nil)


(setq python-shell-interpreter "ipython"
    python-shell-interpreter-args "-i --simple-prompt")


(setq org-babel-python-command "python3")
(setq org-startup-with-inline-images t)
;;(setq org-image-actual-width '(300))  ; Set image size (optional)

(use-package jupyter
  :after (org-mode)
  )

;(use-package org-mode
 ; :config
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (jupyter . t)))
(setq org-hide-emphasis-markers t)

;)


;;(use-package writeroom-mode
;;  :hook (org-mode . writeroom-mode)
;;  :straight  
;;  )



  (custom-theme-set-faces
   'user
   '(variable-pitch ((t (:family "SF Pro Text" :height 140 :weight regular))))
   '(fixed-pitch ((t ( :family "RobotoMono Nerd Font" :height 140)))))


(use-package org-margin
  :after (org-mode)
  :straight '(org-margin :type git :host github :repo "rougier/org-margin")
  :hook (org-mode . org-margin-mode)
  )


(use-package spacious-padding
  :ensure t
  :if (display-graphic-p)
  :hook (after-init . spacious-padding-mode)
  :bind ("<f8>" . spacious-padding-mode)
  :init
  ;; These are the defaults, but I keep it here for visiibility.
  (setq spacious-padding-widths
        '( :internal-border-width 10
           :header-line-width 8
           :mode-line-width 1
           :tab-width 2
           :right-divider-width 30
           :scroll-bar-width 8
           :left-fringe-width 10
           :right-fringe-width 10))

  ;; Read the doc string of `spacious-padding-subtle-mode-line' as
  ;; it is very flexible.
  (setq spacious-padding-subtle-mode-line
        '( :mode-line-active spacious-padding-subtle-mode-line-active
           :mode-line-inactive spacious-padding-subtle-mode-line-inactive)))


;(use-package marginalia
 ; :ensure t
;  :hook (after-init . marginalia-mode)
 ; :config
 ; (setq marginalia-max-relative-age 0)) ; absolute time


;(use-package doom-modeline :config (setq
;doom-modeline-buffer-modification-icon nil) (setq
;doom-modeline-buffer-file-name-style 'relative-from-project)
;(doom-modeline-def-modeline 'my-simple-line '(buffer-info)
;'(minor-modes process vcs major-mode)) (defun
;setup-custom-doom-modeline () (doom-modeline-set-modeline
;'my-simple-line 'default)) (add-hook 'doom-modeline-mode-hook
;'setup-custom-doom-modeline) (setq doom-modeline-height 10) (setq
;doom-modeline-bar-width 0) (setq doom-modeline-window-width-limit 60)
;:init (doom-modeline-mode 1) ; (set-face-attribute 'doom-modeline nil
;:box nil) :config (set-face-attribute 'doom-modeline nil :font
;"Roboto") )


;;(add-hook 'text-mode-hook 'my-set-margins)
(use-package htmlize)

(custom-set-faces
 
 '(fixed-pitch ((t (:family "RobotoMono Nerd Font" :height 140))))
 '(org-document-title ((t (:inherit default :weight bold :font "SF Pro Text" :height 1.75 :underline nil))))
 '(org-level-1 ((t (:inherit default :weight bold :font "SF Pro Text" :height 1.5))))
 '(org-level-2 ((t (:inherit default :weight bold :font "SF Pro Text" :height 1.25))))
 '(org-level-3 ((t (:inherit default :weight bold :font "SF Pro Text" :height 1.1))))
 '(org-level-4 ((t (:inherit default :weight bold :font "SF Pro Text" :height 1))))
 '(org-level-5 ((t (:inherit default :weight bold :font "SF Pro Text"))))
 '(org-level-6 ((t (:inherit default :weight bold :font "SF Pro Text"))))
 '(org-level-7 ((t (:inherit default :weight bold :font "SF Pro Text"))))
 '(org-level-8 ((t (:inherit default :weight bold :font "SF Pro Text"))))
 '(variable-pitch ((t (:family "SF Pro Text" :height 140 :weight regular)))))

(defun replace-in-string (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))


(defun compile-asm ()
  (interactive)
					;(setq compile-command (concat
  (setq compilation-scroll-output 'first-error)
  (setq file_name_wrt_drive_c (message (replace-regexp-in-string ".*/drive_c" "" (file-name-sans-extension buffer-file-name))))
  (compile
	(concat (concat "dosemu -t -E \"build " (replace-in-string "/" "\\\\" file_name_wrt_drive_c)) "\"") 
	)
  (setq compilation-scroll-output nil)
 )

