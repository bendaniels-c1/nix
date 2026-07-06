;; Package archives (if not already set up)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Force refresh package contents on first run or if archives are stale
(when (not package-archive-contents)
  (package-refresh-contents))

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Install packages if not already installed
(dolist (pkg '(all-the-icons
               all-the-icons-ibuffer
               beacon
               cape
               consult
               consult-projectile
               corfu-terminal
               dashboard
               eglot
               embark
               embark-consult
               go-mode
               keychain-environment
               magit
               marginalia
               markdown-mode
               catppuccin-theme
               orderless
               projectile
               protobuf-mode
               swift-mode
               treesit-auto
               treemacs
               treemacs-all-the-icons
               treemacs-projectile
               typescript-mode
               vertico
               which-key
               vterm    ;; Terminal emulator for claude-code
               ligature
               proof-general
               company-coq
               terraform-mode
               terraform-doc))
  (unless (package-installed-p pkg)
    (condition-case err
        (package-install pkg)
      (error
       (message "Failed to install %s, refreshing and retrying: %s" pkg err)
       (package-refresh-contents)
       (package-install pkg)))))

;; Install dependencies from GitHub for claude-code
(use-package inheritenv
  :vc (:url "https://github.com/purcell/inheritenv" :rev :newest))

;; Install and configure claude-code
(use-package claude-code
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :bind-keymap ("C-c c" . claude-code-command-map)
  :config
  (setq claude-code-terminal-backend 'vterm)

  ;; Display Claude Code in a vertical split on the right side
  (add-to-list 'display-buffer-alist
               '("^\\*claude"
                 (display-buffer-in-side-window)
                 (side . right)
                 (window-width . 90)))

  ;; Default to read-only mode when Claude Code starts
  (add-hook 'claude-code-start-hook
            (lambda ()
              (when (and (boundp 'claude-code-buffer)
                         claude-code-buffer
                         (buffer-live-p claude-code-buffer))
                (with-current-buffer claude-code-buffer
                  (claude-code-read-only-mode))))))

;; Proof General (Coq/Rocq interactive proof IDE)
(use-package proof-general
  :ensure t)

;; Company-Coq (completion and convenience for Coq)
(use-package company-coq
  :ensure t
  :hook (coq-mode . company-coq-mode))

;; Coq mode setup: font and keybindings
(defun my/coq-mode-setup ()
  "Configure Coq mode with JuliaMono font and keybindings."
  ;; Apply JuliaMono font buffer-locally for better math symbol rendering
  (face-remap-add-relative 'default :family "JuliaMono")

  ;; Disable auto-completion in Coq mode
  (corfu-mode -1)

  ;; Keybinding customization
  (define-key coq-mode-map (kbd "C-c C-p") 'proof-undo-last-successful-command)
  (define-key coq-mode-map (kbd "C-c C-u") nil))

(add-hook 'coq-mode-hook #'my/coq-mode-setup)

;; Terraform mode - HCL syntax, formatting, and documentation
(use-package terraform-mode
  :ensure t
  :custom
  (terraform-indent-level 2)
  (terraform-format-on-save t)
  :hook
  (terraform-mode . eglot-ensure)
  (terraform-mode . outline-minor-mode))

;; Terraform documentation browser (M-x terraform-doc)
(use-package terraform-doc
  :ensure t)

;; Which-key - Display available keybindings in popup
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom))

;; Load the modes
(require 'go-mode)
(require 'typescript-mode)
(require 'swift-mode)

;; Spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; ============================================================================
;; TREE-SITTER CONFIGURATION
;; ============================================================================


;; Treesit-auto - automatically use tree-sitter modes when available
(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install 'prompt)

  ;; Configure tree-sitter language grammar sources with specific working revisions
  ;; This fixes version mismatch issues with Go and gomod grammars
  (setq treesit-language-source-alist
        '((bash "https://github.com/tree-sitter/tree-sitter-bash" "v0.20.4")
          (go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
          (gomod "https://github.com/camdencheek/tree-sitter-go-mod" "v1.0.2")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src")))

  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Load the theme
(setq catppuccin-flavor 'mocha)
(load-theme 'catppuccin :no-confirm)

;; Set default font
(set-face-attribute 'default nil
                    :family "Fira Code"
                    :weight 'regular
                    :height 140)  ; Height is in 1/10pt, so 140 = 14pt

;; Enable prettify-symbols in terminal Emacs (used by company-coq)
(setq company-coq-features/prettify-symbols-in-terminals t)

;; Fira Code ligatures (requires Emacs 28+ with HarfBuzz)
(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures 'prog-mode
                          '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-"
                            "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}" "--" "---"
                            "-->" "->" "->>" "-<" "-<<" "-~" "#{" "#[" "##" "###"
                            "####" "#(" "#?" "#_" "#_(" ".-" ".=" ".." "..<" "..."
                            "?=" "??" ";;" "/*" "/**" "/=" "/==" "/>" "//" "///"
                            "&&" "||" "||=" "|=" "|>" "^=" "$>" "++" "+++" "+>"
                            "=:=" "==" "===" "==>" "=>" "=>>" "<=" "=<<" "=/="
                            ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>"
                            "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                            "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<="
                            "<<<" "<~" "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~"
                            "~~>" "%%"))
  (global-ligature-mode t))

;; ============================================================================
;; VISUAL CONFIGURATION
;; ============================================================================

;; Remove GUI elements for minimal look
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))   ; Remove toolbar icons
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))   ; Remove menu bar
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1)) ; Remove scroll bars
(setq ring-bell-function 'ignore)
(setq warning-minimum-level :error)

;; Default frame size and position (adjust as needed)
;; Width and height in characters
(add-to-list 'default-frame-alist '(width . 180))
(add-to-list 'default-frame-alist '(height . 55))

;; Frame position (pixels from top-left of screen)
;; Commented out - let window manager decide position
;; (add-to-list 'default-frame-alist '(left . 100))
;; (add-to-list 'default-frame-alist '(top . 100))

;; Dashboard setup
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)

  ;; Display recent files, projects, and bookmarks
  (setq dashboard-items '((recents . 5)
                          (projects . 5)
                          (bookmarks . 5)))

  ;; Custom dashboard icon (uncomment and set path if desired)
  ;; (setq dashboard-startup-banner "/path/to/your/icon.png")

  ;; Use projectile for project management
  (setq dashboard-projects-backend 'projectile))

;; SSH agent fix - load keychain environment for SSH keys
(use-package keychain-environment
  :ensure t
  :config
  (keychain-refresh-environment))

;; Add Go bin to exec-path (adjust path for your system)
;; Common paths: ~/go/bin (Linux/macOS), %USERPROFILE%\go\bin (Windows)
(add-to-list 'exec-path (expand-file-name "~/go/bin/"))

;; Enable eglot for go/typescript modes (both regular and tree-sitter variants)
(require 'eglot)

;; Configure Eglot settings before hooks
(setq eglot-sync-connect 1
      eglot-autoshutdown t
      eglot-send-changes-idle-time 0.5
      eglot-events-buffer-size 0  ;; Disable events buffer to reduce overhead
      eglot-connect-timeout 60)   ;; Increase connection timeout

;; Configure sourcekit-lsp for Swift
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(swift-mode . ("/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"))))

;; Ensure flymake is available
(require 'flymake)

;; Enable line numbers in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Emacs 30+ native flymake margin indicators
(setq flymake-margin-indicators-string
      '((error "!● " compilation-error)
        (warning "!▲ " compilation-warning)
        (note "!■ " compilation-info)))

;; Set margin width for flymake indicators
(setq-default left-margin-width 3)

;; Run goimports on save for Go files
(defun my/goimports-before-save ()
  "Run goimports on current buffer before saving, if in a Go mode."
  (when (derived-mode-p 'go-mode 'go-ts-mode)
    (let ((temp-file (make-temp-file "goimports" nil ".go"))
          (current-point (point)))
      (unwind-protect
          (progn
            (write-region (point-min) (point-max) temp-file nil 'silent)
            (when (zerop (call-process "goimports" nil nil nil "-w" temp-file))
              (erase-buffer)
              (insert-file-contents temp-file)
              (goto-char (min current-point (point-max)))))
        (delete-file temp-file)))))

(add-hook 'before-save-hook #'my/goimports-before-save)

;; Add eglot hooks for Go and TypeScript modes
(add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'go-ts-mode-hook 'eglot-ensure)
(add-hook 'typescript-mode-hook 'eglot-ensure)
(add-hook 'typescript-ts-mode-hook 'eglot-ensure)
(add-hook 'tsx-ts-mode-hook 'eglot-ensure)

;; Add eglot hook for Swift mode
(add-hook 'swift-mode-hook 'eglot-ensure)

;; Ensure flymake is enabled with eglot
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            ;; Enable flymake for diagnostics
            (flymake-mode 1)
            ;; Show flymake diagnostics first, as some LSP servers are slow
            (setq-local completion-at-point-functions
                        (list (cape-capf-buster #'eglot-completion-at-point)))
            ;; Enable automatic signature help
            (eldoc-mode 1)))

;; Cape - Completion At Point Extensions
(use-package cape
  :ensure t
  :init
  ;; Add useful defaults
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; Corfu-terminal - in-buffer completion popup for terminal
(use-package corfu-terminal
  :ensure t
  :init
  ;; corfu-terminal automatically requires corfu as a dependency
  (unless (display-graphic-p)
    (corfu-terminal-mode +1))
  :config
  (setq corfu-auto t)                 ; Enable automatic completion
  (setq corfu-auto-delay 0.2)         ; Show completions after 0.2s
  (setq corfu-auto-prefix 1)          ; Start completing after 1 character
  (setq corfu-cycle t)                ; Enable cycling through candidates
  (setq corfu-quit-no-match 'separator)  ; Don't quit on no match
  (setq corfu-preview-current nil)    ; Don't preview current candidate
  (setq corfu-preselect 'prompt)      ; Preselect the prompt
  (setq corfu-on-exact-match nil))    ; Don't auto-complete on exact match

;; Enable corfu mode globally
(global-corfu-mode)

;; Make TAB trigger completion, then indent if no completion available
(defun my-tab-indent-or-complete ()
  "Complete or indent depending on context."
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (or (completion-at-point)
        (indent-for-tab-command))))

;; Bind TAB to trigger completion
(global-set-key (kbd "TAB") #'my-tab-indent-or-complete)

;; Markdown configuration
(require 'markdown-mode)
(setq markdown-fontify-code-blocks-natively t)
(add-hook 'markdown-mode-hook
          (lambda ()
            (markdown-toggle-markup-hiding 1)
            (markdown-toggle-url-hiding 1)
            (corfu-mode -1)))



;; ============================================================================
;; PROJECT MANAGEMENT (Projectile + Treemacs + Vertico/Consult)
;; ============================================================================

;; Projectile - project interaction library
(use-package projectile
  :ensure t
  :bind-keymap
  ("s-p" . projectile-command-map)  ; Super/Command-p opens projectile menu
  ("C-c p" . projectile-command-map)  ; Keep traditional C-c p as alternative
  :config
  (projectile-mode +1)
  (setq projectile-completion-system 'default)
  (setq projectile-switch-project-action #'projectile-find-file))

;; Key bindings reminder:
;; s-p (Command-p on macOS) - Opens projectile command map
;; C-c p - Alternative projectile command map prefix
;; Common commands:
;;   s-p p or C-c p p - Switch project
;;   s-p f or C-c p f - Find file in project
;;   s-p s g or C-c p s g - Grep/search in project
;;   s-p ! or C-c p ! - Run shell command in project root
;;   s-p c or C-c p c - Compile project
;;   s-p k or C-c p k - Kill all project buffers

;; Directory tree viewer
;; Using treemacs for modern sidebar explorer
(require 'treemacs)
(use-package treemacs
  :config
  (treemacs-project-follow-mode 1))  ; Auto-follow current project

(use-package treemacs-projectile
  :ensure t)

;; Enable all-the-icons for treemacs
(use-package treemacs-all-the-icons
  :ensure t
  :after treemacs
  :config
  (treemacs-load-theme "all-the-icons"))

;; Disable tab-bar-mode and bind C-x t to treemacs
(tab-bar-mode -1)
(global-set-key (kbd "C-x t") 'treemacs)

;; Beacon - Never lose your cursor
(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

;; ============================================================================
;; COMPLETION FRAMEWORK (Vertico + Orderless + Consult + Marginalia)
;; ============================================================================

;; Vertico - vertical completion UI
(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :config
  (setq vertico-cycle t))

;; Orderless - flexible completion style with custom dispatch
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  :config
  ;; Custom orderless dispatchers for different search styles
  (defun my/orderless-literal-dispatcher (pattern _index _total)
    "Match PATTERN literally (default behavior for exact text)."
    ;; This is the default, so we don't need to do anything special
    nil)

  (defun my/orderless-fuzzy-dispatcher (pattern _index _total)
    "Match PATTERN with fuzzy matching when suffixed with ~."
    (when (string-suffix-p "~" pattern)
      `(orderless-flex . ,(substring pattern 0 -1))))

  (defun my/orderless-initialism-dispatcher (pattern _index _total)
    "Match PATTERN as initialism when suffixed with `."
    (when (string-suffix-p "`" pattern)
      `(orderless-initialism . ,(substring pattern 0 -1))))

  ;; Set up dispatchers
  (setq orderless-matching-styles '(orderless-literal)
        orderless-style-dispatchers '(my/orderless-fuzzy-dispatcher
                                      my/orderless-initialism-dispatcher)))

;; Marginalia - rich annotations in the minibuffer
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1)
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle)))

;; Consult - consulting completing-read
(use-package consult
  :ensure t
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r b" . consult-bookmark)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
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
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  ;; Optionally configure the register formatting
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  ;; Optionally tweak the register preview window
  (advice-add #'register-preview :override #'consult-register-window)
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  ;; Optionally configure preview
  (setq consult-preview-key 'any)
  (setq consult-narrow-key "<"))

;; Consult-Projectile - Integration between Consult and Projectile
(use-package consult-projectile
  :ensure t
  :after (consult projectile)
  :config
  ;; Override projectile commands with consult versions in the command map
  (define-key projectile-command-map (kbd "f") #'consult-projectile-find-file)
  (define-key projectile-command-map (kbd "p") #'consult-projectile-switch-project)
  (define-key projectile-command-map (kbd "b") #'consult-projectile-switch-to-buffer))

;; Embark - Context-aware actions on targets
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ; Pick an action for target at point
   ("C-;" . embark-dwim)        ; Run default action on target at point
   ("C-h B" . embark-bindings)) ; Alternative for `describe-bindings'
  :init
  ;; Show the Embark target at point via Eldoc
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))

  ;; Show which-key style indicators for available actions
  (setq embark-indicators
        '(embark-minimal-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator))

  ;; Optionally keep minibuffer open after acting (useful for multiple actions)
  ;; Set to nil to keep open by default, or use C-u prefix when needed
  ;; (setq embark-quit-after-action nil)

  ;; Add convenient quick-delete bindings
  (define-key embark-file-map (kbd "x") #'delete-file)
  (define-key embark-buffer-map (kbd "x") #'kill-buffer)

  ;; Add binding to open file as root/sudo
  (defun sudo-find-file (file)
    "Open FILE as root using sudo/TRAMP."
    (interactive "fFile: ")
    (find-file (if (file-remote-p file)
                   (concat "/" (file-remote-p file 'method) ":"
                           (file-remote-p file 'user) "@"
                           (file-remote-p file 'host) "|sudo:root:"
                           (file-remote-p file 'localname))
                 (concat "/sudo:root:" file))))

  (define-key embark-file-map (kbd "S") #'sudo-find-file))

;; Embark integration with Consult
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;disable backup
(setq make-backup-files nil)
(setq backup-inhibited t)
;disable auto save
(setq auto-save-default nil)
;; Always follow symlinks without asking
(setq vc-follow-symlinks t)

;; Automatically refresh buffers when files change on disk
(global-auto-revert-mode 1)

;; Window movement with C-x <arrow keys>
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)

;; Find file at point - smart file/URL opening
(ffap-bindings)

;; ============================================================================
;; QUICK ACCESS CONNECTIONS (C-c . prefix)
;; ============================================================================

;; Create a keymap for quick access commands
(defvar quick-access-map (make-sparse-keymap)
 "Keymap for quick access commands under C-c . prefix")

;; Bind the keymap to C-c .
(global-set-key (kbd "C-c .") quick-access-map)

;; Quick access bindings
(define-key quick-access-map (kbd "d") 'dashboard-open)      ; C-c . d - Dashboard
;; ============================================================================
;; IBUFFER - Enhanced Buffer Management
;; ============================================================================

;; Replace default buffer list with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; ibuffer configuration
(use-package ibuffer
  :ensure nil  ;; Built-in package
  :config
  ;; Don't show empty filter groups
  (setq ibuffer-show-empty-filter-groups nil)

  ;; Don't ask for confirmation to delete marked buffers
  (setq ibuffer-expert t)

  ;; Set up filter groups to organize buffers
  (setq ibuffer-saved-filter-groups
        '(("default"
           ("Emacs" (or (name . "^\\*scratch\\*$")
                        (name . "^\\*Messages\\*$")
                        (name . "^\\*dashboard\\*$")
                        (name . "^\\*claude")
                        (name . "^\\*.*\\*$")))
           ("Programming" (or (derived-mode . prog-mode)
                             (mode . go-mode)
                             (mode . go-ts-mode)
                             (mode . typescript-mode)
                             (mode . typescript-ts-mode)
                             (mode . swift-mode)))
           ("Magit" (name . "^magit"))
           ("Dired" (mode . dired-mode))
           ("Org" (mode . org-mode))
           ("Markdown" (mode . markdown-mode)))))

  ;; Auto-load saved filter groups
  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default"))))

;; Add all-the-icons to ibuffer
(use-package all-the-icons-ibuffer
  :ensure t
  :after ibuffer
  :hook (ibuffer-mode . all-the-icons-ibuffer-mode))

;; Load magit (keeping for now, can remove if you prefer lazygit entirely)
(require 'magit)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((claude-code :url
                  "https://github.com/stevemolitor/claude-code.el"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(proof-locked-face ((t (:foreground "#cccccc" :underline nil)))))
